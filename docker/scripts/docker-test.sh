#!/bin/bash
# Docker-based Odoo Testing Script
# This script runs comprehensive tests in the Docker environment before pushing to odoo.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$DOCKER_DIR/.." && pwd)"

# Default configuration
DEFAULT_MODULES="ai_config,ai_config_gemini,ai_chat"
TEST_TYPES="unit,integration"
TIMEOUT=300
VERBOSE=false

# Function to print status messages
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Show usage information
show_usage() {
    echo "Docker-based Odoo Testing Script"
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -m, --modules MODULE_LIST    Comma-separated list of modules to test (default: $DEFAULT_MODULES)"
    echo "  -t, --test-types TYPE_LIST   Comma-separated test types: unit,integration,e2e (default: $TEST_TYPES)"
    echo "  -T, --timeout SECONDS        Test timeout in seconds (default: $TIMEOUT)"
    echo "  -v, --verbose                Enable verbose output"
    echo "  -h, --help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                          # Run default tests"
    echo "  $0 -m ai_chat -t unit                      # Test only ai_chat module with unit tests"
    echo "  $0 -m ai_chat,ai_config -t unit,integration # Test multiple modules"
    echo "  $0 --verbose --timeout 600                 # Verbose mode with extended timeout"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--modules)
                MODULES="$2"
                shift 2
                ;;
            -t|--test-types)
                TEST_TYPES="$2"
                shift 2
                ;;
            -T|--timeout)
                TIMEOUT="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Set default modules if not specified
    MODULES=${MODULES:-$DEFAULT_MODULES}
}

# Check if Docker environment is ready
check_docker_environment() {
    print_info "Checking Docker environment..."
    
    cd "$DOCKER_DIR"
    
    # Check if docker-compose is available
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed"
        exit 1
    fi
    
    # Check if services are running
    if ! docker-compose ps | grep -q "Up"; then
        print_warning "Docker services are not running. Starting them..."
        docker-compose up -d
        sleep 30  # Wait for services to stabilize
    fi
    
    # Check Odoo health
    print_info "Checking Odoo service health..."
    local retries=0
    local max_retries=10
    
    while ! curl -sf http://localhost:8069/web/health &> /dev/null; do
        retries=$((retries + 1))
        if [[ $retries -ge $max_retries ]]; then
            print_error "Odoo service is not responding after $max_retries attempts"
            print_info "Check service logs: docker-compose logs odoo"
            exit 1
        fi
        print_info "Waiting for Odoo to be ready... (attempt $retries/$max_retries)"
        sleep 10
    done
    
    print_status "Docker environment is ready"
}

# Prepare test database
prepare_test_database() {
    local test_type="$1"
    local db_name="odoo18_test_${test_type}"
    
    print_info "Preparing test database: $db_name"
    
    cd "$DOCKER_DIR"
    
    # Drop existing test database if it exists
    docker-compose exec -T postgres psql -U odoo -c "DROP DATABASE IF EXISTS $db_name;" || true
    
    # Create fresh test database
    docker-compose exec -T postgres psql -U odoo -c "CREATE DATABASE $db_name;"
    
    # Install base modules
    print_info "Installing base modules in $db_name..."
    docker-compose exec -T odoo odoo \
        --database="$db_name" \
        --init=base \
        --stop-after-init \
        --without-demo=all \
        --log-level=warn
    
    print_status "Test database $db_name prepared"
}

# Install modules for testing
install_test_modules() {
    local test_type="$1"
    local db_name="odoo18_test_${test_type}"
    
    print_info "Installing modules for testing: $MODULES"
    
    cd "$DOCKER_DIR"
    
    # Install modules in dependency order
    IFS=',' read -ra MODULE_LIST <<< "$MODULES"
    for module in "${MODULE_LIST[@]}"; do
        module=$(echo "$module" | xargs)  # Trim whitespace
        
        print_info "Installing module: $module"
        
        if docker-compose exec -T odoo odoo \
            --database="$db_name" \
            --init="$module" \
            --stop-after-init \
            --without-demo=all \
            --log-level=warn; then
            print_status "Module $module installed successfully"
        else
            print_error "Failed to install module: $module"
            return 1
        fi
    done
    
    print_status "All modules installed successfully"
}

# Run unit tests
run_unit_tests() {
    local db_name="odoo18_test_unit"
    
    print_info "Running unit tests for modules: $MODULES"
    
    cd "$DOCKER_DIR"
    
    # Prepare database
    prepare_test_database "unit"
    install_test_modules "unit"
    
    # Run unit tests
    local test_command="odoo --database=$db_name --test-enable --test-tags=$MODULES --stop-after-init --log-level=test"
    
    if [[ "$VERBOSE" == "true" ]]; then
        test_command="$test_command --log-handler=odoo.tools.convert:DEBUG"
    fi
    
    print_info "Executing unit tests..."
    if timeout "$TIMEOUT" docker-compose exec -T odoo $test_command; then
        print_status "Unit tests passed"
        return 0
    else
        print_error "Unit tests failed"
        return 1
    fi
}

# Run integration tests
run_integration_tests() {
    local db_name="odoo18_test_integration"
    
    print_info "Running integration tests for modules: $MODULES"
    
    cd "$DOCKER_DIR"
    
    # Prepare database
    prepare_test_database "integration"
    install_test_modules "integration"
    
    # Run integration tests with demo data
    local test_command="odoo --database=$db_name --test-enable --test-tags=$MODULES --stop-after-init --log-level=test"
    
    if [[ "$VERBOSE" == "true" ]]; then
        test_command="$test_command --log-handler=odoo.tools.convert:DEBUG"
    fi
    
    print_info "Executing integration tests..."
    if timeout "$TIMEOUT" docker-compose exec -T odoo $test_command; then
        print_status "Integration tests passed"
        return 0
    else
        print_error "Integration tests failed"
        return 1
    fi
}

# Run end-to-end tests
run_e2e_tests() {
    local db_name="odoo18_test_e2e"
    
    print_info "Running end-to-end tests for modules: $MODULES"
    
    cd "$DOCKER_DIR"
    
    # Prepare database with demo data
    prepare_test_database "e2e"
    
    # Install modules with demo data for E2E tests
    print_info "Installing modules with demo data..."
    IFS=',' read -ra MODULE_LIST <<< "$MODULES"
    for module in "${MODULE_LIST[@]}"; do
        module=$(echo "$module" | xargs)
        
        docker-compose exec -T odoo odoo \
            --database="$db_name" \
            --init="$module" \
            --stop-after-init \
            --log-level=warn
    done
    
    # Run E2E tests
    print_info "Executing end-to-end tests..."
    if timeout "$TIMEOUT" docker-compose exec -T odoo odoo \
        --database="$db_name" \
        --test-enable \
        --test-tags="$MODULES" \
        --stop-after-init \
        --log-level=test; then
        print_status "End-to-end tests passed"
        return 0
    else
        print_error "End-to-end tests failed"
        return 1
    fi
}

# Generate test report
generate_test_report() {
    local test_results=("$@")
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local report_file="$DOCKER_DIR/logs/test-report-$(date '+%Y%m%d-%H%M%S').md"
    
    print_info "Generating test report..."
    
    mkdir -p "$DOCKER_DIR/logs"
    
    cat > "$report_file" << EOF
# Docker Test Report

**Generated**: $timestamp  
**Modules Tested**: $MODULES  
**Test Types**: $TEST_TYPES  
**Timeout**: ${TIMEOUT}s  

## Test Results

EOF
    
    local overall_status="✅ PASSED"
    IFS=',' read -ra TYPE_LIST <<< "$TEST_TYPES"
    local type_index=0
    
    for test_type in "${TYPE_LIST[@]}"; do
        test_type=$(echo "$test_type" | xargs)
        local result=${test_results[$type_index]}
        
        if [[ $result -eq 0 ]]; then
            echo "- **${test_type^} Tests**: ✅ PASSED" >> "$report_file"
        else
            echo "- **${test_type^} Tests**: ❌ FAILED" >> "$report_file"
            overall_status="❌ FAILED"
        fi
        
        type_index=$((type_index + 1))
    done
    
    cat >> "$report_file" << EOF

## Overall Status: $overall_status

## Environment Information
- **Docker Compose**: $(docker-compose version --short)
- **Odoo Version**: 18.0
- **Database**: PostgreSQL 15
- **Test Database**: odoo18_test_*

## Next Steps
EOF
    
    if [[ "$overall_status" == "✅ PASSED" ]]; then
        cat >> "$report_file" << EOF
✅ All tests passed successfully!
- Ready for deployment to odoo.sh
- Consider running additional performance tests
- Proceed with git push and odoo.sh deployment

EOF
    else
        cat >> "$report_file" << EOF
❌ Some tests failed!
- Review test output and fix issues
- Re-run tests after fixes
- Do not deploy to odoo.sh until all tests pass

EOF
    fi
    
    cat >> "$report_file" << EOF
## Commands Used
\`\`\`bash
# Test execution
$0 -m "$MODULES" -t "$TEST_TYPES" --timeout $TIMEOUT

# View logs
docker-compose logs odoo

# Debug failing tests
docker-compose exec odoo odoo shell --database=odoo18_test_unit
\`\`\`
EOF
    
    print_status "Test report generated: $report_file"
    echo "$report_file"
}

# Cleanup test resources
cleanup_test_resources() {
    print_info "Cleaning up test resources..."
    
    cd "$DOCKER_DIR"
    
    # Remove test databases
    IFS=',' read -ra TYPE_LIST <<< "$TEST_TYPES"
    for test_type in "${TYPE_LIST[@]}"; do
        test_type=$(echo "$test_type" | xargs)
        local db_name="odoo18_test_${test_type}"
        docker-compose exec -T postgres psql -U odoo -c "DROP DATABASE IF EXISTS $db_name;" || true
    done
    
    print_status "Test resources cleaned up"
}

# Main execution function
main() {
    local test_results=()
    local failed_tests=0
    
    echo -e "${BLUE}🐳 Docker-based Odoo Testing${NC}"
    echo "=================================="
    echo -e "Modules: ${MODULES}"
    echo -e "Test Types: ${TEST_TYPES}"
    echo -e "Timeout: ${TIMEOUT}s"
    echo -e "Verbose: ${VERBOSE}"
    echo ""
    
    # Parse arguments
    parse_arguments "$@"
    
    # Setup
    check_docker_environment
    
    # Run tests based on specified types
    IFS=',' read -ra TYPE_LIST <<< "$TEST_TYPES"
    for test_type in "${TYPE_LIST[@]}"; do
        test_type=$(echo "$test_type" | xargs)  # Trim whitespace
        
        case "$test_type" in
            unit)
                if run_unit_tests; then
                    test_results+=(0)
                else
                    test_results+=(1)
                    failed_tests=$((failed_tests + 1))
                fi
                ;;
            integration)
                if run_integration_tests; then
                    test_results+=(0)
                else
                    test_results+=(1)
                    failed_tests=$((failed_tests + 1))
                fi
                ;;
            e2e)
                if run_e2e_tests; then
                    test_results+=(0)
                else
                    test_results+=(1)
                    failed_tests=$((failed_tests + 1))
                fi
                ;;
            *)
                print_error "Unknown test type: $test_type"
                exit 1
                ;;
        esac
    done
    
    # Generate report
    local report_file=$(generate_test_report "${test_results[@]}")
    
    # Cleanup
    cleanup_test_resources
    
    # Final status
    echo ""
    echo "=================================="
    if [[ $failed_tests -eq 0 ]]; then
        print_status "All tests passed! ✨"
        print_info "Ready for odoo.sh deployment"
        echo -e "${GREEN}Next steps:${NC}"
        echo "  1. Review test report: $report_file"
        echo "  2. Commit your changes: git add . && git commit -m 'Your message'"
        echo "  3. Push to GitHub: git push origin your-branch"
        echo "  4. Deploy to odoo.sh and run second round of testing"
    else
        print_error "$failed_tests test suite(s) failed"
        print_info "Fix issues before deploying to odoo.sh"
        echo -e "${RED}Next steps:${NC}"
        echo "  1. Review test report: $report_file"
        echo "  2. Check logs: docker-compose logs odoo"
        echo "  3. Fix failing tests"
        echo "  4. Re-run tests: $0"
        exit 1
    fi
}

# Handle script interruption
trap 'echo -e "\n${RED}Testing interrupted by user${NC}"; cleanup_test_resources; exit 1' INT

# Run main function with all arguments
main "$@"