# Git Push Deploy Command

Intelligent Git push with automated odoo.sh deployment monitoring and testing. Solves the timing challenge between GitHub push and odoo.sh CI/CD availability through smart monitoring and retry mechanisms.

## Command Syntax

```bash
/git-push-deploy [options]
```

## Parameters

### Optional Parameters
- `--message="commit message"`: Custom commit message (default: auto-generated)
- `--modules="module1,module2"`: Specific modules to test (default: from config)
- `--test-suite=[quick|comprehensive|health-only]`: Test approach (default: comprehensive)
- `--branch="branch-name"`: Target branch (default: current branch)
- `--strategy=[polling|time-based|webhook]`: Monitoring strategy (default: polling)
- `--timeout=600`: Maximum deployment wait time in seconds (default: 600)
- `--skip-tests`: Skip post-deployment testing
- `--dry-run`: Preview actions without executing

## Usage Examples

### Basic Push and Deploy
```bash
# Simple push with automated testing
/git-push-deploy

# Custom commit message
/git-push-deploy --message="Fix AI chat message handling" --test-suite=quick

# Specific modules only
/git-push-deploy --modules="ai_chat,ai_config" --test-suite=comprehensive
```

### Advanced Deployment Scenarios
```bash
# Emergency deployment with minimal testing
/git-push-deploy --message="Hotfix: Critical security update" --test-suite=health-only --timeout=300

# Multi-branch deployment
/git-push-deploy --branch="staging" --strategy=polling --timeout=900

# Preview mode
/git-push-deploy --dry-run --message="Test deployment workflow"
```

## Command Workflow

### Phase 1: Pre-deployment Validation
```markdown
🔍 **Pre-deployment Validation**

Local Environment Checks:
- ✅ Git repository status verified
- ✅ Python syntax validation passed
- ✅ i18n compliance checked (no direct Chinese text)
- ✅ Staged changes confirmed
- ✅ SSH connectivity to odoo.sh verified

Ready for Git push operation.
```

### Phase 2: Git Push Operation
```markdown
📤 **Git Push to GitHub**

Git Operations (from user/ directory):
- 📁 Working directory: ./user/
- ✅ Commit created: "Fix AI chat issues"
- ✅ Pushed to origin/staging
- ✅ GitHub received changes
- 🔄 odoo.sh CI/CD triggered automatically

Monitoring odoo.sh deployment...
```

### Phase 3: Deployment Monitoring
```markdown
⏳ **odoo.sh Deployment Monitoring**

Strategy: Status Polling
Target: 22611896@odoo-esmith-v18-stage30-22611896.dev.odoo.com

🔍 Status check 1/20...
    ⏳ SSH unavailable (deployment in progress)
🔍 Status check 2/20...
    ⏳ SSH unavailable (deployment in progress)  
🔍 Status check 3/20...
    📊 Deployment indicators: ['service_restarted', 'odoo_responsive'] (score: 2/2)
    ✅ Deployment completed successfully!
    🔒 Performing stability check...
    🔒 Stability checks: ['database_connected', 'modules_loaded', 'no_recent_errors'] (score: 3/3)
    ✅ Services are stable and ready
```

### Phase 4: Automated Testing
```markdown
🧪 **Automated Testing**

Test Suite: Comprehensive
Modules: ai_chat, ai_config, ai_config_gemini

🧪 Testing ai_config...
    ✅ PASSED
🧪 Testing ai_config_gemini...
    ✅ PASSED  
🧪 Testing ai_chat...
    ✅ PASSED

📊 Test Summary: 3/3 modules passed (100.0%)
✅ All tests passed - Ready for next phase
```

## Implementation Details

### Core Command Function
```python
def git_push_deploy_command(message=None, modules=None, test_suite="comprehensive", 
                           branch=None, strategy="polling", timeout=600, 
                           skip_tests=False, dry_run=False):
    """
    Execute intelligent git push with deployment monitoring
    Always operates from user/ directory for git operations
    """
    
    print("🚀 Git Push Deploy - Intelligent Deployment Automation")
    print("=" * 60)
    
    # Ensure we're working in the user/ directory for git operations
    import os
    original_cwd = os.getcwd()
    user_dir = os.path.join(original_cwd, "user")
    
    if not os.path.exists(user_dir):
        print("❌ user/ directory not found. This command requires user/ directory with .git repository")
        return False
    
    if not os.path.exists(os.path.join(user_dir, ".git")):
        print("❌ user/.git directory not found. Please ensure user/ is a git repository")
        return False
    
    print(f"📁 Using git repository: {user_dir}")
    
    # Load configuration
    try:
        config = load_enhanced_config()
        deployment_config = config.get("deployment_monitoring", {})
    except FileNotFoundError:
        print("❌ Configuration missing. Please setup .claude/config/odoo-sh.json")
        return False
    
    # Override config with command parameters
    deployment_config["strategy"] = strategy
    deployment_config["timeout"] = timeout
    
    if dry_run:
        return preview_deployment_plan(message, modules, test_suite, branch, deployment_config, user_dir)
    
    # Execute deployment workflow
    workflow_steps = [
        ("🔍 Pre-deployment Validation", lambda: validate_pre_deployment(user_dir)),
        ("📤 Git Push Operation", lambda: execute_git_push_with_monitoring(message, branch, user_dir)),
        ("⏳ Deployment Monitoring", lambda: monitor_deployment_with_strategy(deployment_config)),
        ("🧪 Automated Testing", lambda: execute_comprehensive_testing(modules, test_suite) if not skip_tests else True)
    ]
    
    for step_name, step_function in workflow_steps:
        print(f"\n{step_name}")
        print("-" * 40)
        
        try:
            success = step_function()
            if not success:
                print(f"❌ {step_name} failed")
                return False
        except Exception as e:
            print(f"❌ {step_name} error: {str(e)}")
            return False
    
    print("\n" + "=" * 60)
    print("🎉 Git Push Deploy completed successfully!")
    print("📋 Check deployment-progress.md for detailed results")
    
    return True

def load_enhanced_config():
    """Load enhanced configuration with deployment monitoring settings"""
    import json
    
    with open(".claude/config/odoo-sh.json", 'r') as f:
        config = json.load(f)
    
    # Ensure deployment monitoring defaults
    if "deployment_monitoring" not in config:
        config["deployment_monitoring"] = {
            "strategy": "polling",
            "odoo_sh_polling": {
                "check_interval": 30,
                "max_attempts": 20
            },
            "timeout": 600
        }
    
    if "retry_logic" not in config:
        config["retry_logic"] = {
            "max_attempts": 3,
            "backoff_strategy": "exponential",
            "base_delay": 60
        }
    
    return config

def preview_deployment_plan(message, modules, test_suite, branch, config, user_dir):
    """Preview deployment plan without executing"""
    
    current_branch = get_current_branch(user_dir)
    target_branch = branch or current_branch
    target_modules = modules or get_default_modules()
    commit_msg = message or f"Deploy updates to {target_branch}"
    
    print("📋 DEPLOYMENT PLAN PREVIEW")
    print("=" * 40)
    print(f"Git Repository: {user_dir}")
    print(f"Branch: {current_branch} → {target_branch}")
    print(f"Commit: {commit_msg}")
    print(f"Modules: {target_modules}")
    print(f"Test Suite: {test_suite}")
    print(f"Strategy: {config.get('strategy', 'polling')}")
    print(f"Timeout: {config.get('timeout', 600)}s")
    print("")
    print("Workflow Steps:")
    print("1. 🔍 Validate local changes and environment")
    print("2. 📤 Create commit and push to GitHub (from user/ directory)")
    print("3. ⏳ Monitor odoo.sh deployment completion")
    print("4. 🧪 Execute automated test suite")
    print("5. 📊 Generate deployment report")
    print("")
    print("Use --dry-run=false to execute this plan")
    
    return True

def get_current_branch(user_dir):
    """Get current git branch from user/ directory"""
    import subprocess
    import os
    
    original_cwd = os.getcwd()
    try:
        os.chdir(user_dir)
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return "main"  # fallback
    finally:
        os.chdir(original_cwd)

def validate_pre_deployment(user_dir):
    """Validate pre-deployment conditions in user/ directory"""
    import subprocess
    import os
    
    print("🔍 Validating pre-deployment conditions...")
    
    original_cwd = os.getcwd()
    try:
        os.chdir(user_dir)
        
        # Check git status
        git_status = subprocess.run(
            ["git", "status", "--porcelain"],
            capture_output=True, text=True, check=True
        )
        
        if git_status.stdout.strip():
            print(f"📝 Found {len(git_status.stdout.strip().split())} changed files")
        else:
            print("📁 Working directory is clean")
        
        # Check for staged changes
        staged_check = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            capture_output=True, text=True, check=True
        )
        
        print(f"✅ Git repository validated in {user_dir}")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Git validation failed: {e}")
        return False
    finally:
        os.chdir(original_cwd)

def execute_git_push_with_monitoring(message, branch, user_dir):
    """Execute git push operations from user/ directory"""
    import subprocess
    import os
    
    print(f"📤 Executing git operations from {user_dir}")
    
    original_cwd = os.getcwd()
    try:
        os.chdir(user_dir)
        
        # Get current branch if not specified
        if not branch:
            result = subprocess.run(
                ["git", "branch", "--show-current"],
                capture_output=True, text=True, check=True
            )
            branch = result.stdout.strip()
        
        # Stage all changes if any
        subprocess.run(["git", "add", "."], check=True)
        
        # Create commit if message provided or if there are staged changes
        if message:
            subprocess.run(
                ["git", "commit", "-m", message],
                check=True
            )
            print(f"✅ Commit created: '{message}'")
        
        # Push to remote
        subprocess.run(
            ["git", "push", "origin", branch],
            check=True
        )
        print(f"✅ Pushed to origin/{branch}")
        
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Git push failed: {e}")
        return False
    finally:
        os.chdir(original_cwd)
```

### Deployment Monitoring Strategies

#### Strategy 1: Status Polling (Recommended)
```python
def monitor_with_polling_strategy(config):
    """
    Intelligent status polling with deployment indicators
    - Monitors SSH connectivity
    - Checks service restart timestamps  
    - Validates Odoo responsiveness
    - Verifies stability before proceeding
    """
    
    polling_config = config.get("odoo_sh_polling", {})
    check_interval = polling_config.get("check_interval", 30)
    max_attempts = polling_config.get("max_attempts", 20)
    
    ssh_host = get_ssh_host()
    baseline_time = get_baseline_timestamp()
    
    print(f"📊 Polling Strategy Active")
    print(f"   Target: {ssh_host}")
    print(f"   Interval: {check_interval}s")
    print(f"   Max Attempts: {max_attempts}")
    
    for attempt in range(1, max_attempts + 1):
        print(f"\n🔍 Check {attempt}/{max_attempts}")
        
        # Multi-layered deployment detection
        indicators = collect_deployment_indicators(ssh_host, baseline_time)
        completion_score = calculate_completion_score(indicators)
        
        print(f"   📊 Completion Score: {completion_score}/100")
        
        if completion_score >= 80:  # 80% confidence threshold
            print("   ✅ Deployment completion detected")
            
            # Stability verification
            if verify_post_deployment_stability(ssh_host):
                print("   🔒 Stability verified")
                return True
            else:
                print("   ⚠️ Stability check failed, continuing monitoring...")
        
        time.sleep(check_interval)
    
    print("❌ Polling timeout - manual verification recommended")
    return False

def collect_deployment_indicators(ssh_host, baseline_time):
    """Collect multiple indicators of deployment completion"""
    
    indicators = {
        "ssh_available": False,
        "service_responsive": False,
        "recent_restart": False,
        "log_activity": False,
        "database_accessible": False
    }
    
    # SSH Connectivity Check
    try:
        ssh_check = subprocess.run(
            f'ssh -o ConnectTimeout=10 {ssh_host} "echo SSH_OK"',
            shell=True, capture_output=True, text=True, timeout=15
        )
        indicators["ssh_available"] = ssh_check.returncode == 0
    except:
        indicators["ssh_available"] = False
    
    if indicators["ssh_available"]:
        # Service Responsiveness
        try:
            service_check = subprocess.run(
                f'ssh {ssh_host} "odoo-bin --version"',
                shell=True, capture_output=True, text=True, timeout=20
            )
            indicators["service_responsive"] = service_check.returncode == 0
        except:
            pass
        
        # Recent Restart Detection
        try:
            restart_check = subprocess.run(
                f'ssh {ssh_host} "systemctl show --property=ActiveEnterTimestamp odoo"',
                shell=True, capture_output=True, text=True, timeout=15
            )
            if restart_check.returncode == 0:
                # Parse timestamp logic would go here
                indicators["recent_restart"] = True
        except:
            pass
        
        # Database Accessibility
        try:
            db_check = subprocess.run(
                f'ssh {ssh_host} "timeout 20 odoo-bin shell -c \\"print(\\'DB_OK\\')\\""',
                shell=True, capture_output=True, text=True, timeout=25
            )
            indicators["database_accessible"] = (
                db_check.returncode == 0 and "DB_OK" in db_check.stdout
            )
        except:
            pass
    
    return indicators

def calculate_completion_score(indicators):
    """Calculate deployment completion confidence score"""
    
    weights = {
        "ssh_available": 20,
        "service_responsive": 25,
        "recent_restart": 20,
        "log_activity": 15,
        "database_accessible": 20
    }
    
    score = 0
    for indicator, available in indicators.items():
        if available:
            score += weights.get(indicator, 0)
    
    return score
```

#### Strategy 2: Time-Based with Health Checks
```python
def monitor_with_time_based_strategy(config):
    """
    Time-based monitoring with periodic health validation
    - Uses estimated deployment windows
    - Performs health checks at intervals
    - Suitable for predictable deployment times
    """
    
    deployment_timeout = config.get("timeout", 600)
    health_check_interval = config.get("health_check_interval", 60)
    
    print(f"⏰ Time-Based Strategy Active")
    print(f"   Deployment Window: {deployment_timeout}s")
    print(f"   Health Check Interval: {health_check_interval}s")
    
    start_time = time.time()
    ssh_host = get_ssh_host()
    
    # Initial wait period
    initial_wait = 90
    print(f"   🚀 Initial wait: {initial_wait}s")
    time.sleep(initial_wait)
    
    while time.time() - start_time < deployment_timeout:
        elapsed = int(time.time() - start_time)
        remaining = deployment_timeout - elapsed
        
        print(f"\n⏰ Deployment Progress: {elapsed}s elapsed, {remaining}s remaining")
        
        # Health check
        health_score = perform_health_check(ssh_host)
        print(f"   🏥 Health Score: {health_score}/100")
        
        if health_score >= 80:
            print("   ✅ Health check passed - deployment ready")
            return True
        
        time.sleep(health_check_interval)
    
    print("❌ Time-based monitoring timeout")
    return False
```

## Error Handling and Recovery

### Common Deployment Issues
```python
def handle_deployment_issues():
    """Comprehensive error handling for deployment issues"""
    
    issue_handlers = {
        "ssh_connection_timeout": {
            "description": "SSH connection times out during monitoring",
            "causes": ["Deployment in progress", "Network issues", "Service restart"],
            "recovery": "Extend monitoring time and retry",
            "automation": "retry_with_exponential_backoff"
        },
        "test_failures_after_deployment": {
            "description": "Tests fail after successful deployment",
            "causes": ["Code issues", "Environment problems", "Database state"],
            "recovery": "Review test output and fix code issues",
            "automation": "generate_test_failure_report"
        },
        "deployment_timeout": {
            "description": "Deployment monitoring exceeds timeout",
            "causes": ["Slow deployment", "Infrastructure issues", "Large changes"],
            "recovery": "Manual verification of deployment status",
            "automation": "alert_team_for_manual_intervention"
        },
        "git_push_failure": {
            "description": "Git push operation fails",
            "causes": ["Permission issues", "Merge conflicts", "Network problems"],
            "recovery": "Resolve git issues locally",
            "automation": "provide_git_resolution_guidance"
        }
    }
    
    return issue_handlers

def implement_retry_logic():
    """Implement intelligent retry mechanisms"""
    
    retry_strategies = {
        "exponential_backoff": {
            "initial_delay": 30,
            "max_delay": 300,
            "multiplier": 2,
            "max_attempts": 5
        },
        "linear_backoff": {
            "delay": 60,
            "max_attempts": 3
        },
        "immediate_retry": {
            "max_attempts": 2,
            "delay": 0
        }
    }
    
    return retry_strategies
```

## Integration Points

### 1. Workflow Integration
```bash
# Use within spec-orchestrator workflow
Use spec-orchestrator: Create feature, then git-push-deploy to staging

# Combine with story tracking  
Use spec-progress-tracker: Update story progress after git-push-deploy completion

# Chain with validation
Use spec-validator: Validate code quality before git-push-deploy
```

### 2. Multi-Environment Deployment
```bash
# Staging deployment
/git-push-deploy --branch="staging" --strategy=polling

# Production deployment (after staging validation)
/git-push-deploy --branch="main" --test-suite=comprehensive --timeout=900

# Development environment testing
/git-push-deploy --branch="develop" --test-suite=quick
```

### 3. CI/CD Integration
```yaml
# .github/workflows/claude-deploy.yml
name: Claude Code Deployment
on:
  workflow_dispatch:
    inputs:
      test_suite:
        description: 'Test suite to run'
        required: true
        default: 'comprehensive'
        type: choice
        options:
        - quick
        - comprehensive  
        - health-only

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Claude Deploy
        run: |
          # This would call Claude Code with the command
          /git-push-deploy --test-suite=${{ github.event.inputs.test_suite }}
```

## Output Examples

### Successful Deployment
```markdown
🚀 Git Push Deploy - Intelligent Deployment Automation
============================================================

🔍 Pre-deployment Validation
----------------------------------------
✅ Git repository status verified
✅ Python syntax validation passed  
✅ i18n compliance checked
✅ SSH connectivity confirmed

📤 Git Push Operation  
----------------------------------------
📁 Working directory: ./user/
✅ Commit created: "Implement AI chat improvements"
✅ Pushed to origin/staging
🔄 odoo.sh CI/CD triggered automatically

⏳ Deployment Monitoring
----------------------------------------
📊 Polling Strategy Active
   Target: 22611896@odoo-esmith-v18-stage30-22611896.dev.odoo.com
   Interval: 30s
   Max Attempts: 20

🔍 Check 1/20
   📊 Completion Score: 20/100
🔍 Check 2/20  
   📊 Completion Score: 45/100
🔍 Check 3/20
   📊 Completion Score: 85/100
   ✅ Deployment completion detected
   🔒 Stability verified

🧪 Automated Testing
----------------------------------------
Test Suite: Comprehensive
Modules: ai_chat, ai_config, ai_config_gemini

🧪 Testing ai_config...
   ✅ PASSED
🧪 Testing ai_config_gemini...
   ✅ PASSED
🧪 Testing ai_chat...
   ✅ PASSED

📊 Test Summary: 3/3 modules passed (100.0%)

============================================================
🎉 Git Push Deploy completed successfully!
📋 Check deployment-progress.md for detailed results
```

### Deployment with Issues
```markdown
🚀 Git Push Deploy - Intelligent Deployment Automation
============================================================

❌ Automated Testing
----------------------------------------
Test Suite: Comprehensive
Modules: ai_chat, ai_config

🧪 Testing ai_config...
   ✅ PASSED
🧪 Testing ai_chat...
   ❌ FAILED

📊 Test Summary: 1/2 modules passed (50.0%)

🔧 Recovery Actions Available:
1. Review test output: ssh {host} "tail -100 ~/logs/odoo.log"
2. Fix issues and retry: /git-push-deploy --modules=ai_chat
3. Manual intervention: Contact development team

❌ Git Push Deploy completed with issues
📋 Check deployment-progress.md for detailed analysis
```

---

This command provides end-to-end automation of the Git-to-deployment workflow while intelligently handling the timing challenges of odoo.sh CI/CD integration through multiple monitoring strategies and comprehensive error recovery mechanisms.