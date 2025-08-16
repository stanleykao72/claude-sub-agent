# Session Context Template

> **Purpose**: Central context repository for the current development session. Sub-agents read this file to understand project state before beginning research.

## Project Overview

**Project Name**: [PROJECT_NAME]
**Project Type**: [Web App / Odoo Module / API Service / etc.]
**Current Phase**: [Planning / Development / Testing / Deployment]
**Session Started**: [TIMESTAMP]
**Last Updated**: [TIMESTAMP]

## Project Goals

### Primary Objectives
- [ ] [Main goal 1]
- [ ] [Main goal 2] 
- [ ] [Main goal 3]

### Success Criteria
- [Specific measurable outcome 1]
- [Specific measurable outcome 2]
- [Specific measurable outcome 3]

## Current Status

### Completed Work
- ✅ [Completed task 1]
- ✅ [Completed task 2]

### In Progress  
- 🔄 [Current task 1] (Assigned to: [agent/person])
- 🔄 [Current task 2] (Assigned to: [agent/person])

### Pending
- ⏳ [Pending task 1]
- ⏳ [Pending task 2]

## Technical Context

### Technology Stack
- **Backend**: [Framework/Language]
- **Frontend**: [Framework/Language] 
- **Database**: [Database type]
- **Cloud/Hosting**: [Platform]
- **Testing**: [Testing framework]

### Architecture Decisions
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]
- [Decision 3]: [Rationale]

## Key Requirements

### Functional Requirements
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

### Non-Functional Requirements
- **Performance**: [Specific targets]
- **Security**: [Security requirements]
- **Scalability**: [Scalability needs]
- **Compliance**: [Regulatory requirements]

## Business Context

### Stakeholders
- **Primary Users**: [User types and roles]
- **Business Owner**: [Contact/role]
- **Technical Lead**: [Contact/role]

### Constraints
- **Budget**: [Budget constraints]
- **Timeline**: [Timeline constraints]
- **Resources**: [Resource constraints]
- **Technical**: [Technical constraints]

## Agent Instructions

### For Sub-Agents
1. **Always read this file first** before beginning any research or planning
2. **Focus your research** on the current phase and pending tasks
3. **Consider the constraints** and decisions already made
4. **Create detailed plan files** in agent_plans/ directory

### Context Update Protocol
- **Who can update**: Main agent, orchestrator, human reviewers
- **When to update**: After major decisions, phase transitions, significant discoveries
- **What to update**: Status, decisions, risks, new requirements

---

**Template Version**: 1.0
**Last Updated**: [TIMESTAMP]