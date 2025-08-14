# Track Progress Command

Real-time progress monitoring and reporting command that leverages the spec-progress-tracker agent to provide comprehensive story, task, and project progress insights with BMad-Method integration.

## Command Syntax

```bash
/track-progress [scope] [options]
```

## Parameters

### Required Parameters
- `scope`: Progress tracking scope (`story`, `epic`, `project`, `task`, or specific ID)

### Optional Parameters
- `--format`: Output format (`dashboard`, `report`, `summary`, `json`)
- `--period`: Time period for progress analysis (`today`, `week`, `sprint`, `month`)
- `--detail`: Detail level (`high`, `medium`, `low`)
- `--output`: Output file path for reports
- `--team`: Filter by team or assignee
- `--status`: Filter by status (`active`, `blocked`, `completed`, `all`)
- `--metrics`: Include velocity and analytics (`true`/`false`)

## Usage Examples

### Story Progress Tracking

```bash
# Track specific story progress
/track-progress Epic-1-Story-2.1

# Track all stories in an epic
/track-progress Epic-1 --format=dashboard

# Track active stories with detailed metrics
/track-progress story --status=active --metrics=true --detail=high
```

### Project-Level Tracking

```bash
# Project overview dashboard
/track-progress project --format=dashboard --period=week

# Generate comprehensive project report
/track-progress project --format=report --output=reports/weekly-progress.md

# Team-specific progress summary
/track-progress project --team="Backend Team" --format=summary
```

### Task-Level Monitoring

```bash
# Track specific task completion
/track-progress TASK-003 --detail=high

# Monitor all blocked tasks
/track-progress task --status=blocked --format=report
```

## Command Workflow

### Phase 1: Scope Analysis
The command analyzes the requested tracking scope:

```markdown
🎯 **Progress Tracking Scope**
- Scope: Epic-1-Story-2.1 (User Authentication System)
- Time Period: Last 7 days
- Detail Level: High
- Format: Dashboard
- Filters: Active tasks only
```

### Phase 2: Data Collection
Invokes spec-progress-tracker for comprehensive data gathering:

```markdown
📊 **Collecting Progress Data**

Using spec-progress-tracker to gather:
- Task completion status across all story phases
- Checkbox hierarchy completion rates
- Blocker identification and duration analysis
- Velocity metrics and trend analysis
- Risk assessment and mitigation status

[spec-progress-tracker data collection follows]
```

### Phase 3: Report Generation
Generates formatted output based on requested format:

```markdown
📈 **Progress Report Generated**

Report Type: Interactive Dashboard
Scope: Story Epic-1-Story-2.1
Generated: 2024-01-15 14:30:00
Output: Console display with export option

[Formatted progress report follows]
```

## Progress Tracking Modes

### Mode 1: Story Dashboard
Real-time interactive story progress view:

```bash
/track-progress Epic-1-Story-2.1 --format=dashboard
```

**Dashboard Output:**
```markdown
# 📊 Story Progress Dashboard
**Story**: Epic-1-Story-2.1 - User Authentication System
**Last Updated**: 2024-01-15 14:30:00
**Report Period**: Real-time

## 🎯 Story Overview
**Overall Progress**: 65% Complete (13 of 20 tasks done)
**Status**: 🔄 In Progress
**Estimated Completion**: 2024-01-18 (3 days remaining)
**Risk Level**: 🟡 Medium (dependency delay risk)

## 📋 Task Completion Breakdown
### Phase 1: Foundation Setup ✅ Complete (100%)
- [x] **TASK-001**: Environment Setup (4h actual vs 4h est) ✅
- [x] **TASK-002**: Database Foundation (7h actual vs 6h est) ✅

### Phase 2: Core Implementation 🔄 In Progress (60%)
- [x] **TASK-003**: Authentication Logic (16h actual vs 16h est) ✅
- [ ] **TASK-004**: API Integration 🔄 60% Complete (10h actual, est 16h)
  - [x] API-4.1: Endpoint configuration ✅
  - [x] API-4.2: Request/response handling ✅ 
  - [ ] API-4.3: Error handling 🔄 In Progress (2h remaining)
  - [ ] API-4.4: Rate limiting ⏸️ Blocked (dependency: Redis setup)
  - [ ] API-4.5: Testing suite ⏸️ Pending

### Phase 3: Integration & Testing ⏸️ Pending (0%)
- [ ] **TASK-005**: Frontend Integration ⏸️ (depends on TASK-004)
- [ ] **TASK-006**: E2E Testing ⏸️ (depends on TASK-005)

## 🎯 Acceptance Criteria Progress
- [x] **AC1**: User registration system ✅ Verified
- [ ] **AC2**: JWT authentication flow 🔄 75% (token refresh pending)
- [ ] **AC3**: Password reset functionality ⏸️ 0%

## ⚠️ Current Blockers
1. **BLOCKER-001**: Redis configuration for rate limiting
   - **Impact**: Blocking TASK-004.4 (API rate limiting)
   - **Duration**: 2 days
   - **Owner**: DevOps Team
   - **ETA**: Tomorrow (2024-01-16)

## 📈 Progress Metrics
**Velocity This Week**: 45 hours completed (avg: 9h/day)
**Estimation Accuracy**: 92% (46h actual vs 50h estimated)
**Daily Progress Rate**: 8.5 checkboxes completed/day
**Quality Score**: 95% (no rework required to date)

## 🔄 Next Actions
1. Complete API error handling implementation (2h remaining)
2. Resolve Redis setup blocker with DevOps
3. Begin rate limiting implementation once Redis ready
4. Start API testing suite in parallel
```

### Mode 2: Epic Progress Summary
High-level progress across multiple stories:

```bash
/track-progress Epic-1 --format=summary --period=week
```

**Summary Output:**
```markdown
# 📊 Epic Progress Summary
**Epic**: Epic-1 - User Management System
**Period**: Week of 2024-01-08 to 2024-01-15
**Stories**: 4 active stories

## 🎯 Epic Overview  
**Overall Progress**: 45% Complete (9 of 20 stories done)
**Active Stories**: 4 in progress, 2 in review
**Completed This Week**: 3 stories (15 story points)
**Velocity**: 15 points/week (target: 18 points/week)

## 📋 Story Status Breakdown
### Completed This Week ✅
- [x] **Epic-1-Story-1.1**: User Registration (8 points) ✅ 
- [x] **Epic-1-Story-1.2**: Basic Profile (5 points) ✅
- [x] **Epic-1-Story-1.3**: Email Verification (3 points) ✅

### In Progress 🔄
- [ ] **Epic-1-Story-2.1**: Authentication System 🔄 65% (8 points)
- [ ] **Epic-1-Story-2.2**: Role Management 🔄 30% (13 points)

### In Review 📋  
- [ ] **Epic-1-Story-3.1**: Password Reset 📋 Ready for Testing (5 points)
- [ ] **Epic-1-Story-3.2**: Account Recovery 📋 Code Review (8 points)

## 🏃 Velocity Analysis
**Team Velocity Trend**: 
- Week 1: 12 points
- Week 2: 15 points ⬆️
- Week 3: 15 points (current)
- **Predicted Next Week**: 16-18 points

## ⚠️ Risks & Blockers
**High Priority**:
- Redis configuration blocking 2 stories
- Third-party email service rate limits

**Medium Priority**:
- Frontend resource allocation for upcoming stories
```

### Mode 3: Project Analytics Report
Comprehensive project-level analytics:

```bash
/track-progress project --format=report --metrics=true --output=reports/project-analytics.md
```

**Analytics Report Features:**
```markdown
# 📊 Project Analytics Report
**Generated**: 2024-01-15 14:30:00
**Project**: Claude Sub-Agent Workflow System
**Reporting Period**: Last 30 days

## 🎯 Executive Summary
**Project Health**: 🟢 Healthy
**Overall Progress**: 42% Complete (38 of 90 stories done)
**Timeline Status**: ⚠️ 3 days behind original schedule
**Budget Status**: 💰 Under budget by 8%
**Quality Score**: 📊 94% (based on rework rate and defect density)

## 📈 Key Performance Indicators

### Delivery Metrics
- **Stories Delivered**: 38 stories (420 story points)
- **Average Story Cycle Time**: 5.2 days
- **Stories per Sprint**: 12.6 average
- **Feature Delivery Rate**: 96% stories delivered as planned

### Quality Metrics
- **Defect Density**: 0.3 defects per story point
- **Rework Rate**: 6% (industry average: 15%)
- **Test Coverage**: 87% (target: 85%)
- **Code Review Coverage**: 98%

### Team Performance
- **Team Velocity**: 126 story points per 2-week sprint
- **Velocity Consistency**: 89% (low variation)
- **Estimation Accuracy**: 91% (actual vs estimated)
- **Blocker Resolution Time**: 1.8 days average

## 📊 Progress Trends & Analytics

### Velocity Trend Analysis
```
Sprint 1: ████████░░ 80 points
Sprint 2: ███████████ 110 points
Sprint 3: ████████████ 120 points
Sprint 4: █████████████ 130 points
Sprint 5: ████████████ 126 points (current)
```

**Trend**: 📈 Increasing velocity with stabilization
**Prediction**: Next sprint estimate 125-135 points

### Story Completion Pattern
**By Epic**:
- Epic-1 (User Management): 85% complete
- Epic-2 (Data Processing): 65% complete  
- Epic-3 (Integration): 15% complete
- Epic-4 (Analytics): 0% complete (planned for later)

**By Complexity**:
- Low Complexity (1-3 points): 95% complete
- Medium Complexity (5-8 points): 78% complete
- High Complexity (13-21 points): 32% complete

## ⚠️ Risk Analysis & Mitigation

### Critical Risks
1. **Integration Complexity Risk** 🔴
   - **Probability**: High (70%)
   - **Impact**: 2-week delay potential
   - **Mitigation**: Early integration spike planned
   - **Status**: Active monitoring

2. **Third-party Dependency Risk** 🟡
   - **Probability**: Medium (40%)  
   - **Impact**: 1-week delay potential
   - **Mitigation**: Alternative vendors identified
   - **Status**: Contingency planning complete

### Recently Resolved
1. **Database Performance** ✅ Resolved
   - **Resolution Time**: 3 days
   - **Impact**: None (resolved before affecting delivery)
```

## Advanced Progress Features

### Multi-Team Coordination

```bash
# Track progress across teams
/track-progress project --team="Backend,Frontend,DevOps" --format=dashboard
```

**Coordinated Progress View:**
```markdown
## 🎯 Multi-Team Progress Coordination

### Team Workload Distribution
**Backend Team**: 45% of total work (3 active stories)
- Epic-1-Story-2.1: Authentication (65% complete)
- Epic-2-Story-1.1: Data Models (30% complete)  
- Epic-2-Story-1.2: API Design (not started)

**Frontend Team**: 35% of total work (2 active stories)
- Epic-1-Story-3.1: Auth UI (waiting for backend)
- Epic-3-Story-1.1: Dashboard (design phase)

**DevOps Team**: 20% of total work (1 active story)
- Epic-0-Story-1.1: Infrastructure (85% complete)

### Cross-Team Dependencies
- ⚠️ **Frontend waiting on Backend**: Auth API completion
- ⚠️ **Backend waiting on DevOps**: Redis configuration
- ✅ **DevOps → Frontend**: CI/CD pipeline ready
```

### Automated Progress Alerts

```bash
# Set up automated progress monitoring
/track-progress project --format=summary --period=daily --output=slack-webhook
```

**Alert Conditions:**
```markdown
## 🚨 Automated Progress Alerts

### Daily Alert Triggers
- **Velocity Drop**: <70% of expected daily progress
- **Blocker Duration**: Any blocker >2 days old
- **Risk Escalation**: Risk probability increases >20%
- **Deadline Risk**: Story at risk of missing commitment

### Weekly Alert Triggers  
- **Sprint Goal Risk**: <80% confidence in sprint completion
- **Quality Degradation**: Test coverage drops <80%
- **Team Utilization**: Team capacity utilization <60% or >120%

### Alert Channels
- Slack notifications for daily alerts
- Email reports for weekly summaries
- Dashboard updates for real-time monitoring
```

## Integration with Development Workflow

### Git Integration Progress
Automatic progress updates from development activity:

```markdown
## 🔄 Automated Progress Detection

### Git Integration
- **Commit Analysis**: Parse commit messages for task completion
- **Branch Tracking**: Monitor feature branch progress
- **PR Status**: Track pull request reviews and merges
- **Deploy Tracking**: Monitor deployment success/failure

### Issue Tracking Integration
- **Status Synchronization**: Sync with Jira/GitHub/Linear
- **Comment Processing**: Extract progress updates from comments
- **Time Tracking**: Aggregate time spent from issue trackers

### CI/CD Pipeline Integration
- **Build Success**: Track build pipeline health
- **Test Results**: Monitor automated test completion rates
- **Deployment Status**: Track deployment frequency and success
```

### Progress Update Workflow

```markdown
## 🔄 Progress Update Process

### Real-Time Updates (Every 4 hours)
1. **Git Activity Scan**: Check for new commits, PRs, branches
2. **Task Status Sync**: Update checkbox completion from external tools
3. **Blocker Detection**: Identify stalled tasks and potential blockers
4. **Risk Assessment**: Evaluate progress against timeline commitments

### Daily Progress Reports (End of day)
1. **Velocity Calculation**: Update team and individual velocity metrics
2. **Completion Analysis**: Analyze task and story completion patterns
3. **Blocker Review**: Update blocker status and escalation needs
4. **Tomorrow Planning**: Identify priority tasks and dependencies

### Weekly Progress Reviews (End of sprint)
1. **Sprint Analysis**: Complete sprint retrospective and metrics
2. **Velocity Trending**: Update velocity trends and predictions
3. **Process Improvement**: Identify workflow optimization opportunities
4. **Quality Review**: Analyze quality metrics and improvement areas
```

## Export and Reporting Options

### Report Formats

#### Dashboard Format (Interactive)
```bash
/track-progress story --format=dashboard
# Live updating console dashboard with real-time metrics
```

#### Summary Format (Executive)
```bash
/track-progress epic --format=summary --output=reports/executive-summary.md
# High-level stakeholder-friendly progress summary
```

#### Detailed Report Format (Technical)
```bash
/track-progress project --format=report --detail=high --output=reports/technical-progress.md
# Comprehensive technical progress report with full metrics
```

#### JSON Format (API Integration)
```bash
/track-progress project --format=json --output=data/progress-data.json
# Machine-readable progress data for external tools integration
```

### Custom Report Templates

```bash
# Use custom report template
/track-progress project --format=report --template=templates/stakeholder-report.md

# Generate multiple formats simultaneously
/track-progress sprint --format=dashboard,summary,json --output=reports/
```

## Error Handling & Recovery

### Common Scenarios
```markdown
❌ **Error: Story Not Found**
Story "Epic-99-Story-1.1" not found.
Available stories in Epic-99:
- Epic-99-Story-2.1: Data Migration
- Epic-99-Story-2.2: API Cleanup

⚠️ **Warning: Incomplete Progress Data**
Some tasks missing progress updates (last updated >48h ago):
- TASK-007: Missing progress since 2024-01-13
- TASK-012: No checkbox updates in 3 days

❌ **Error: Export Failed**
Could not write to: /protected/reports/
Available export locations:
- ./reports/ (current directory)
- ~/Documents/progress-reports/
- /tmp/progress-reports/
```

### Recovery Options
- **Automatic Retries**: Retry data collection with backoff
- **Partial Progress Reports**: Generate reports with available data
- **Alternative Sources**: Use cached data when real-time data unavailable
- **Progress Estimation**: Estimate progress when exact data missing

---

This command provides comprehensive, real-time progress tracking that integrates seamlessly with the BMad-Method story-driven workflow, enabling teams to maintain visibility, identify risks early, and make data-driven decisions throughout the development process.