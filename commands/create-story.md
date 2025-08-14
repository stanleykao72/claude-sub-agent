# Create Story Command

Generate comprehensive user stories with BMad-Method integration, leveraging the spec-story-manager agent for structured story creation from requirements, epics, or architectural designs.

## Command Syntax

```bash
/create-story [options] [source]
```

## Parameters

### Required Parameters
- `source` or `--from`: Source for story creation (requirements file, epic description, or inline description)

### Optional Parameters
- `--epic`: Epic identifier or name to associate with the story
- `--priority`: Story priority (Critical/High/Medium/Low)
- `--complexity`: Expected complexity (Low/Medium/High/Very High)
- `--points`: Story points estimate (1-21 Fibonacci scale)
- `--template`: Custom story template to use
- `--output`: Output directory for story file (default: stories/)
- `--interactive`: Interactive mode for guided story creation

## Usage Examples

### Basic Story Creation

```bash
# Create story from requirements file
/create-story requirements.md

# Create story from inline description
/create-story "User authentication system with JWT tokens"

# Create story with metadata
/create-story "User dashboard" --epic="User Management" --priority=High --points=8
```

### Epic-Based Story Creation

```bash
# Create story within specific epic
/create-story requirements.md --epic="Epic-1-Authentication" 

# Interactive epic selection
/create-story requirements.md --interactive
```

### Template-Driven Creation

```bash
# Use custom template
/create-story requirements.md --template=templates/odoo-story-template.md

# Output to specific location
/create-story requirements.md --output=docs/epics/epic-1/stories/
```

## Command Workflow

### Phase 1: Source Analysis
The command analyzes the provided source to extract story context:

```markdown
🔍 **Source Analysis**
- Analyzing: requirements.md
- Content type: Requirements document
- Sections found: 5 functional requirements
- Integration points: 3 external systems
- Acceptance criteria potential: 12 criteria identified
```

### Phase 2: Story Planning
Interactive story planning and structure definition:

```markdown
📋 **Story Planning Session**

**Suggested Story Title**: User Authentication System
**Suggested Epic**: Epic-1-User-Management  
**Estimated Complexity**: Medium
**Suggested Points**: 8 story points

**Identified Acceptance Criteria**:
1. User can register with email and password
2. User can login with valid credentials  
3. System generates and validates JWT tokens
4. User sessions expire after configured timeout

Continue with these suggestions? (y/N)
Or customize interactively? (c)
```

### Phase 3: Story Generation
Invokes spec-story-manager to create comprehensive story:

```markdown
🚀 **Generating Story with spec-story-manager**

Using spec-story-manager to create structured story...
- Template: story-template.md
- Source context: requirements.md
- Architecture references: architecture.md
- Integration points: API specifications

[spec-story-manager output follows]
```

## Story Creation Modes

### Mode 1: Requirements-Driven Creation
From requirements documents or specifications:

```bash
/create-story docs/requirements.md --epic="User-System"
```

**Process:**
1. Parse requirements document for functional and non-functional requirements
2. Extract user personas and use cases
3. Identify acceptance criteria and success conditions
4. Map to technical architecture context
5. Generate story with comprehensive task breakdown

### Mode 2: Epic-Based Creation  
From epic definitions or story themes:

```bash
/create-story --from="Implement user authentication system" --epic="Authentication"
```

**Process:**
1. Analyze epic context and related stories
2. Identify story scope within epic boundaries
3. Extract dependencies from previous/related stories
4. Generate story that fits epic narrative
5. Ensure proper story sequencing and dependencies

### Mode 3: Interactive Creation
Guided story creation with prompts:

```bash
/create-story --interactive
```

**Interactive Flow:**
```markdown
🎭 **Interactive Story Creation**

Step 1: Story Basics
- Story title: [User input]
- Epic association: [Select from existing epics]
- Priority level: [Select: Critical/High/Medium/Low]

Step 2: User Context  
- Primary user persona: [Description]
- User goal: [What user wants to accomplish]
- Business value: [Why this matters]

Step 3: Acceptance Criteria
- AC1: [Interactive criteria definition]
- AC2: [Another criteria]
- [Continue adding criteria...]

Step 4: Technical Context
- Architecture references: [Select relevant documents]
- Integration points: [Identify connections]
- Dependencies: [Identify prerequisites]

Step 5: Story Validation
[Preview generated story for approval]
```

## Story Metadata Management

### Epic Integration
Automatically integrate with existing epic structure:

```yaml
# Epic Integration Logic
epic_association:
  auto_detect: true
  epic_patterns:
    - "Epic-[0-9]+-.*"
    - "[A-Z]+-[0-9]+"
  epic_validation:
    - check_epic_exists: true
    - validate_story_sequence: true
    - ensure_epic_alignment: true
```

### Story ID Generation
Automatic story ID creation:

```markdown
## Story ID Generation Rules

### Format: Epic-[EpicNum]-Story-[StoryNum]
**Examples**:
- Epic-1-Story-1.1: First story in first epic
- Epic-2-Story-3.2: Second story in third group of second epic
- Epic-1-Story-5.1: First story in fifth group of first epic

### Auto-Increment Logic:
1. **Detect Existing Stories**: Scan output directory for existing stories
2. **Find Epic Context**: Identify epic number from epic association
3. **Calculate Next ID**: Determine next sequential story number
4. **Validate Uniqueness**: Ensure generated ID is unique
```

### Priority and Complexity Assessment

#### Automatic Assessment
Generate intelligent estimates based on content analysis:

```markdown
## Automatic Assessment Criteria

### Priority Assessment:
**Critical**: Security, data integrity, system availability
**High**: Core user workflows, major features
**Medium**: Feature enhancements, usability improvements  
**Low**: Minor features, nice-to-have functionality

### Complexity Assessment:
**Very High**: 13-21 points, architectural changes, multi-team coordination
**High**: 8-13 points, complex business logic, multiple integrations
**Medium**: 3-8 points, standard CRUD, single integration
**Low**: 1-3 points, simple features, configuration changes

### Story Points Estimation:
Based on:
- Number of acceptance criteria
- Technical complexity indicators
- Integration requirements
- Testing complexity
- Risk factors identified
```

## Integration with Story Management

### Workflow Integration
Seamless integration with spec-story-manager workflow:

```markdown
## Story Creation → Management Pipeline

### Creation Phase:
1. **/create-story** generates story structure
2. **spec-story-manager** validates story completeness
3. **Story status**: Set to "Draft" initially

### Validation Phase:
1. Execute story draft checklist validation
2. Verify acceptance criteria quality
3. Validate technical context completeness
4. Check architecture reference alignment

### Planning Phase:
1. Integrate with **spec-planner** for task breakdown
2. Generate initial task estimates and dependencies
3. Create checkbox hierarchy for progress tracking
4. Plan testing strategy and validation approach

### Handoff to Development:
1. Story status updated to "Ready"
2. Development team assignment and scheduling
3. Integration with **spec-progress-tracker** for monitoring
4. Begin development cycle with story context
```

## Output Formats and Templates

### Standard Story Output
Generated story includes comprehensive sections:

```markdown
# Story Epic-1-Story-2.1: User Authentication System

## Story Information
**Story ID**: Epic-1-Story-2.1
**Story Name**: User Authentication System
**Epic**: Epic-1-User-Management
**Priority**: High
**Status**: Draft
**Effort**: 8 story points
**Complexity**: Medium
**Risk Level**: Medium

[Complete story structure following story-template.md]
```

### Summary Report
Command generates creation summary:

```markdown
✅ **Story Creation Complete**

**Generated**: stories/epic-1-story-2-1-user-authentication-system.md
**Story ID**: Epic-1-Story-2.1
**Epic**: Epic-1-User-Management
**Status**: Draft
**Estimated Points**: 8 points (Medium complexity)

**Story Contents**:
- 4 acceptance criteria defined
- 12 technical context references
- 3 architectural dependencies identified
- 6 initial tasks planned

**Next Steps**:
1. Review story draft with stakeholders
2. Validate acceptance criteria completeness
3. Use spec-planner for detailed task breakdown
4. Update story status to "Ready" when approved

**Integration Ready**: 
- Story available for spec-planner task breakdown
- Ready for spec-progress-tracker monitoring
- Integrated with agent-workflow system
```

## Advanced Features

### Multi-Story Creation
Create multiple related stories from complex sources:

```bash
# Create story suite from large requirements
/create-story requirements.md --multi --epic="User-System"
```

### Template Customization
Support for domain-specific templates:

```bash
# Use Odoo-specific template
/create-story requirements.md --template=templates/odoo-module-story.md

# Use API development template  
/create-story api-spec.md --template=templates/api-story.md
```

### Story Dependencies
Automatic dependency detection and management:

```markdown
## Dependency Management

### Automatic Detection:
- **Sequential Dependencies**: Stories that must complete in order
- **Technical Dependencies**: Shared components or infrastructure
- **Business Dependencies**: Related business functionality

### Dependency Notation:
- **Requires**: Epic-1-Story-1.1 (blocking dependency)
- **Related**: Epic-1-Story-2.2 (coordination needed)
- **Enhances**: Epic-1-Story-1.3 (builds upon existing story)
```

## Quality Assurance

### Story Validation
Automatic quality checks during creation:

```markdown
## Story Quality Checklist

### Content Completeness:
- [ ] Clear story title and description
- [ ] Well-defined acceptance criteria (2-6 criteria)
- [ ] Technical context with architecture references
- [ ] Dependencies clearly identified
- [ ] Risk assessment included

### Quality Criteria:
- [ ] Acceptance criteria are testable and measurable
- [ ] Story scope is appropriate (not too large/small)
- [ ] Technical context sufficient for implementation
- [ ] Architecture alignment verified
- [ ] Integration points identified

### Validation Results:
**Content Quality**: [85%] - Good
**Clarity Score**: [92%] - Excellent  
**Technical Context**: [78%] - Adequate
**Ready for Development**: [Yes/No]
```

## Error Handling & Recovery

### Common Scenarios
```markdown
❌ **Error: Source Not Found**
Could not locate: requirements.md
Available sources in current directory:
- architecture.md
- user-guide.md
- api-specs.md

⚠️ **Warning: Epic Not Found**
Epic "Epic-99-Invalid" not found.
Available epics:
- Epic-1-User-Management
- Epic-2-Data-Processing  
- Epic-3-Integration

❌ **Error: Template Invalid**
Template validation failed: Missing required sections
Required sections: Story Information, Acceptance Criteria, Technical Context
```

### Recovery Options
- Automatic source suggestion based on content analysis
- Interactive epic selection from available options
- Template validation with detailed error reporting
- Partial story creation with completion recommendations

---

This command provides a comprehensive entry point into the story-driven development workflow, ensuring consistent, high-quality story creation that integrates seamlessly with the broader spec-agent ecosystem.