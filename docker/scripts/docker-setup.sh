#!/bin/bash
# Docker Environment Setup Script for Odoo 18 Enterprise Testing
# This script sets up the complete Docker testing environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "$DOCKER_DIR/.." && pwd)"

echo -e "${BLUE}🐳 Odoo 18 Enterprise Docker Environment Setup${NC}"
echo "=================================================="
echo -e "Docker directory: ${DOCKER_DIR}"
echo -e "Project root: ${PROJECT_ROOT}"
echo ""

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

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker Desktop."
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose."
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    
    print_status "All prerequisites met"
}

# Create necessary directories
setup_directories() {
    print_info "Setting up directory structure..."
    
    # Create config directories if they don't exist
    mkdir -p "$DOCKER_DIR/config/odoo"
    mkdir -p "$DOCKER_DIR/config/postgres/init"
    mkdir -p "$DOCKER_DIR/scripts"
    mkdir -p "$DOCKER_DIR/logs"
    mkdir -p "$DOCKER_DIR/backups"
    
    # Ensure user modules directory exists
    mkdir -p "$PROJECT_ROOT/user"
    
    print_status "Directory structure created"
}

# Validate Odoo project structure
validate_project_structure() {
    print_info "Validating Odoo project structure..."
    
    # Check for essential directories
    if [[ ! -d "$PROJECT_ROOT/odoo" ]]; then
        print_error "Odoo community directory not found at $PROJECT_ROOT/odoo"
        exit 1
    fi
    
    if [[ ! -d "$PROJECT_ROOT/enterprise" ]]; then
        print_warning "Enterprise directory not found at $PROJECT_ROOT/enterprise"
        print_info "Enterprise modules will not be available"
    fi
    
    if [[ ! -d "$PROJECT_ROOT/user" ]]; then
        print_warning "User modules directory not found, creating..."
        mkdir -p "$PROJECT_ROOT/user"
    fi
    
    print_status "Project structure validated"
}

# Setup environment file
setup_environment() {
    print_info "Setting up environment configuration..."
    
    ENV_FILE="$DOCKER_DIR/.env"
    
    if [[ ! -f "$ENV_FILE" ]]; then
        cat > "$ENV_FILE" << EOF
# Odoo 18 Enterprise Docker Environment Variables
# Generated automatically - modify as needed

# Database Configuration
POSTGRES_DB=odoo18_test
POSTGRES_USER=odoo
POSTGRES_PASSWORD=odoo_secure_2024

# Odoo Configuration
ODOO_ADMIN_PASSWORD=admin_secure_2024

# Redis Configuration
REDIS_PASSWORD=redis_secure_2024

# pgAdmin Configuration
PGADMIN_EMAIL=admin@odoo-test.local
PGADMIN_PASSWORD=pgadmin_secure_2024

# Project Paths
PROJECT_ROOT=$PROJECT_ROOT
DOCKER_DIR=$DOCKER_DIR

# Resource Limits
ODOO_WORKERS=0
ODOO_MAX_CRON_THREADS=1

# Testing Configuration
TEST_DATABASE_TEMPLATE=template0
EOF
        print_status "Environment file created"
    else
        print_status "Environment file already exists"
    fi
}

# Download and build Odoo image if needed
prepare_odoo_image() {
    print_info "Preparing Odoo Docker image..."
    
    # Check if we need to build a custom image
    if [[ -f "$DOCKER_DIR/Dockerfile" ]]; then
        print_info "Building custom Odoo image..."
        cd "$DOCKER_DIR"
        docker build -t odoo18-enterprise-test .
        print_status "Custom Odoo image built"
    else
        print_info "Using official Odoo image..."
        docker pull odoo:18.0
        print_status "Official Odoo image ready"
    fi
}

# Start the Docker environment
start_environment() {
    print_info "Starting Docker environment..."
    
    cd "$DOCKER_DIR"
    
    # Start core services
    docker-compose up -d postgres redis odoo
    
    print_status "Core services started"
    
    # Wait for services to be healthy
    print_info "Waiting for services to be ready..."
    
    # Wait for PostgreSQL
    echo -n "PostgreSQL: "
    while ! docker-compose exec -T postgres pg_isready -U odoo -d odoo18_test &> /dev/null; do
        echo -n "."
        sleep 2
    done
    echo " ✅"
    
    # Wait for Odoo
    echo -n "Odoo: "
    timeout=120
    elapsed=0
    while ! curl -sf http://localhost:8069/web/health &> /dev/null; do
        echo -n "."
        sleep 5
        elapsed=$((elapsed + 5))
        if [[ $elapsed -ge $timeout ]]; then
            print_warning "Odoo health check timeout, but continuing..."
            break
        fi
    done
    echo " ✅"
    
    print_status "All services are ready"
}

# Install and update AI modules
install_ai_modules() {
    print_info "Installing AI Chat modules..."
    
    cd "$DOCKER_DIR"
    
    # Install AI modules in dependency order
    AI_MODULES=(
        "ai_config"
        "ai_config_gemini" 
        "ai_chat"
        "ai_requisition_assistant"
    )
    
    for module in "${AI_MODULES[@]}"; do
        if [[ -d "$PROJECT_ROOT/user/$module" ]]; then
            print_info "Installing module: $module"
            docker-compose exec -T odoo odoo --config=/etc/odoo/odoo.conf --stop-after-init --init="$module" --without-demo=all
            if [[ $? -eq 0 ]]; then
                print_status "Module $module installed successfully"
            else
                print_warning "Module $module installation had issues"
            fi
        else
            print_warning "Module $module not found, skipping..."
        fi
    done
    
    print_status "AI modules installation complete"
}

# Run basic tests
run_basic_tests() {
    print_info "Running basic system tests..."
    
    cd "$DOCKER_DIR"
    
    # Test database connection
    if docker-compose exec -T postgres psql -U odoo -d odoo18_test -c "SELECT version();" &> /dev/null; then
        print_status "Database connection: OK"
    else
        print_error "Database connection: FAILED"
        return 1
    fi
    
    # Test Odoo web interface
    if curl -sf http://localhost:8069/web/login &> /dev/null; then
        print_status "Odoo web interface: OK"
    else
        print_error "Odoo web interface: FAILED"
        return 1
    fi
    
    # Test Redis connection
    if docker-compose exec -T redis redis-cli -a redis_secure_2024 ping | grep -q PONG; then
        print_status "Redis connection: OK"
    else
        print_warning "Redis connection: Check failed"
    fi
    
    print_status "Basic tests completed"
}

# Display environment information
show_environment_info() {
    echo ""
    echo -e "${GREEN}🎉 Docker Environment Setup Complete!${NC}"
    echo "=================================================="
    echo ""
    echo -e "${BLUE}📋 Environment Information:${NC}"
    echo "  • Odoo Web Interface: http://localhost:8069"
    echo "  • Admin Username: admin"
    echo "  • Admin Password: admin_secure_2024"
    echo "  • Database: odoo18_test"
    echo "  • PostgreSQL Port: 5433"
    echo "  • Redis Port: 6380"
    echo ""
    echo -e "${BLUE}🔧 Useful Commands:${NC}"
    echo "  • Start environment: docker-compose up -d"
    echo "  • Stop environment: docker-compose down"
    echo "  • View logs: docker-compose logs -f odoo"
    echo "  • Odoo shell: docker-compose exec odoo odoo shell"
    echo "  • Install module: docker-compose exec odoo odoo --init=MODULE_NAME"
    echo "  • Run tests: docker-compose exec odoo odoo --test-enable --test-tags=MODULE_NAME"
    echo ""
    echo -e "${BLUE}📁 Optional Services:${NC}"
    echo "  • pgAdmin: docker-compose --profile tools up -d pgadmin"
    echo "  • MailHog: docker-compose --profile tools up -d mailhog"
    echo "  • pgAdmin URL: http://localhost:8080"
    echo "  • MailHog URL: http://localhost:8025"
    echo ""
    echo -e "${YELLOW}⚠️  Important Notes:${NC}"
    echo "  • This is a development/testing environment only"
    echo "  • Use 'docker-compose down -v' to remove all data"
    echo "  • Check docker-compose logs if services fail to start"
    echo ""
}

# Main execution flow
main() {
    echo -e "${BLUE}Starting Odoo 18 Enterprise Docker setup...${NC}"
    echo ""
    
    check_prerequisites
    setup_directories
    validate_project_structure
    setup_environment
    prepare_odoo_image
    start_environment
    
    # Optional AI modules installation
    read -p "Install AI Chat modules? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_ai_modules
    fi
    
    run_basic_tests
    show_environment_info
    
    print_status "Setup completed successfully! 🚀"
}

# Handle script interruption
trap 'echo -e "\n${RED}Setup interrupted by user${NC}"; exit 1' INT

# Run main function
main "$@"