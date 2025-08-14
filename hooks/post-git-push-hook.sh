#!/bin/bash

# Post Git Push Hook for Odoo.sh Deployment Monitoring
# This hook is triggered after git push operations to automatically monitor odoo.sh deployment

# Hook Configuration
HOOK_NAME="post-git-push-odoo-deploy"
HOOK_VERSION="1.0.0"
CLAUDE_CONFIG_DIR=".claude/config"
ODOO_CONFIG_FILE="$CLAUDE_CONFIG_DIR/odoo-sh.json"

# Logging
LOG_FILE="$CLAUDE_CONFIG_DIR/deployment-hooks.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    echo "[$TIMESTAMP] $HOOK_NAME: $1" | tee -a "$LOG_FILE"
}

# Function to check if this is an odoo-related git push
is_odoo_deployment() {
    # Check if we have odoo.sh configuration
    if [ ! -f "$ODOO_CONFIG_FILE" ]; then
        return 1
    fi
    
    # Check if recent commit affects odoo modules
    RECENT_CHANGES=$(git diff --name-only HEAD~1 HEAD)
    if echo "$RECENT_CHANGES" | grep -E "(user/|__manifest__.py|\.py$|\.xml$)" > /dev/null; then
        return 0
    fi
    
    return 1
}

# Function to extract hook context from environment
extract_hook_context() {
    # Claude Code provides context through environment variables
    export HOOK_TRIGGER_TOOL="${CLAUDE_HOOK_TOOL:-git}"
    export HOOK_TRIGGER_COMMAND="${CLAUDE_HOOK_COMMAND:-push}"
    export HOOK_PROJECT_DIR="${PWD}"
    export HOOK_TIMESTAMP="$TIMESTAMP"
    
    log_message "Hook triggered by: $HOOK_TRIGGER_TOOL $HOOK_TRIGGER_COMMAND"
    log_message "Project directory: $HOOK_PROJECT_DIR"
}

# Function to load odoo.sh configuration
load_odoo_config() {
    if [ ! -f "$ODOO_CONFIG_FILE" ]; then
        log_message "ERROR: Odoo.sh configuration not found at $ODOO_CONFIG_FILE"
        return 1
    fi
    
    # Extract configuration using jq (or python if jq not available)
    if command -v jq >/dev/null 2>&1; then
        ACTIVE_ENV=$(jq -r '.environments | to_entries[] | select(.value.active == true) | .key' "$ODOO_CONFIG_FILE")
        SSH_HOST=$(jq -r ".environments.$ACTIVE_ENV.ssh_host" "$ODOO_CONFIG_FILE")
        DEPLOYMENT_TIMEOUT=$(jq -r ".environments.$ACTIVE_ENV.deployment_timeout // 600" "$ODOO_CONFIG_FILE")
    else
        # Fallback to python
        ACTIVE_ENV=$(python3 -c "
import json
with open('$ODOO_CONFIG_FILE') as f:
    config = json.load(f)
for env, settings in config['environments'].items():
    if settings.get('active', False):
        print(env)
        break
")
        SSH_HOST=$(python3 -c "
import json
with open('$ODOO_CONFIG_FILE') as f:
    config = json.load(f)
print(config['environments']['$ACTIVE_ENV']['ssh_host'])
")
        DEPLOYMENT_TIMEOUT=$(python3 -c "
import json
with open('$ODOO_CONFIG_FILE') as f:
    config = json.load(f)
print(config['environments']['$ACTIVE_ENV'].get('deployment_timeout', 600))
")
    fi
    
    export ODOO_ACTIVE_ENV="$ACTIVE_ENV"
    export ODOO_SSH_HOST="$SSH_HOST"
    export ODOO_DEPLOYMENT_TIMEOUT="$DEPLOYMENT_TIMEOUT"
    
    log_message "Loaded configuration - Environment: $ACTIVE_ENV, Host: $SSH_HOST"
    return 0
}

# Function to create deployment monitoring task
create_deployment_monitor() {
    local monitor_script="$CLAUDE_CONFIG_DIR/deployment-monitor-$$.sh"
    
    cat > "$monitor_script" << 'EOF'
#!/bin/bash

# Deployment Monitor Background Process
MONITOR_PID=$$
SSH_HOST="$1"
TIMEOUT="$2"
LOG_FILE="$3"
MODULES="$4"

log_monitor() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] MONITOR[$MONITOR_PID]: $1" >> "$LOG_FILE"
}

log_monitor "Starting odoo.sh deployment monitoring"
log_monitor "Target: $SSH_HOST, Timeout: ${TIMEOUT}s, Modules: $MODULES"

# Wait for initial deployment to start
log_monitor "Waiting for deployment to begin..."
sleep 60

# Monitor deployment status
START_TIME=$(date +%s)
CHECK_INTERVAL=30
MAX_ATTEMPTS=$((TIMEOUT / CHECK_INTERVAL))

for attempt in $(seq 1 $MAX_ATTEMPTS); do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    log_monitor "Check $attempt/$MAX_ATTEMPTS (${ELAPSED}s elapsed)"
    
    # Test SSH connectivity and service responsiveness
    if timeout 15 ssh -o ConnectTimeout=10 "$SSH_HOST" "odoo-bin --version" >/dev/null 2>&1; then
        log_monitor "SSH connectivity restored"
        
        # Test database connectivity
        if timeout 20 ssh "$SSH_HOST" "odoo-bin shell -c \"print('DB Connected')\"" >/dev/null 2>&1; then
            log_monitor "Database connectivity confirmed"
            
            # Check for recent service restart
            RESTART_CHECK=$(ssh "$SSH_HOST" "systemctl show --property=ActiveEnterTimestamp odoo 2>/dev/null || echo 'Unknown'")
            log_monitor "Service status: $RESTART_CHECK"
            
            # Deployment appears complete
            log_monitor "✅ Deployment monitoring complete - Services appear ready"
            
            # Trigger post-deployment testing
            if [ -n "$MODULES" ]; then
                log_monitor "Triggering automated testing for modules: $MODULES"
                
                # Create a trigger file for Claude Code to pick up
                TRIGGER_FILE="$CLAUDE_CONFIG_DIR/deployment-ready-trigger"
                cat > "$TRIGGER_FILE" << EOT
{
  "event": "deployment_ready",
  "timestamp": "$(date -Iseconds)",
  "ssh_host": "$SSH_HOST",
  "modules": "$MODULES",
  "monitoring_duration": ${ELAPSED}
}
EOT
                log_monitor "Created deployment ready trigger: $TRIGGER_FILE"
            fi
            
            exit 0
        fi
    fi
    
    log_monitor "Services not yet ready, waiting ${CHECK_INTERVAL}s..."
    sleep $CHECK_INTERVAL
done

log_monitor "❌ Deployment monitoring timeout after ${TIMEOUT}s"
log_monitor "Manual verification recommended: ssh $SSH_HOST"

# Create timeout trigger for manual intervention
TIMEOUT_TRIGGER="$CLAUDE_CONFIG_DIR/deployment-timeout-trigger"
cat > "$TIMEOUT_TRIGGER" << EOT
{
  "event": "deployment_timeout",
  "timestamp": "$(date -Iseconds)",
  "ssh_host": "$SSH_HOST",
  "modules": "$MODULES",
  "timeout_duration": $TIMEOUT
}
EOT

exit 1
EOF

    chmod +x "$monitor_script"
    echo "$monitor_script"
}

# Function to start background monitoring
start_deployment_monitoring() {
    # Extract modules from recent changes
    CHANGED_MODULES=$(git diff --name-only HEAD~1 HEAD | grep -E "user/[^/]+/" | cut -d'/' -f2 | sort -u | tr '\n' ',' | sed 's/,$//')
    
    if [ -z "$CHANGED_MODULES" ]; then
        CHANGED_MODULES="ai_chat,ai_config,ai_config_gemini"  # Default modules
    fi
    
    log_message "Starting background deployment monitoring"
    log_message "Modules to monitor: $CHANGED_MODULES"
    
    # Create monitoring script
    MONITOR_SCRIPT=$(create_deployment_monitor)
    
    # Start background monitoring
    nohup bash "$MONITOR_SCRIPT" "$ODOO_SSH_HOST" "$ODOO_DEPLOYMENT_TIMEOUT" "$LOG_FILE" "$CHANGED_MODULES" >/dev/null 2>&1 &
    MONITOR_PID=$!
    
    log_message "Background monitor started with PID: $MONITOR_PID"
    log_message "Monitor script: $MONITOR_SCRIPT"
    
    # Save monitor PID for potential cleanup
    echo "$MONITOR_PID" > "$CLAUDE_CONFIG_DIR/deployment-monitor.pid"
    
    return 0
}

# Function to notify user about monitoring status
notify_user() {
    cat << EOF

🎣 HOOK ACTIVATED: Odoo.sh Deployment Monitoring
═══════════════════════════════════════════════

📋 Hook Details:
   • Name: $HOOK_NAME
   • Trigger: Git Push Detection
   • Environment: $ODOO_ACTIVE_ENV
   • Target: $ODOO_SSH_HOST

⏳ Monitoring Status:
   • Background monitoring: ACTIVE
   • Timeout: ${ODOO_DEPLOYMENT_TIMEOUT}s
   • Log file: $LOG_FILE
   
🔄 What happens next:
   1. Hook monitors odoo.sh deployment progress
   2. Automatically detects when services are ready
   3. Triggers automated testing when deployment completes
   4. Sends notification upon completion or timeout

📊 Real-time monitoring:
   tail -f $LOG_FILE

🛑 Stop monitoring:
   kill \$(cat $CLAUDE_CONFIG_DIR/deployment-monitor.pid)

EOF
}

# Main hook execution
main() {
    log_message "=== Hook Execution Started ==="
    
    # Extract context from Claude Code
    extract_hook_context
    
    # Check if this is an odoo-related deployment
    if ! is_odoo_deployment; then
        log_message "Not an Odoo deployment, hook skipping"
        exit 0
    fi
    
    log_message "Odoo deployment detected, activating monitoring"
    
    # Load configuration
    if ! load_odoo_config; then
        log_message "Failed to load Odoo configuration, aborting"
        exit 1
    fi
    
    # Start background monitoring
    if start_deployment_monitoring; then
        log_message "Deployment monitoring activated successfully"
        
        # Notify user
        notify_user
        
        log_message "=== Hook Execution Completed ==="
        exit 0
    else
        log_message "Failed to start deployment monitoring"
        exit 1
    fi
}

# Execute main function
main "$@"