# Story Template

This template provides a comprehensive structure for creating user stories that integrate BMad-Method's task-driven approach with Claude Sub-Agent workflow system.

## Template Structure

```markdown
# Story [STORY-ID]: [Story Title]

## Story Information
**Story ID**: [Epic-#-Story-#]  
**Story Name**: [Descriptive Title]  
**Epic**: [Parent Epic Name]  
**Priority**: [Critical/High/Medium/Low]  
**Status**: [Draft/Ready/In Progress/Review/Done]  
**Effort**: [Story Points] (1-21 scale)  
**Complexity**: [Low/Medium/High/Very High]  
**Risk Level**: [Low/Medium/High/Critical]  

### Prerequisites (if applicable)
- [ ] **Dependency 1**: [Description of required prerequisite]
- [ ] **Dependency 2**: [Another prerequisite]
- [ ] **Stakeholder Approval**: [Required approvals]

## Story Description
**User Story Format**: 
As a [user persona/role], I want [goal/desire] so that [benefit/value].

**Business Context**:
[Explain why this story exists, its business value, and how it fits into the larger system]

**Acceptance Criteria**:
- [ ] **AC1**: [Specific, measurable, testable criteria]
- [ ] **AC2**: [Another criteria with clear success conditions]
- [ ] **AC3**: [Additional criteria as needed]
- [ ] **AC4**: [Each criteria should be independently testable]

## Technical Implementation Context

### Architecture References
*[Include specific references to architecture documents]*
- **Data Models**: [Reference architecture/data-models.md#section]
- **API Specifications**: [Reference architecture/api-specs.md#endpoints]
- **Security Requirements**: [Reference architecture/security.md#section]
- **Integration Points**: [Reference architecture/integrations.md#section]

### Dependencies & Constraints
**Technical Dependencies**:
- **Requires**: [Previous stories or system components that must be complete]
- **Blocks**: [Future stories that depend on this one]
- **External Dependencies**: [Third-party services, APIs, etc.]

**Technical Constraints**:
- **Performance**: [Response time, throughput requirements]
- **Security**: [Authentication, authorization, data protection]
- **Compatibility**: [Browser support, API versions, etc.]

### Development Notes
*[Critical information extracted from architecture documents - never invent, only reference]*

**Key Technical Details**:
- **File Locations**: [Exact paths where code should be created]
- **Naming Conventions**: [Follow project standards from architecture]
- **Design Patterns**: [Specific patterns to use, with architecture references]
- **Integration Points**: [How this connects with existing systems]

**Previous Story Insights**:
*[If applicable, key learnings from related previous stories]*
- [Learning 1 with reference to previous story]
- [Learning 2 with implementation notes]

## Task Breakdown

### Task 1: [Task Name] 
**Estimated Time**: [X hours]  
**Dependencies**: [None/Task-dependencies]  
**Complexity**: [Low/Medium/High]  
**Assignee Profile**: [Skills needed - Frontend/Backend/Fullstack/DevOps]  
**Parallel Execution**: [Yes/No - can run parallel with other tasks]  

**Description**: [Clear description of what needs to be accomplished]

**Subtasks**:
- [ ] **Subtask 1.1**: [Specific actionable item]
- [ ] **Subtask 1.2**: [Another specific item]
- [ ] **Subtask 1.3**: [More specific work items]
- [ ] **Subtask 1.4**: [Unit tests for this functionality]

**Technical Implementation**:
- **Files to Create/Modify**: 
  - `src/components/ComponentName.tsx` - [Purpose]
  - `src/services/ServiceName.ts` - [Purpose]
- **Key Dependencies**: [npm packages, internal modules]
- **Integration Points**: [APIs, external services]

**Definition of Done**:
- [ ] Code implemented and follows project standards
- [ ] Unit tests written and passing (coverage ≥ 80%)
- [ ] Integration tests passing
- [ ] Code reviewed and approved by **spec-reviewer**
- [ ] Quality validation passed by **spec-validator** 
- [ ] Comprehensive testing completed by **spec-tester**
- [ ] Documentation updated
- [ ] No new linting errors
- [ ] Manual testing completed

**Task Completion Workflow** / **任務完成流程**:
1. **Task Implementation Complete** / **任務實施完成** → 
2. **spec-reviewer**: Code review and best practices validation / **代碼審查與最佳實踐驗證** → 
3. **spec-validator**: Final quality and production readiness assessment / **最終品質與生產就緒評估** → 
4. **spec-tester**: Comprehensive test suite execution / **完整測試套件執行**

⚠️ **Important**: Tasks are only considered fully complete after ALL THREE validation agents approve. / **重要**：只有在所有三個驗證代理都通過後，任務才被認為完全完成。

**Risk Factors**:
- [Risk 1]: [Mitigation strategy]
- [Risk 2]: [Another risk with mitigation]

### Task 2: [Task Name]
**Estimated Time**: [Y hours]  
**Dependencies**: [Task 1]  
**Complexity**: [Low/Medium/High]  
**Assignee Profile**: [Required skills]  

[Similar structure as Task 1...]

### Task 3: [Task Name]
**Estimated Time**: [Z hours]  
**Dependencies**: [Task 1, Task 2]  
**Complexity**: [Low/Medium/High]  
**Assignee Profile**: [Required skills]  

[Similar structure as Task 1...]

## Progress Tracking

### Task Status Overview
- [ ] **Task 1**: [Task Name] - [Not Started/In Progress/Complete]
- [ ] **Task 2**: [Task Name] - [Not Started/In Progress/Complete]  
- [ ] **Task 3**: [Task Name] - [Not Started/In Progress/Complete]

### Acceptance Criteria Status
- [ ] **AC1**: [Criteria description] - [Status]
- [ ] **AC2**: [Criteria description] - [Status]
- [ ] **AC3**: [Criteria description] - [Status]

### Story Progress
**Overall Progress**: [X%] Complete  
**Current Task**: [Currently active task]  
**Blockers**: [Any current blockers or dependencies waiting]  
**Next Steps**: [What should happen next]  

## Quality Assurance

### Testing Requirements
**Test Categories Required**:
- [ ] **Unit Tests**: [Specific components/functions to test]
- [ ] **Integration Tests**: [API endpoints, service integrations]
- [ ] **E2E Tests**: [User workflows to validate]
- [ ] **Performance Tests**: [If applicable - load, stress testing]
- [ ] **Security Tests**: [Authentication, authorization, data protection]

**Test Coverage Goals**:
- Unit Test Coverage: ≥ 80%
- Integration Test Coverage: ≥ 70%
- Critical Path Coverage: 100%

### Code Quality Requirements
- [ ] All linting rules pass
- [ ] Code follows project conventions
- [ ] Security best practices implemented
- [ ] Performance benchmarks met
- [ ] Accessibility standards met (if UI changes)

## Definition of Done Checklist

### Functional Requirements
- [ ] All acceptance criteria are met and verified
- [ ] All tasks are complete and marked as done
- [ ] Manual testing completed successfully
- [ ] Edge cases identified and handled

### Technical Requirements  
- [ ] Code follows project coding standards
- [ ] All automated tests pass (unit, integration, E2E)
- [ ] Test coverage meets project requirements
- [ ] No new security vulnerabilities introduced
- [ ] Performance requirements met
- [ ] **Phase 1 Parallel Validation** / **第一階段平行驗證**:
  - [ ] **spec-reviewer** approval: Code quality and best practices ✅
  - [ ] **spec-validator** approval: Production readiness assessment ✅
- [ ] **Phase 2 Sequential Testing** / **第二階段序列測試**:
  - [ ] **spec-tester** approval: Comprehensive test validation ✅

**Agent Validation Workflow** / **代理驗證工作流程**:
```
Task Complete → spec-reviewer → spec-validator → spec-tester → Story Done
     ↓              ↓              ↓              ↓
  Code Ready    Code Review    Quality Gate   Test Suite
  代碼就緒      代碼審查       品質關卡       測試套件
```

### Documentation & Process
- [ ] Code is properly documented (comments, JSDoc, etc.)
- [ ] Technical documentation updated if needed
- [ ] User documentation updated if needed
- [ ] Story retrospective notes completed
- [ ] Any architectural decisions documented

### Deployment Readiness
- [ ] Build process succeeds without errors
- [ ] Application starts and runs correctly
- [ ] Database migrations (if any) tested
- [ ] Configuration changes documented
- [ ] Rollback plan identified (if needed)

## Story Retrospective

### What Went Well
- [Item 1]: [Description of successful aspect]
- [Item 2]: [Another positive outcome]

### What Could Be Improved
- [Item 1]: [Description of improvement opportunity]
- [Item 2]: [Another area for improvement]

### Lessons Learned
- [Lesson 1]: [Key insight for future stories]
- [Lesson 2]: [Technical learning or process improvement]

### Technical Decisions Made
- [Decision 1]: [What was decided and why]
- [Decision 2]: [Another key technical decision with rationale]

### Follow-up Actions
- [ ] **Action 1**: [Something to address in future stories]
- [ ] **Action 2**: [Process improvement or technical debt item]

---

## Story Completion
**Completed By**: [Developer/Team]  
**Completion Date**: [YYYY-MM-DD]  
**Review Status**: [Pending/Approved/Needs Revision]  
**Deploy Status**: [Not Deployed/Staging/Production]  

**Final Notes**: [Any final comments about the story implementation]

**Agent Validation Summary** / **代理驗證摘要**:
- **spec-reviewer Status**: [ ] Approved / [ ] Needs Revision / **代碼審查狀態**：[ ] 已批准 / [ ] 需修改
- **spec-validator Status**: [ ] Approved / [ ] Needs Revision / **品質驗證狀態**：[ ] 已批准 / [ ] 需修改  
- **spec-tester Status**: [ ] All Tests Pass / [ ] Tests Failed / **測試狀態**：[ ] 所有測試通過 / [ ] 測試失敗

**Story Completion Criteria** / **故事完成標準**:
✅ All tasks implemented and agent-validated / 所有任務已實施並經代理驗證
✅ Sequential validation chain complete / 順序驗證鏈完成
✅ Quality gates passed / 品質關卡通過
✅ Comprehensive testing successful / 全面測試成功
```

## Usage Guidelines

### When to Use This Template
- For complex features requiring multiple development tasks
- When breaking down architectural designs into implementable work
- For stories that need detailed tracking and validation
- When coordinating work across multiple developers

### How to Customize
1. **Remove unused sections** for simpler stories
2. **Add domain-specific sections** as needed
3. **Adjust complexity/effort scales** to match your team
4. **Modify DoD criteria** to align with project standards

### Integration with Agents
- **spec-story-manager**: Uses this template to create stories
- **spec-planner**: Populates task breakdown sections
- **spec-developer**: Updates task completion status
- **spec-progress-tracker**: Monitors progress tracking sections
- **spec-reviewer**: Validates code quality when tasks are marked complete
- **spec-validator**: Performs final quality assessment before testing
- **spec-tester**: Executes comprehensive test suite after validation

### Agent Handoff Process / 代理交接流程
**Sequential Validation Chain** / **順序驗證鏈**:
1. Developer completes task implementation / 開發者完成任務實施
2. **spec-reviewer** performs code review / 進行代碼審查
3. **spec-validator** validates production readiness / 驗證生產就緒性
4. **spec-tester** executes comprehensive testing / 執行全面測試
5. Task marked as fully complete / 任務標記為完全完成

**Quality Gates** / **品質關卡**:
- Each agent must approve before handoff to next agent / 每個代理必須在交接給下一個代理之前批准
- Any failure returns to previous stage for remediation / 任何失敗都會返回到前一階段進行修復
- All three validations must pass for story completion / 所有三個驗證必須通過才能完成故事

### Best Practices
1. **Be specific** - Vague requirements lead to rework
2. **Include context** - Help developers understand the "why"
3. **Reference architecture** - Don't reinvent, cite existing designs
4. **Track dependencies** - Identify what blocks progress
5. **Define done clearly** - Remove ambiguity about completion

This template bridges the gap between high-level requirements and detailed implementation, ensuring nothing falls through the cracks while maintaining development velocity.