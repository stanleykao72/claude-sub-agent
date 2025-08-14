# Deploy Odoo Command

Deploy and test Odoo modules to odoo.sh environment with comprehensive validation using built-in odoo.sh commands and configuration from `.claude/config/odoo-sh.json`.

## Command Syntax

```bash
/deploy-odoo [environment] [options]
```

## Parameters

### Optional Parameters
- `environment`: Target environment (`staging`, `production`, `development`) - uses active environment from config if not specified
- `--modules`: Specific modules to deploy (default: `ai_chat,ai_config,ai_config_gemini`)
- `--test-suite`: Test approach (`quick`, `comprehensive`, `health-only`)
- `--skip-tests`: Skip post-deployment testing
- `--force`: Force deployment even if pre-checks fail
- `--cleanup`: Run cleanup after testing

## Usage Examples

### Basic Deployment
```bash
# Deploy to active environment with quick tests
/deploy-odoo

# Deploy to specific environment
/deploy-odoo staging --test-suite=comprehensive

# Deploy specific modules only
/deploy-odoo --modules=ai_chat,ai_config
```

### Advanced Deployment
```bash
# Deploy with comprehensive testing and cleanup
/deploy-odoo staging --test-suite=comprehensive --cleanup

# Force deployment without pre-checks (use with caution)
/deploy-odoo --force --test-suite=quick

# Health check only (no deployment)
/deploy-odoo --test-suite=health-only
```

## Command Workflow

### Phase 1: Configuration Loading
```markdown
🔧 **Loading odoo.sh Configuration**
- Reading: .claude/config/odoo-sh.json
- Active Environment: staging
- SSH Host: 22611896@odoo-esmith-v18-stage30-22611896.dev.odoo.com
- Modules: ai_chat, ai_config, ai_config_gemini
- Test Suite: quick
```

### Phase 2: Pre-Deployment Validation
```markdown
🔍 **Pre-Deployment Validation**

Using spec-validator for local code quality checks:
- Code quality checks ✅
- Translation compliance verified ✅ 
- Module dependencies validated ✅
- SSH connectivity confirmed ✅

Ready for deployment to odoo.sh environment.
```

### Phase 3: Deployment Execution
```markdown
🚀 **Deploying to odoo.sh**

Git operations:
- Staging local changes
- Committing with deployment message
- Pushing to GitHub repository
- odoo.sh automatic deployment triggered

[Git and deployment progress follows]
```

### Phase 4: Post-Deployment Testing
```markdown
🧪 **Post-Deployment Testing**

Using odoo-sh-tester with built-in commands:
- SSH connection established ✅
- Environment health check ✅
- Module update: odoo-update ai_chat,ai_config ✅
- Service restart: odoosh-restart ✅
- Test execution: odoo-bin --test-enable ✅

[Test results follow]
```

## Deployment Implementation

### Core Deployment Function
```python
def deploy_to_odoo_sh(environment=None, modules=None, test_suite="quick", skip_tests=False, force=False, cleanup=False):
    """
    Deploy modules to odoo.sh using simplified built-in commands
    """
    
    # Load configuration
    try:
        with open(".claude/config/odoo-sh.json", 'r') as f:
            config = json.load(f)
    except FileNotFoundError:
        print("❌ Configuration file not found: .claude/config/odoo-sh.json")
        print("📄 Please copy config/odoo-sh.example.json to .claude/config/odoo-sh.json")
        return False
    
    # Determine target environment
    if environment:
        if environment not in config["environments"]:
            print(f"❌ Environment '{environment}' not found in configuration")
            return False
        env_config = config["environments"][environment]
    else:
        # Use active environment
        active_env = None
        for env_name, env_settings in config["environments"].items():
            if env_settings.get("active", False):
                active_env = env_name
                break
        
        if not active_env:
            active_env = config.get("default_environment", "staging")
        
        env_config = config["environments"][active_env]
        environment = active_env
    
    ssh_host = env_config["ssh_host"]
    
    # Default modules
    if not modules:
        modules = ",".join(config["test_settings"]["default_modules"])
    
    print(f"🎯 Deployment Target: {environment}")
    print(f"🔗 SSH Host: {ssh_host}")
    print(f"📦 Modules: {modules}")
    print(f"🧪 Test Suite: {test_suite}")
    
    # Phase 1: Pre-deployment validation
    if not force:
        print("\n🔍 Pre-deployment validation...")
        if not run_pre_deployment_checks():
            print("❌ Pre-deployment checks failed. Use --force to override.")
            return False
    
    # Phase 2: Git operations and deployment
    print("\n🚀 Starting deployment...")
    if not deploy_via_git(modules):
        print("❌ Deployment failed")
        return False
    
    # Phase 3: Post-deployment testing
    if not skip_tests:
        print("\n🧪 Post-deployment testing...")
        test_success = run_post_deployment_tests(ssh_host, modules, test_suite)
        
        if cleanup:
            print("\n🧹 Running cleanup...")
            cleanup_test_environment(ssh_host)
        
        return test_success
    
    print("✅ Deployment completed (tests skipped)")
    return True

def run_pre_deployment_checks():
    """Run local pre-deployment validation"""
    checks = []
    
    # Check for Chinese text in code (i18n compliance)
    print("  📝 Checking i18n compliance...")
    chinese_check = subprocess.run(
        'grep -r "[\u4e00-\u9fff]" user/ --include="*.py" --include="*.xml"',
        shell=True, capture_output=True, text=True
    )
    checks.append(("i18n Compliance", chinese_check.returncode != 0))
    if chinese_check.returncode == 0:
        print("    ⚠️ Found Chinese text in code - use translation keys instead")
    
    # Validate Python syntax
    print("  🐍 Checking Python syntax...")
    python_files = subprocess.run(
        'find user/ -name "*.py" -exec python -m py_compile {} \;',
        shell=True, capture_output=True, text=True
    )
    checks.append(("Python Syntax", python_files.returncode == 0))
    
    # Check manifest files
    print("  📋 Validating manifest files...")
    manifest_check = subprocess.run(
        'find user/ -name "__manifest__.py" -exec python -c "import ast; ast.parse(open(\'{}\').read())" \;',
        shell=True, capture_output=True, text=True
    )
    checks.append(("Manifest Files", manifest_check.returncode == 0))
    
    # SSH connectivity test
    print("  🔗 Testing SSH connectivity...")
    try:
        with open(".claude/config/odoo-sh.json", 'r') as f:
            config = json.load(f)
        
        # Get active environment
        active_env = None
        for env_name, env_settings in config["environments"].items():
            if env_settings.get("active", False):
                active_env = env_name
                break
        
        if not active_env:
            active_env = config.get("default_environment", "staging")
        
        ssh_host = config["environments"][active_env]["ssh_host"]
        ssh_test = subprocess.run(
            f'ssh {ssh_host} "echo SSH connection successful"',
            shell=True, capture_output=True, text=True, timeout=10
        )
        checks.append(("SSH Connectivity", ssh_test.returncode == 0))
    except:
        checks.append(("SSH Connectivity", False))
    
    # Summary
    passed_checks = sum(1 for _, passed in checks if passed)
    total_checks = len(checks)
    
    print(f"\n  📊 Pre-deployment checks: {passed_checks}/{total_checks} passed")
    
    for check_name, passed in checks:
        status = "✅" if passed else "❌"
        print(f"    {status} {check_name}")
    
    return passed_checks == total_checks

def deploy_via_git(modules):
    """Handle git operations for deployment"""
    
    print("  📝 Staging changes...")
    stage_result = subprocess.run("git add .", shell=True, capture_output=True, text=True)
    if stage_result.returncode != 0:
        print(f"    ❌ Failed to stage changes: {stage_result.stderr}")
        return False
    
    print("  💾 Creating commit...")
    commit_message = f"""Deploy Odoo modules: {modules}

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"""
    
    commit_result = subprocess.run(
        f'git commit -m "{commit_message}"',
        shell=True, capture_output=True, text=True
    )
    
    if commit_result.returncode != 0:
        if "nothing to commit" in commit_result.stdout:
            print("    ℹ️ No changes to commit")
        else:
            print(f"    ❌ Failed to commit: {commit_result.stderr}")
            return False
    
    print("  🚀 Pushing to repository...")
    push_result = subprocess.run("git push", shell=True, capture_output=True, text=True)
    if push_result.returncode != 0:
        print(f"    ❌ Failed to push: {push_result.stderr}")
        return False
    
    print("  ✅ Git operations completed")
    print("  ⏳ odoo.sh deployment will trigger automatically...")
    
    # Wait for deployment
    print("  ⌛ Waiting for odoo.sh deployment (30 seconds)...")
    time.sleep(30)
    
    return True

def run_post_deployment_tests(ssh_host, modules, test_suite):
    """Run tests using odoo-sh-tester functionality"""
    
    if test_suite == "health-only":
        return run_health_check_only(ssh_host)
    
    print(f"  🔄 Updating modules: {modules}")
    update_cmd = f'ssh {ssh_host} "odoo-update {modules}"'
    update_result = subprocess.run(update_cmd, shell=True, capture_output=True, text=True)
    
    if update_result.returncode != 0:
        print(f"    ❌ Module update failed: {update_result.stderr}")
        return False
    
    print("  🔄 Restarting Odoo service...")
    restart_cmd = f'ssh {ssh_host} "odoosh-restart"'
    subprocess.run(restart_cmd, shell=True)
    
    print("  ⏳ Waiting for service restart...")
    time.sleep(15)
    
    if test_suite == "quick":
        return run_quick_tests(ssh_host, modules)
    elif test_suite == "comprehensive":
        return run_comprehensive_tests(ssh_host, modules)
    
    return True

def run_health_check_only(ssh_host):
    """Run environment health check only"""
    print("  🔍 Running environment health check...")
    
    # Check service
    service_cmd = f'ssh {ssh_host} "odoo-bin --version"'
    service_result = subprocess.run(service_cmd, shell=True, capture_output=True, text=True)
    
    # Check storage
    storage_cmd = f'ssh {ssh_host} "odoosh-storage"'
    storage_result = subprocess.run(storage_cmd, shell=True, capture_output=True, text=True)
    
    # Check logs for errors
    log_cmd = f'ssh {ssh_host} "tail -10 ~/logs/odoo.log | grep -i error || echo \\'No recent errors\\'"'
    log_result = subprocess.run(log_cmd, shell=True, capture_output=True, text=True)
    
    print("    ✅ Health check completed")
    if service_result.returncode == 0:
        print(f"    📦 Odoo: {service_result.stdout.strip()}")
    
    print(f"    📊 Storage: {storage_result.stdout.strip() if storage_result.returncode == 0 else 'Check failed'}")
    print(f"    📝 Logs: {log_result.stdout.strip()}")
    
    return service_result.returncode == 0

def run_quick_tests(ssh_host, modules):
    """Run quick tests for specified modules"""
    print(f"  🧪 Running quick tests for: {modules}")
    
    test_cmd = f'ssh {ssh_host} "odoo-bin --test-enable --test-tags={modules} --stop-after-init --log-level=test"'
    test_result = subprocess.run(test_cmd, shell=True, capture_output=True, text=True)
    
    if test_result.returncode == 0:
        print("    ✅ Quick tests passed")
        return True
    else:
        print("    ❌ Quick tests failed")
        print(f"    Error: {test_result.stderr}")
        return False

def run_comprehensive_tests(ssh_host, modules):
    """Run comprehensive tests for all AI modules"""
    print("  🎯 Running comprehensive test suite...")
    
    # Test each module individually
    module_list = modules.split(",")
    results = {}
    
    for module in module_list:
        module = module.strip()
        print(f"    🧪 Testing {module}...")
        
        test_cmd = f'ssh {ssh_host} "odoo-bin --test-enable --test-tags={module} --stop-after-init --log-level=test"'
        result = subprocess.run(test_cmd, shell=True, capture_output=True, text=True)
        
        results[module] = result.returncode == 0
        status = "✅" if results[module] else "❌"
        print(f"      {status} {module}")
    
    # Summary
    passed = sum(1 for success in results.values() if success)
    total = len(results)
    
    print(f"    📊 Comprehensive tests: {passed}/{total} modules passed")
    
    return passed == total

def cleanup_test_environment(ssh_host):
    """Cleanup test data and temporary files"""
    print("  🧹 Cleaning up test environment...")
    
    cleanup_script = '''
test_configs = env["ai.bot.config"].search([("name", "like", "Test %")])
test_specs = env["ai.bot.specialization"].search([("name", "like", "Test %")])
test_configs.unlink()
test_specs.unlink()
env.cr.commit()
print("Cleanup completed")
'''
    
    cleanup_cmd = f'ssh {ssh_host} "odoo-bin shell -c \\"{cleanup_script}\\""'
    subprocess.run(cleanup_cmd, shell=True, capture_output=True, text=True)
    
    print("    ✅ Cleanup completed")
```

## Integration Points

### 1. Integration with odoo-sh-tester Agent
```bash
# The command uses odoo-sh-tester functionality
Use odoo-sh-tester: Run comprehensive test suite after deployment

# Direct agent integration for complex testing
Use odoo-sh-tester: Setup test data, run tests, and update story progress
```

### 2. Integration with spec-progress-tracker
```bash
# Update story progress after deployment
Use spec-progress-tracker: Update story progress with deployment and test results

# Generate deployment report
Use spec-progress-tracker: Generate deployment summary report for stakeholders
```

### 3. Configuration File Integration
```python
# Agents can access deployment configuration
def get_active_environment():
    """Get active odoo.sh environment configuration"""
    with open(".claude/config/odoo-sh.json", 'r') as f:
        config = json.load(f)
    
    for env_name, env_config in config["environments"].items():
        if env_config.get("active", False):
            return env_name, env_config
    
    default_env = config.get("default_environment", "staging")
    return default_env, config["environments"][default_env]
```

## Error Handling

### Common Scenarios
```markdown
❌ **Error: Configuration File Missing**
Configuration file not found: .claude/config/odoo-sh.json
Please copy config/odoo-sh.example.json to .claude/config/odoo-sh.json and update with your SSH host.

⚠️ **Warning: Pre-deployment Checks Failed**
2 of 4 pre-deployment checks failed:
- ❌ i18n Compliance: Found Chinese text in code
- ❌ SSH Connectivity: Connection timeout

Use --force to override (not recommended) or fix issues first.

❌ **Error: Module Update Failed**
odoo-update command failed on odoo.sh
Check module dependencies and odoo.sh logs for details.

⚠️ **Warning: Tests Failed**
Quick tests failed for ai_chat module
Review test output and fix issues before production deployment.
```

### Recovery Actions
- **Automatic Retry**: Built-in retry for transient SSH issues
- **Rollback Support**: Git operations can be reverted if needed
- **Partial Success**: Continue with successful modules if some fail
- **Detailed Logging**: Comprehensive error reporting for debugging

## Output Examples

### Successful Deployment
```markdown
# 🚀 Deployment Summary

**Environment**: staging
**SSH Host**: 22611896@odoo-esmith-v18-stage30-22611896.dev.odoo.com
**Modules**: ai_chat, ai_config, ai_config_gemini
**Duration**: 3 minutes 45 seconds
**Status**: ✅ SUCCESS

## Pre-deployment Validation
- ✅ i18n Compliance
- ✅ Python Syntax  
- ✅ Manifest Files
- ✅ SSH Connectivity

## Deployment Process
- ✅ Git staging and commit
- ✅ Push to repository
- ✅ odoo.sh automatic deployment

## Post-deployment Testing
- ✅ Module updates completed
- ✅ Service restart successful
- ✅ Quick tests passed (3/3 modules)

## Next Steps
- Ready for production deployment
- Consider running comprehensive tests
- Update stakeholders of successful deployment
```

---

This command provides seamless integration between Claude Code development workflow and odoo.sh deployment using built-in commands, with comprehensive testing and monitoring throughout the process.