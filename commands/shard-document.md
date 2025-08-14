# Shard Document Command

Automatically shard large markdown documents into manageable fragments using the doc-sharding-agent. This command provides flexible document splitting with configurable options and batch processing capabilities.

## Command Syntax

```bash
/shard-document [options] [path]
```

## Parameters

### Required Parameters
- `path` or `--source`: Path to source document or directory to analyze

### Optional Parameters
- `--output`: Custom output directory (default: `{document_name}/`)
- `--threshold`: Minimum lines to trigger sharding (default: 500)
- `--auto`: Auto-detect and shard all large documents in directory
- `--dry-run`: Preview sharding plan without creating files
- `--force`: Override existing sharded directories
- `--config`: Use custom sharding configuration file

## Usage Examples

### Basic Document Sharding
```bash
# Shard a single large document
/shard-document docs/requirements.md

# Shard with custom output location
/shard-document docs/architecture.md --output=docs/arch-fragments/

# Shard with custom threshold
/shard-document specs/api-docs.md --threshold=300
```

### Batch Operations
```bash
# Auto-detect and shard all large documents in docs/
/shard-document docs/ --auto

# Dry run to preview sharding plan
/shard-document docs/ --auto --dry-run

# Force overwrite existing sharded directories
/shard-document docs/requirements.md --force
```

### Advanced Configuration
```bash
# Use custom configuration
/shard-document --config=.claude/custom-sharding.yaml docs/

# Combine multiple options
/shard-document docs/ --auto --threshold=400 --dry-run
```

## Command Workflow

### Step 1: Analysis Phase
The command analyzes documents to determine sharding candidacy:

```markdown
🔍 **Document Analysis**
- Scanning: docs/requirements.md
- Lines: 847 (threshold: 500) ✅ 
- Level 2 sections found: 5
- Special content: 3 code blocks, 1 mermaid diagram
- Recommendation: ✅ Suitable for sharding
```

### Step 2: Planning Phase
Shows detailed sharding plan before execution:

```markdown
📋 **Sharding Plan**
Source: docs/requirements.md
Target: docs/requirements/
Sections to create:
  ├── index.md (navigation + overview)
  ├── business-requirements.md (189 lines)
  ├── functional-specifications.md (298 lines)  
  ├── non-functional-requirements.md (156 lines)
  └── acceptance-criteria.md (204 lines)

Continue with sharding? (y/N)
```

### Step 3: Execution Phase
Invokes doc-sharding-agent to perform the actual sharding:

```markdown
🚀 **Executing Sharding**
Using doc-sharding-agent to process documents...
[Agent output follows]
```

## Configuration Integration

### Default Configuration
The command automatically loads configuration from:
1. `.claude/sharding-config.yaml` (project-specific)
2. Global sharding preferences
3. Built-in defaults

### Configuration Override
Command-line parameters override configuration file settings:

```yaml
# .claude/sharding-config.yaml
sharding:
  threshold: 500
  auto_patterns:
    - "docs/*.md"
    - "specs/**/*.md"
  naming:
    use_numbers: true  # 01_section.md vs section.md
    index_name: "index"  # index.md vs 00_main.md
```

## Auto-Detection Logic

### Pattern Matching
When using `--auto`, the command scans for:
- Markdown files matching configured patterns
- Files exceeding the line threshold
- Documents with sufficient ## section structure

### Smart Filtering
Excludes from auto-sharding:
- Already sharded documents (index.md detected)
- Files smaller than threshold
- Documents without clear section boundaries
- README.md and similar meta-documents

## Output Examples

### Single Document Success
```markdown
✅ **Sharding Complete: requirements.md**

📂 Created: docs/requirements/
├── index.md (overview + navigation)
├── business-requirements.md (189 lines)
├── functional-specifications.md (298 lines)
├── non-functional-requirements.md (156 lines)
└── acceptance-criteria.md (204 lines)

🔗 Access via: docs/requirements/index.md
⏱️ Processing time: 2.3 seconds
```

### Batch Processing Summary
```markdown
✅ **Batch Sharding Complete**

📊 **Summary:**
- Documents scanned: 8
- Documents sharded: 3
- Fragments created: 14
- Skipped (too small): 4
- Skipped (already sharded): 1

📂 **Sharded Documents:**
✓ docs/requirements.md → docs/requirements/ (5 sections)
✓ docs/architecture.md → docs/architecture/ (6 sections)  
✓ specs/api-documentation.md → specs/api-documentation/ (3 sections)

⏱️ Total processing time: 7.2 seconds
```

### Dry Run Output
```markdown
🔍 **Dry Run Results**

**Would shard 2 documents:**

📄 docs/requirements.md (847 lines)
  → docs/requirements/ (5 sections)
  ├── business-requirements.md (189 lines)
  ├── functional-specifications.md (298 lines)
  ├── non-functional-requirements.md (156 lines)
  └── acceptance-criteria.md (204 lines)

📄 docs/architecture.md (1024 lines)
  → docs/architecture/ (6 sections)
  ├── system-overview.md (156 lines)
  ├── component-architecture.md (234 lines)
  ├── database-design.md (198 lines)
  ├── api-specifications.md (287 lines)
  ├── security-framework.md (89 lines)
  └── deployment-strategy.md (140 lines)

**Would skip 3 documents:**
- docs/README.md (78 lines - below threshold)
- docs/changelog.md (already sharded)
- docs/glossary.md (145 lines - insufficient sections)

Run without --dry-run to execute.
```

## Error Handling

### Common Scenarios
```markdown
❌ **Error: File Not Found**
Could not locate: docs/missing.md
Check path and try again.

⚠️ **Warning: Already Sharded**
Document docs/requirements.md appears already sharded.
Use --force to override existing fragments.

❌ **Error: Insufficient Structure** 
Document has only 1 level 2 section.
Sharding requires minimum 2 sections.

❌ **Error: Access Denied**
Cannot write to target directory: docs/protected/
Check permissions and try again.
```

### Recovery Options
- Automatic backup of original files
- Rollback capability for failed sharding
- Detailed error logging with suggestions

## Integration with Workflow

### Agent Workflow Integration
The command seamlessly integrates with the agent workflow system:

```markdown
# In agent-workflow.md
After spec-analyst generates requirements.md:
1. Check document size
2. If > 500 lines, invoke /shard-document --auto docs/
3. Continue with sharded fragments
```

### Manual Workflow
```markdown
# Typical manual workflow
1. Generate large document with spec-agent
2. Run: /shard-document path/to/document.md
3. Review sharded structure
4. Continue development with manageable fragments
```

## Best Practices

### When to Use Command vs Agent
- **Use Command**: Manual control, batch processing, testing sharding
- **Use Agent**: Integrated workflow, custom sharding logic, complex scenarios

### Recommended Thresholds
- **Development docs**: 300-400 lines
- **Specifications**: 500-600 lines  
- **Architecture docs**: 400-500 lines
- **User manuals**: 600+ lines

### Directory Organization
```
docs/
├── requirements.md → requirements/
├── architecture.md → architecture/  
├── api-docs.md → api-docs/
└── small-file.md (kept as single file)
```

## Command Aliases

### Short Forms
```bash
/shard docs/file.md          # Basic sharding
/shard --auto docs/          # Auto-detect mode
/shard --dry docs/           # Preview mode
```

### Integration Shortcuts
```bash
/workflow-shard             # Auto-shard workflow outputs
/shard-specs               # Target specs/ directory
/shard-docs                # Target docs/ directory
```

---

This command provides a flexible, powerful interface to the document sharding functionality while maintaining simplicity for common use cases. It bridges manual control with automated workflow integration.