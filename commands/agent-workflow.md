---
description: "Automated multi-agent development workflow with quality gates from idea to production code"
allowed-tools: ["Task", "Read", "Write", "Edit", "MultiEdit", "Grep", "Glob", "TodoWrite"]
---

# Agent Workflow - Automated Development Pipeline

Execute complete development workflow using intelligent sub-agent chaining with quality gates.

## Context

- Feature to develop: $ARGUMENTS
- Automated multi-agent workflow with quality gates
- Sub-agents work in independent contexts with smart chaining

## Your Role

You are the Workflow Orchestrator managing an automated development pipeline using Claude Code Sub-Agents. You coordinate a quality-gated workflow that ensures 95%+ code quality through intelligent looping.

## Sub-Agent Chain Process

Execute the following enhanced chain using Claude Code's sub-agent syntax with intelligent parallel execution and BMad-Method story integration:

```
First use the spec-analyst sub agent to generate complete requirements and user stories for [$ARGUMENTS], then EXECUTE IN PARALLEL: [spec-story-manager sub agent to create comprehensive user stories with acceptance criteria + spec-architect sub agent to design system architecture based on requirements], then use the spec-planner sub agent to create detailed task breakdown with checkbox tracking from both story and architecture outputs, then EXECUTE IN PARALLEL: [spec-developer sub agent to implement code based on specifications + spec-progress-tracker sub agent to monitor implementation progress in real-time], then EXECUTE IN PARALLEL: [spec-tester sub agent to generate comprehensive test suite + spec-reviewer sub agent to perform code review], then use the spec-validator sub agent to evaluate overall quality with scoring, then if score ≥95% complete the workflow, otherwise loop back to appropriate phase based on progress tracker analysis and repeat with intelligent feedback.
```

## Workflow Logic

### Quality Gate Mechanism

- **Validation Score ≥95%**: Proceed to spec-tester sub agent
- **Validation Score <95%**: Loop back to spec-analyst sub agent with feedback
- **Maximum 3 iterations**: Prevent infinite loops

### Workflow Visualization (Intelligent Parallel Execution with Quality Gates)

```mermaid
graph TD
    A[🚀 Project Idea] --> B[🎭 spec-orchestrator]
    B --> C[📋 Planning Phase - Intelligent Parallel]
    C --> D[🎯 spec-analyst<br/>Requirements & User Stories]
    D --> D1{📄 Doc > 500 lines?}
    D1 -->|Yes| D2[📂 doc-sharding-agent<br/>Shard Requirements]
    D1 -->|No| E_SPLIT
    D2 --> E_SPLIT[🔀 Parallel Split Point 1]
    
    E_SPLIT -->|Branch A| E[📖 spec-story-manager<br/>Story Creation & Lifecycle]
    E_SPLIT -->|Branch B| E1[🏗️ spec-architect<br/>System Design]
    
    E --> F[📝 spec-planner<br/>Task Breakdown & Checkboxes]
    E1 --> E2{📄 Doc > 500 lines?}
    E2 -->|Yes| E3[📂 doc-sharding-agent<br/>Shard Architecture]
    E2 -->|No| F
    E3 --> F
    
    F --> G{🥇 Quality Gate 1<br/>Planning Quality ≥95%}
    G -->|✅ Pass| H[💻 Development Phase - Parallel Execution]
    G -->|❌ Fail| D
    
    H --> I_SPLIT[🔀 Parallel Split Point 2]
    I_SPLIT -->|Main Thread| I[💻 spec-developer<br/>Implementation]
    I_SPLIT -->|Monitor Thread| I1[📊 spec-progress-tracker<br/>Real-time Monitoring]
    
    I --> J_SPLIT[🔀 Parallel Split Point 3]
    I1 --> K_MERGE[🔗 Merge Point]
    J_SPLIT -->|Test Thread| J[🧪 spec-tester<br/>Testing]
    J_SPLIT -->|Review Thread| M[📋 spec-reviewer<br/>Code Review]
    
    J --> K_MERGE
    M --> K_MERGE
    K_MERGE --> K{🥈 Quality Gate 2<br/>Development Quality ≥80%}
    K -->|✅ Pass| L[✅ Validation Phase]
    K -->|❌ Fail| I
    
    L --> N[✅ spec-validator<br/>Final Quality Assessment]
    
    N --> O{🥉 Quality Gate 3<br/>Production Ready ≥85%}
    O -->|✅ Pass| O1[📊 spec-progress-tracker<br/>Final Report]
    O1 --> O2[📂 doc-sharding-agent<br/>Final Doc Organization]
    O2 --> P[🎉 Production Ready<br/>with Story Completion]
    O -->|❌ Fail| Q[🔄 Intelligent Feedback Loop]
    
    Q --> R{📊 Determine Fix Level<br/>with Progress Analysis}
    R -->|Story Issues| E
    R -->|Planning Issues| D
    R -->|Development Issues| I
    R -->|Testing Issues| J
    R -->|Review Issues| M
    
    %% Styling
    classDef orchestrator fill:#1a73e8,color:#fff,stroke:#0d47a1,stroke-width:3px
    classDef phase fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px,color:#000
    classDef parallel fill:#00bcd4,color:#fff,stroke:#006064,stroke-width:3px
    classDef story fill:#4caf50,color:#fff,stroke:#2e7d32,stroke-width:2px
    classDef progress fill:#ff9800,color:#fff,stroke:#ef6c00,stroke-width:2px
    classDef process fill:#f3e5f5,stroke:#4a148c,stroke-width:2px,color:#000
    classDef sharding fill:#9c27b0,color:#fff,stroke:#6a1b9a,stroke-width:2px
    classDef gate fill:#f9ab00,color:#fff,stroke:#e65100,stroke-width:3px
    classDef success fill:#34a853,color:#fff,stroke:#1b5e20,stroke-width:3px
    classDef feedback fill:#ff9800,color:#fff,stroke:#ef6c00,stroke-width:2px
    classDef decision fill:#03a9f4,color:#fff,stroke:#0277bd,stroke-width:2px
    
    class B orchestrator
    class C,H,L phase
    class E_SPLIT,I_SPLIT,J_SPLIT,K_MERGE parallel
    class E story
    class I1,O1 progress
    class D,E1,F,I,J,M,N process
    class D2,E3,O2 sharding
    class D1,E2 decision
    class G,K,O gate
    class P success
    class Q,R feedback
```

### Detailed Process Flow (Intelligent Parallel Execution with Progress Tracking)

```mermaid
sequenceDiagram
    participant User as 👤 User
    participant Orchestrator as 🎭 spec-orchestrator
    participant Analyst as 🎯 spec-analyst
    participant StoryMgr as 📖 spec-story-manager
    participant Sharding as 📂 doc-sharding-agent
    participant Architect as 🏗️ spec-architect
    participant Planner as 📝 spec-planner
    participant Developer as 💻 spec-developer
    participant ProgressTracker as 📊 spec-progress-tracker
    participant Tester as 🧪 spec-tester
    participant Reviewer as 📋 spec-reviewer
    participant Validator as ✅ spec-validator

    User->>Orchestrator: Request project development with parallel execution
    
    Note over Orchestrator: Planning Phase - Intelligent Parallel Approach
    rect rgb(232, 234, 246)
        Orchestrator->>Analyst: Generate requirements and initial user stories
        Analyst-->>Orchestrator: requirements.md, user-stories.md
        
        alt requirements.md > 500 lines
            Orchestrator->>Sharding: Shard requirements document
            Sharding-->>Orchestrator: requirements/ directory with sections
            Note over Sharding: ✂️ Document fragmented for better AI processing
        end
        
        Note over Orchestrator: 🔀 PARALLEL EXECUTION PHASE 1
        par Story Management
            Orchestrator->>StoryMgr: Create comprehensive user stories with lifecycle management
            StoryMgr-->>Orchestrator: Structured stories with acceptance criteria
            Note over StoryMgr: 📖 Story creation using BMad-Method principles
        and System Architecture
            Orchestrator->>Architect: Design system architecture (parallel with stories)
            Architect-->>Orchestrator: architecture.md, api-spec.md
            alt architecture.md > 500 lines
                Orchestrator->>Sharding: Shard architecture document
                Sharding-->>Orchestrator: architecture/ directory with components
                Note over Sharding: ✂️ Architecture fragmented by components
            end
        end
        
        Orchestrator->>Planner: Create task breakdown combining story + architecture outputs
        Planner-->>Orchestrator: tasks.md with 3-level checkbox hierarchy
        Note over Planner: 📝 Task → Subtask → Action Items with progress tracking
        
        Note over Orchestrator: Quality Gate 1: Planning ≥95%
        alt Planning Quality ≥ 95%
            Note over Orchestrator: ✅ Proceed to Development
        else Planning Quality less than 95%
            Note over Orchestrator: ❌ Loop back with intelligent routing
            alt Story Quality Issues
                Orchestrator->>StoryMgr: Refine stories based on feedback
            else Architecture Quality Issues
                Orchestrator->>Architect: Improve architecture design
            end
        end
    end
    
    Note over Orchestrator: Development Phase - Parallel Task Execution with Real-time Monitoring
    rect rgb(243, 229, 245)
        Note over Orchestrator: 🔀 PARALLEL EXECUTION PHASE 2
        par Implementation
            Orchestrator->>Developer: Implement code based on story specifications
            Developer-->>Orchestrator: Implementation with task completion updates
        and Real-time Monitoring
            Orchestrator->>ProgressTracker: Monitor implementation progress in real-time
            loop Continuous Monitoring
                ProgressTracker-->>Orchestrator: Progress dashboards, velocity metrics, risk alerts
                Note over ProgressTracker: 📊 Real-time checkbox completion tracking
            end
        end
        
        Note over Orchestrator: 🔀 PARALLEL EXECUTION PHASE 3
        par Test Generation
            Orchestrator->>Tester: Generate comprehensive test suite
            Tester-->>Orchestrator: Tests with story acceptance criteria validation
        and Code Review
            Orchestrator->>Reviewer: Perform code review with story alignment validation
            Reviewer-->>Orchestrator: Review report with story acceptance criteria check
        end
        
        Note over Orchestrator: Quality Gate 2: Development ≥80%
        alt Development Quality ≥ 80%
            Note over Orchestrator: ✅ Proceed to Validation
        else Development Quality less than 80%
            Note over Orchestrator: ❌ Intelligent feedback routing
            Orchestrator->>ProgressTracker: Analyze failure points and recommend fixes
            alt Code Quality Issues
                Orchestrator->>Developer: Apply feedback and continue implementation
            else Testing Issues
                Orchestrator->>Tester: Improve test coverage
            else Review Issues
                Orchestrator->>Reviewer: Address review concerns
            end
        end
    end
    
    Note over Orchestrator: Validation Phase - Final Quality Assessment
    rect rgb(248, 249, 250)
        Orchestrator->>Validator: Final production readiness and story completion check
        Validator-->>Orchestrator: Quality score (0-100%) with comprehensive validation
        
        Note over Orchestrator: Quality Gate 3: Production Ready ≥85%
        alt Production Quality ≥ 85%
            Note over Orchestrator: ✅ Production Ready
            Orchestrator->>ProgressTracker: Generate final progress report and metrics
            ProgressTracker-->>Orchestrator: Comprehensive completion report, velocity analysis
            Note over ProgressTracker: 📊 Final story completion validation and analytics
            
            Orchestrator->>Sharding: Final document organization with story integration
            Sharding-->>Orchestrator: All docs organized with story references
            Note over Sharding: 📂 Complete documentation with story traceability
        else Production Quality less than 85%
            Note over Orchestrator: ❌ Intelligent Fix Routing with Progress Analysis
            Orchestrator->>ProgressTracker: Analyze failure points across all phases
            alt Story Issues Identified
                Orchestrator->>StoryMgr: Fix story definition issues
            else Architecture Issues Identified
                Orchestrator->>Architect: Improve architecture design
            else Planning Issues Identified
                Orchestrator->>Planner: Fix task breakdown issues
            else Development Issues Identified
                Orchestrator->>Developer: Fix implementation issues
            else Testing Issues Identified
                Orchestrator->>Tester: Improve test coverage
            else Review Issues Identified
                Orchestrator->>Reviewer: Address review concerns
            end
        end
    end
    
    Orchestrator-->>User: 🎉 Production-ready code with parallel execution efficiency and complete analytics
```

### Chain Execution Steps (Intelligent Parallel Execution with BMad-Method Integration)

1. **spec-analyst sub agent**: Generate comprehensive requirements and initial user stories
   - Business requirements with user story outlines
   - System integration requirements
   - Framework-specific considerations (Odoo, React, etc.)
   - Multi-user and internationalization needs

2. **Document Sharding Check (Post-Analysis)**:
   - **Auto-check**: If requirements.md > 500 lines, invoke doc-sharding-agent
   - **Output**: Sharded requirements/ directory with focused sections
   - **Benefits**: Manageable fragments for subsequent parallel agents

3. **🔀 PARALLEL EXECUTION PHASE 1**: Story Management + Architecture Design
   
   **3A. spec-story-manager sub agent** (Parallel Branch A):
   - Transform requirement outlines into structured user stories
   - Define clear acceptance criteria with measurable outcomes
   - Establish story dependencies and prerequisite relationships
   - Create proper story hierarchy (Epic → Story → Task → Subtask)
   - Apply BMad-Method story principles for quality and traceability
   
   **3B. spec-architect sub agent** (Parallel Branch B):
   - System architecture aligned with story requirements
   - Technical specifications supporting story acceptance criteria  
   - Integration design based on story dependencies
   - Security and performance architecture
   - API design with story-driven endpoints

4. **Document Sharding Check (Post-Architecture)**:
   - **Auto-check**: If architecture.md > 500 lines, invoke doc-sharding-agent  
   - **Output**: Sharded architecture/ directory with component sections
   - **Benefits**: Focused architectural components for implementation

5. **spec-planner sub agent**: Create detailed task breakdown with checkbox tracking and test planning
   - **Input**: Combined outputs from spec-story-manager + spec-architect
   - Break stories into implementable tasks (2-8 hours each)
   - Create 3-level checkbox hierarchy (Task → Subtask → Action Items)
   - Map tasks directly to acceptance criteria for traceability
   - **Mandatory Test Mapping**: Each task must have corresponding test specification
   - Define dependencies and parallel execution opportunities
   - Establish Definition of Done criteria for each task level (including test completion)
   - Create task-to-test traceability matrix for comprehensive coverage

6. **Quality Gate 1 Decision** (Enhanced with parallel feedback):
   - If ≥95%: Continue to development phase
   - If <95%: Intelligent routing to specific issues:
     - Story quality issues → Return to spec-story-manager
     - Architecture quality issues → Return to spec-architect
     - Integration issues → Return to both with coordination

7. **🔀 PARALLEL EXECUTION PHASE 2**: Implementation + Real-time Monitoring
   
   **7A. spec-developer sub agent** (Main Implementation Thread):
   - Code implementation following story acceptance criteria
   - **Task-by-Task Implementation**: Each checkbox task must be individually implemented and validated
   - Task completion tracking with checkbox updates (only after task tests pass)
   - Proper integration with existing system components
   - Security implementation as defined in stories
   - Documentation and code comments with task-level annotations
   - **Test-First Development**: Ensure testability of each task during implementation
   
   **7B. spec-progress-tracker sub agent** (Continuous Monitoring Thread):
   - Real-time task and checkbox completion tracking (including test status)
   - **Test Coverage Monitoring**: Track test completion for each task
   - Velocity measurement and trend analysis with test metrics
   - Blocker identification and escalation management
   - Progress reporting with story completion status and test coverage
   - Risk assessment and mitigation recommendations including untested tasks
   - **Task-Test Alignment Validation**: Ensure no task is marked complete without corresponding test

8. **🔀 PARALLEL EXECUTION PHASE 3**: Testing + Code Review
   
   **8A. spec-tester sub agent** (Testing Thread):
   - **Task-Level Testing (MANDATORY)**: Every task from every story must have dedicated test coverage
   - **Unit Tests**: Individual task functionality validation
   - **Integration Tests**: Task interaction and story acceptance criteria validation
   - **End-to-end Tests**: Complete user workflows covering all story scenarios
   - **Performance Tests**: Meeting story requirements for each task
   - **Story-Task Traceability Tests**: Ensure each checkbox task has corresponding test validation
   - **Regression Tests**: Prevent task-level functionality breaks
   
   **8B. spec-reviewer sub agent** (Review Thread):
   - Code quality review against project standards
   - Story acceptance criteria fulfillment verification
   - Security review based on story requirements
   - Performance review against story criteria
   - Integration review for story dependencies

9. **Quality Gate 2 Decision** (Enhanced with parallel insights and task-level test validation):
   - If ≥80% AND **100% task-level test coverage**: Continue to validation phase
   - If <80% OR **incomplete task-level test coverage**: Intelligent routing based on progress tracker analysis:
     - Code quality issues → Return to spec-developer
     - **Task-level test coverage gaps** → Return to spec-tester with specific task mapping
     - Review concerns → Return to spec-reviewer
     - **Task-test traceability issues** → Return to spec-planner for test mapping revision
     - Systematic issues → Return to appropriate earlier phase

10. **spec-validator sub agent**: Final production readiness and comprehensive validation
    - **Input**: Combined outputs from all parallel execution phases
    - Comprehensive quality assessment with story validation
    - Production readiness checklist execution
    - Story completion verification against Definition of Done
    - Final acceptance criteria validation
    - Release readiness assessment
    - **Cross-validation**: Ensure all parallel threads are properly integrated

11. **Quality Gate 3 Decision** (Intelligent Fix Routing):
    - If ≥85%: Production ready with story completion
    - If <85%: Intelligent routing based on progress tracker comprehensive analysis:
      - Story definition issues → Return to spec-story-manager
      - Architecture design issues → Return to spec-architect
      - Planning issues → Return to spec-planner
      - Implementation issues → Return to spec-developer
      - Testing issues → Return to spec-tester
      - Review issues → Return to spec-reviewer

12. **Final Progress Report and Document Organization**:
    - **spec-progress-tracker**: Generate comprehensive completion report with parallel execution metrics
    - **doc-sharding-agent**: Final document organization with story traceability
    - **Consolidate**: Create story completion index and analytics with parallel execution insights
    - **Validate**: Ensure complete documentation with cross-thread references and story integration

## Expected Iterations

- **Round 1**: Initial implementation (typically 80-90% quality)
- **Round 2**: Refined implementation addressing feedback (typically 90-95%)
- **Round 3**: Final optimization if needed (95%+ target)

## Output Format

1. **Workflow Initiation** - Start sub-agent chain with feature description
2. **Progress Tracking** - Monitor each sub-agent completion
3. **Quality Gate Decisions** - Report review scores and next actions
4. **Completion Summary** - Final artifacts and quality metrics

## Key Benefits

### Core Workflow Benefits
- **Automated Quality Control**: 95% threshold ensures high standards
- **Intelligent Feedback Loops**: Review feedback guides spec improvements with parallel insights
- **Independent Contexts**: Each sub-agent works in clean environment with coordinated outputs
- **One-Command Execution**: Single command triggers entire parallel workflow

### Intelligent Parallel Execution Benefits ⚡
- **Dramatically Reduced Time-to-Market**: 40-60% faster development through strategic parallelization
- **Resource Optimization**: Multiple agents work simultaneously without dependency conflicts
- **Real-time Coordination**: Progress tracker monitors all parallel threads continuously
- **Intelligent Routing**: Quality gates provide specific feedback to appropriate parallel branches
- **Cross-Thread Integration**: Validator ensures all parallel outputs are properly integrated
- **Adaptive Load Balancing**: Workflow adapts based on agent completion times and quality scores

### BMad-Method Story Integration Benefits  
- **Story-Driven Development**: Clear user value delivery with measurable acceptance criteria
- **Progress Transparency**: Real-time task completion tracking with 3-level checkbox hierarchy across all parallel threads
- **Velocity Analytics**: Data-driven development insights with parallel execution metrics and predictive completion timelines
- **Blocker Management**: Proactive identification and resolution of development impediments across all execution phases
- **Definition of Done**: Clear completion criteria at story, task, and subtask levels with cross-validation
- **Traceability**: Complete linkage from user stories to implementation and testing across parallel execution paths
- **Task-Level Test Coverage**: **MANDATORY 100% task coverage** - Every checkbox task requires dedicated test validation
- **Test-First Quality**: No task completion without corresponding test success

### Advanced Parallel Capabilities 🚀
- **Document Sharding**: Automatic fragmentation of large documents optimized for parallel AI processing
- **Story Lifecycle Management**: Complete story state management (Draft → Ready → In Progress → Review → Done) with parallel progress tracking
- **Multi-Thread Progress Monitoring**: Real-time dashboards with team velocity and completion metrics across all parallel agents
- **Cross-Phase Risk Assessment**: Continuous risk evaluation with mitigation recommendations from multiple parallel perspectives
- **Parallel Quality Validation**: Story acceptance criteria validation throughout development process across all execution threads
- **Intelligent Merge Points**: Sophisticated coordination of parallel outputs with conflict resolution
- **Performance Metrics**: Detailed analytics on parallel execution efficiency and bottleneck identification

---

## Execute Workflow

**Feature Description**: $ARGUMENTS

Starting automated development workflow with quality gates...

### 🎯 Phase 1: Requirements Analysis and Story Creation

First use the **spec-analyst** sub agent to analyze project requirements:

- Business requirements and functional specifications
- Framework integration requirements (Odoo, React, etc.)
- Initial user story outlines with basic acceptance criteria
- Technical constraints and integration considerations
- Multi-user, multi-language, and localization needs
- Integration requirements with existing systems

Then use the **spec-story-manager** sub agent to create comprehensive user stories:

- Transform requirement outlines into structured user stories
- Define clear, measurable acceptance criteria
- Establish story dependencies and prerequisites
- Apply BMad-Method story principles for quality assurance
- Create story lifecycle management framework

### 🏗️ Phase 2: System Architecture Design

Then use the **spec-architect** sub agent to design system architecture with story context:

- System architecture aligned with story requirements
- Technical specifications supporting story acceptance criteria
- Database schema design and data model architecture
- API design with story-driven endpoints
- Security architecture based on story requirements
- Integration design based on story dependencies
- Performance and scalability considerations
- Framework-specific architecture (Odoo models/views, React components, etc.)

### 📝 Phase 3: Task Planning with Checkbox Tracking

Then use the **spec-planner** sub agent to create detailed task breakdown:

- Break stories into implementable tasks (2-8 hours each)
- Create 3-level checkbox hierarchy (Task → Subtask → Action Items)
- Map tasks directly to acceptance criteria for traceability
- Define dependencies and parallel execution opportunities
- Establish Definition of Done criteria for each task level
- Plan testing strategy and validation approach

### 💻 Phase 4: Implementation with Progress Monitoring

Then use the **spec-developer** sub agent to implement code based on story specifications:

- Code implementation following story acceptance criteria
- Task completion tracking with checkbox updates
- Framework-specific implementation (Python models, React components, etc.)
- Security implementation as defined in stories
- Integration with existing system components
- Documentation and code comments

Use **spec-progress-tracker** sub agent to monitor implementation progress:

- Real-time task and checkbox completion tracking
- Velocity measurement and trend analysis
- Blocker identification and escalation management
- Progress reporting with story completion status
- Risk assessment and mitigation recommendations

### ✅ Phase 5: Quality Validation with Story Completion

Then use the **spec-validator** sub agent to evaluate:

- Code quality and standards compliance
- Story acceptance criteria fulfillment verification
- Security implementation based on story requirements
- Performance requirements validation
- Integration completeness and correctness
- Story completion verification against Definition of Done
- **Provide comprehensive quality score (0-100%)**

### 🔄 Quality Gate Decision (Story-Focused)

**If validation score ≥95%**: Proceed to comprehensive testing phase
**If validation score <95%**: Loop back to appropriate phase based on progress tracker analysis

### 🧪 Phase 6: Comprehensive Task-Level Test Suite Generation with Story Validation

Finally use the **spec-tester** sub agent to create comprehensive test coverage with **MANDATORY task-level testing**:

#### **Task-Level Test Requirements (MANDATORY)**
- **Every Task Must Have Tests**: Each checkbox task from every story requires dedicated test coverage
- **Task-to-Test Traceability**: 1:1 mapping between tasks and corresponding tests
- **Test Completion Gates**: No task can be marked as "done" without passing tests

#### **Comprehensive Test Suite**
- **Unit Tests**: Individual task functionality validation with specific test cases for each checkbox task
- **Integration Tests**: Task interaction validation and story acceptance criteria testing
- **End-to-End Tests**: Complete user workflows covering all story scenarios with task-level verification
- **Performance Tests**: Meeting story requirements for each individual task
- **Security Tests**: Access controls and data protection validation for each task
- **Story Acceptance Criteria Validation Tests**: Each story's acceptance criteria mapped to task-level tests
- **User Journey Testing**: Based on story scenarios with granular task validation
- **Regression Tests**: Prevent task-level functionality breaks during development

#### **Test Documentation Requirements**
- **Test-Task Mapping Document**: Clear documentation linking each test to specific tasks
- **Coverage Report**: Showing 100% task coverage requirement
- **Test Execution Results**: Detailed results for each task-level test

## Expected Output Structure (Odoo 18 Enterprise)

```
odoo18ee_project/
├── docs/
│   ├── {module_name}/
│   │   ├── v{version}/
│   │   │   ├── requirements.md
│   │   │   ├── architecture.md
│   │   │   ├── api-spec.md
│   │   │   ├── user-stories.md
│   │   │   ├── migration-guide.md
│   │   │   └── changelog.md
│   │   └── current/  # symlink to latest version
│   ├── integration/
│   │   ├── enterprise-integration.md
│   │   ├── community-compatibility.md
│   │   └── external-apis.md
│   └── global/
│       ├── development-standards.md
│       ├── deployment-guide.md
│       └── testing-strategy.md
├── odoo/                    # Odoo community edition core
├── enterprise/              # Odoo enterprise edition modules
├── user/                    # Custom modules directory
│   ├── {module_name}/
│   │   ├── __init__.py
│   │   ├── __manifest__.py
│   │   ├── models/
│   │   ├── views/
│   │   ├── controllers/
│   │   ├── static/src/
│   │   ├── security/
│   │   ├── data/
│   │   ├── tests/
│   │   └── i18n/
│   └── requirements.txt     # Custom module dependencies
└── themes/                  # Custom themes
```

**Begin execution now with the provided feature description, utilizing intelligent parallel execution and reporting progress after each phase completion with cross-thread coordination metrics.**

## Parallel Execution Configuration

### Agent Dependency Matrix

| Agent | Sequential Dependencies | Parallel Opportunities | Merge Requirements |
|-------|-------------------------|------------------------|-------------------|
| spec-analyst | None | Independent | Provides input to all |
| spec-story-manager | spec-analyst | ✅ With spec-architect | Merged at spec-planner |
| spec-architect | spec-analyst | ✅ With spec-story-manager | Merged at spec-planner |
| spec-planner | story-manager + architect | None | Sequential after merge |
| spec-developer | spec-planner | ✅ With spec-progress-tracker | Continuous coordination |
| spec-progress-tracker | spec-developer | ✅ With spec-developer | Continuous monitoring |
| spec-tester | spec-developer | ✅ With spec-reviewer | Merged at quality gate |
| spec-reviewer | spec-developer | ✅ With spec-tester | Merged at quality gate |
| spec-validator | All previous | None | Final integration point |

### Parallel Execution Guidelines

1. **Phase 1 Parallelization**: After spec-analyst completion
   ```
   spec-story-manager || spec-architect → spec-planner
   ```

2. **Phase 2 Parallelization**: Development with continuous monitoring  
   ```
   spec-developer || spec-progress-tracker (continuous)
   ```

3. **Phase 3 Parallelization**: Testing and review
   ```
   spec-tester || spec-reviewer → spec-validator
   ```

4. **Quality Gate Enhancement**: Each gate now evaluates parallel thread outputs with cross-validation

5. **Intelligent Routing**: Feedback loops target specific parallel branches based on issue analysis

## Unified Document Storage Configuration

### Odoo Project Document Storage Standards

All agent-generated documents follow the Odoo-specific storage standards below:

#### Basic Configuration

```yaml
project-info:
  name: "odoo18ee-project"
  display-name: "Odoo 18 Enterprise Edition Project"
  version: "v{module_version}"
  doc-root: "./docs/"
  module-root: "./user/"
  odoo-community: "./odoo/"
  odoo-enterprise: "./enterprise/"
```

#### Path Generation Rules for Odoo Modules

Claude Code applies the following path generation logic for Odoo projects:

```
./docs/{module_name}/v{version}/
├── requirements_{timestamp}.md
├── architecture_{timestamp}.md
├── api-spec_{timestamp}.md
├── user-stories_{timestamp}.md
├── migration-guide_{timestamp}.md
└── changelog_{timestamp}.md

./user/{module_name}/
├── __init__.py
├── __manifest__.py
├── models/
│   └── {model_name}.py
├── views/
│   └── {model_name}_views.xml
├── controllers/
│   └── {controller_name}.py
├── static/src/
│   ├── {component_name}/
│   │   ├── {component_name}.js
│   │   ├── {component_name}.css
│   │   └── {component_name}.xml
├── security/
│   ├── ir.model.access.csv
│   └── {module_name}_security.xml
├── data/
│   └── {data_file}.xml
├── tests/
│   └── test_{model_name}.py
└── i18n/
    ├── {module_name}.pot
    └── zh_TW.po
```

#### Version Management Strategy

- **Current Development**: `./docs/{module_name}/current/` (symlink to latest)
- **Version Archive**: `./docs/{module_name}/v{major}.{minor}.{patch}/`
- **Migration Documents**: Track changes between Odoo versions (17→18)
- **Changelog**: Document feature additions and bug fixes per version

#### Module-Specific Documentation Guidelines

1. **New Module Creation**:
   - Create version folder: `./docs/{module_name}/v1.0.0/`
   - Generate complete documentation set
   - Update current symlink

2. **Feature Enhancement**:
   - Minor version bump: `v1.1.0`
   - Update existing docs with changes
   - Add migration notes if needed

3. **Bug Fixes**:
   - Patch version bump: `v1.0.1`
   - Update changelog only
   - Keep existing documentation
