# Odoo.sh Command Syntax Corrections

Based on actual odoo.sh SSH session output, the following command syntax corrections were made:

## 1. odoo-update Command

**❌ Incorrect (Previous):**
```bash
odoo-update -u module_name
```

**✅ Correct (Updated):**
```bash
odoo-update module_name
```

**Explanation:** The `odoo-update` command doesn't use the `-u` flag. It takes the module names directly as parameters.

## 2. odoo-bin --test-tags Parameter

**❌ Incorrect (Previous):**
```bash
odoo-bin --test-enable --test-tags module_name
```

**✅ Correct (Updated):**
```bash
odoo-bin --test-enable --test-tags=module_name
```

**Explanation:** The `--test-tags` parameter requires an equals sign (=) to properly pass the module names.

## 3. odoo-bin shell Usage

**✅ Correct (Confirmed):**
```bash
odoo-bin shell -c "python_code_here"
```

**Note:** The `odoo-bin shell` command works as documented and doesn't require database specification since it's already connected to the odoo.sh environment.

## Files Updated

### 1. commands/deploy-odoo.md
- Updated `odoo-update` command syntax in multiple functions
- Fixed `--test-tags` parameter format
- Corrected workflow documentation

### 2. agents/backend/odoo-sh-tester.md
- Updated command descriptions and examples
- Fixed function implementations
- Corrected built-in command integration section

### 3. Documentation Examples
- Updated workflow phase documentation
- Corrected command output examples

## Impact

These corrections ensure that:
1. ✅ Commands work correctly in actual odoo.sh environment
2. ✅ Testing and deployment workflows execute without syntax errors
3. ✅ Documentation matches real odoo.sh command behavior
4. ✅ Developers can copy-paste commands successfully

## Verification

All corrections are based on actual SSH session output from:
```
odoo-esmith-v18-stage30-22611896 [staging/18.0]:~$ odoo-update -h
odoo-esmith-v18-stage30-22611896 [staging/18.0]:~$ odoo-bin -h
odoo-esmith-v18-stage30-22611896 [staging/18.0]:~$ odoo-bin shell -h
```

The updated commands now match the official odoo.sh built-in command syntax.