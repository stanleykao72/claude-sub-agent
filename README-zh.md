# Claude Sub-Agent Spec 工作流系统

> **Language / 語言**: [English](README.md) | [简体中文](README-zh.md) | [繁體中文](README-zht.md)

基于 Claude Code Sub-Agents 功能构建的综合性 AI 驱动开发工作流系统。该系统通过协调多个专业化 AI 代理，将项目创意转化为生产就绪的代码。

## 目录

- [概述](#概述)
- [系统架构](#系统架构)
- [安装指南](#安装指南)
- [快速开始](#快速开始)
- [Slash 命令使用](#slash-命令使用)
- [工作原理](#工作原理)
- [Agent 参考](#agent-参考)
- [使用示例](#使用示例)
- [质量门控](#质量门控)
- [最佳实践](#最佳实践)
- [高级用法](#高级用法)
- [故障排除](#故障排除)

## 概述

Spec 工作流系统利用 Claude Code 的 Sub-Agents 功能创建了一个多代理开发流水线。每个代理都是特定领域的专家，负责软件开发生命周期的特定方面，从需求分析到最终验证。

### 核心特性

- **自动化工作流**：从创意到生产代码的完整开发流水线
- **故事驱动开发**：BMad-Method 集成与用户故事生命周期管理
- **进度跟踪**：实时任务完成跟踪与 3 级复选框层次结构
- **文档分片**：大型文档自动分割以提升 AI 处理效能
- **专业化专长**：每个代理专注于其专业领域
- **质量门控**：自动化检查点确保质量标准
- **灵活集成**：可与现有专业代理协同工作
- **全面文档**：每个阶段都生成详细的文档

### 主要优势

- 从概念到代码的开发速度提升 10 倍
- 故事驱动开发与清晰的验收条件和进度跟踪
- 实时速度分析和阻塞识别
- 自动文档分割以优化 AI 处理和协作效果
- 通过自动化验证确保一致的质量
- 自动生成全面的文档
- 通过系统化流程减少错误
- 通过清晰的工作流程和复选框进度可见性改善协作

## 系统架构

### 多代理 Odoo 18 开发流水线

```mermaid
graph TD
    A[🚀 Odoo 模块创意] --> B[🎭 spec-orchestrator]
    B --> C[📋 规划阶段]
    C --> D[🎯 spec-analyst<br/>Odoo 需求分析]
    D --> E[🏗️ spec-architect<br/>模块架构设计]
    E --> F[📝 spec-planner<br/>任务分解]
    
    F --> G{🥇 质量门控 1<br/>规划 ≥95%}
    G -->|✅ 通过| H[💻 开发阶段]
    G -->|❌ 失败| D
    
    H --> I[💻 spec-developer<br/>Odoo 实现]
    H --> I2[🎨 odoo18-backend-architect<br/>后端模型]
    H --> I3[📱 odoo18-view-generator<br/>XML 视图]
    H --> I4[⚡ odoo18-frontend-architect<br/>OWL 组件]
    I --> J[🧪 spec-tester<br/>测试套件]
    I2 --> J
    I3 --> J
    I4 --> J
    
    J --> K{🥈 质量门控 2<br/>开发 ≥80%}
    K -->|✅ 通过| L[✅ 验证阶段]
    K -->|❌ 失败| I
    
    L --> M[📋 spec-reviewer<br/>代码审查]
    M --> N[✅ spec-validator<br/>生产检查]
    
    N --> O{🥉 质量门控 3<br/>生产就绪 ≥85%}
    O -->|✅ 通过| P[🎉 生产就绪<br/>Odoo 模块]
    O -->|❌ 失败| Q[🔄 智能反馈]
    
    Q --> R{📊 问题分析}
    R -->|规划问题| D
    R -->|开发问题| I
    R -->|验证问题| M
    
    %% 样式
    classDef orchestrator fill:#1a73e8,color:#fff,stroke:#0d47a1,stroke-width:3px
    classDef phase fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px,color:#000
    classDef process fill:#f3e5f5,stroke:#4a148c,stroke-width:2px,color:#000
    classDef odoo fill:#7b1fa2,color:#fff,stroke:#4a148c,stroke-width:2px
    classDef gate fill:#f9ab00,color:#fff,stroke:#e65100,stroke-width:3px
    classDef success fill:#34a853,color:#fff,stroke:#1b5e20,stroke-width:3px
    classDef feedback fill:#ff9800,color:#fff,stroke:#ef6c00,stroke-width:2px
    
    class B orchestrator
    class C,H,L phase
    class D,E,F,I,J,M,N process
    class I2,I3,I4 odoo
    class G,K,O gate
    class P success
    class Q,R feedback
```

## 安装指南

### 前置要求

- Claude Code（最新版本）
- 已初始化的项目目录
- 对 AI 辅助开发的基本了解

### 安装步骤

1. **下载代理文件**

   ```bash
   # 方式 1：克隆仓库
   git clone https://github.com/zhsama/claude-sub-agent.git
   cd claude-sub-agent
   
   # 方式 2：下载所需的特定代理
   # 单个代理文件可在 agents/ 目录中获取
   ```

2. **复制代理和 slash 命令到项目的 Claude Code 目录**

   ```bash
   # 在你的项目中创建 .claude 目录结构
   mkdir -p ../.claude/agents ../.claude/commands ../.claude/template ../.claude/config
   
   # 从分类目录复制所有代理
   cp -r agents/*/*.md ../.claude/agents/
   
   # 复制所有 slash 命令
   cp commands/*.md ../.claude/commands/
   
   # 复制模板目录
   cp -r templates/*.md ../.claude/template/
   
   # 复制 hooks（用于事件驱动自动化）
   cp -r hooks/*.sh ../.claude/hooks/
   
   # 复制配置示例（可选 - 用于 Odoo.sh 集成）
   cp config/odoo-sh.example.json ../.claude/config/
   ```

3. **添加规则到 CLAUDE.md**

   ```md
   ## Odoo 项目文档约定 (重要)

   **文档文件：** 所有新的文档或任务文件都必须按模块和版本组织保存在 `docs/` 文件夹下。例如：

   - **模块需求**：保存在 `docs/{module_name}/v{version}/requirements.md` (例如 `docs/ai_chat/v1.0.0/requirements.md`)
   - **架构规格**：保存在 `docs/{module_name}/v{version}/architecture.md` (例如 `docs/ai_chat/v1.0.0/architecture.md`)
   - **API 文档**：保存在 `docs/{module_name}/v{version}/api-spec.md`
   - **用户故事**：保存在 `docs/{module_name}/v{version}/user-stories.md`
   - **迁移指南**：保存在 `docs/{module_name}/v{version}/migration-guide.md`
   - **集成文档**：保存在 `docs/integration/` 用于跨模块文档
   - **全局标准**：保存在 `docs/global/` 用于项目级标准

   **Odoo 模块文件：** 遵循 Odoo 18 企业版结构：
   - **模型**：放在 `user/{module_name}/models/`
   - **视图**：放在 `user/{module_name}/views/`
   - **控制器**：放在 `user/{module_name}/controllers/`
   - **静态资源**：按组件组织在 `user/{module_name}/static/src/{component_name}/`
   - **安全**：放在 `user/{module_name}/security/`
   - **测试**：放在 `user/{module_name}/tests/`
   - **国际化**：放在 `user/{module_name}/i18n/`

   > **重要提示：** 始终遵循 Odoo 命名约定并确保适当的国际化（代码中不能直接使用中文文本）。
   ```

4. **配置 Claude Code Hooks（推荐）**

   Claude Code Hooks 提供事件驱动的 odoo.sh 部署监控自动化：

   ```bash
   # 使 hooks 可执行
   chmod +x .claude/hooks/*.sh
   
   # Hooks 将在以下情况下自动激活：
   # 1. post-git-push-hook.sh - 在 git push 操作后触发
   # 2. deployment-ready-hook.sh - 在部署监控检测到就绪时触发
   ```

   **Hook 优劢：**
   - **事件驱动**：由 git 操作自动触发
   - **后台监控**：非阻塞式部署进度跟踪
   - **智能测试**：部署就绪时自动执行测试
   - **全面报告**：详细的部署和测试报告

5. **配置 Odoo.sh 集成（可选）**

   对于 Odoo 开发项目，设置 odoo.sh CI/CD 集成：

   ```bash
   # 复制示例配置
   cp .claude/config/odoo-sh.example.json .claude/config/odoo-sh.json
   
   # 编辑配置文件，填入你的 odoo.sh 详细信息
   # 更新 SSH 主机、环境和模块设置
   ```

   **配置示例：**
   ```json
   {
     "environments": {
       "staging": {
         "ssh_host": "your-user@your-project-stage.dev.odoo.com",
         "ssh_key_path": "~/.ssh/odoo_sh_key",
         "active": true
       }
     },
     "default_environment": "staging",
     "test_settings": {
       "default_modules": ["your_module", "your_other_module"]
     }
   }
   ```

   **测试配置：**
   ```bash
   # 测试 SSH 连接
   ssh your-user@your-project-stage.dev.odoo.com "echo '连接成功'"
   
   # 测试 odoo.sh 命令
   ssh your-user@your-project-stage.dev.odoo.com "odoo-bin --version"
   ```

6. **验证安装**

   **仓库结构：**

   ```text
   claude-sub-agent/
   ├── agents/
   │   ├── spec-agents/         # 核心工作流代理
   │   │   ├── spec-analyst.md
   │   │   ├── spec-architect.md
   │   │   ├── spec-developer.md
   │   │   ├── spec-orchestrator.md
   │   │   ├── spec-planner.md
   │   │   ├── spec-reviewer.md
   │   │   ├── spec-tester.md
   │   │   └── spec-validator.md
   │   ├── backend/             # 后端专家
   │   │   ├── senior-backend-architect.md
   │   │   ├── odoo18-backend-architect.md
   │   │   └── odoo-sh-tester.md
   │   ├── frontend/            # 前端专家
   │   │   ├── senior-frontend-architect.md
   │   │   ├── odoo18-view-generator.md
   │   │   └── odoo18-frontend-architect.md
   │   ├── ui-ux/              # 设计专家
   │   │   └── ui-ux-master.md
   │   └── utility/             # 工具代理
   │       ├── doc-sharding-agent.md
   │       ├── git-push-deploy.md
   │       └── refactor-agent.md
   ├── commands/               # Slash 命令
   │   ├── agent-workflow.md
   │   ├── create-story.md
   │   ├── deploy-odoo.md
   │   ├── git-push-deploy.md
   │   ├── shard-document.md
   │   └── track-progress.md
   ├── config/                 # 配置示例
   │   └── odoo-sh.example.json
   ├── hooks/                  # Claude Code Hooks
   │   ├── post-git-push-hook.sh
   │   └── deployment-ready-hook.sh
   ├── templates/              # 故事和文档模板
   │   └── story-template.md
   └── CLAUDE.md
   ```

   **安装后你的项目结构：**

   ```text
   your-project/
   ├── .claude/
   │   ├── commands/
   │   │   ├── agent-workflow.md   # 主要工作流 slash 命令
   │   │   ├── create-story.md     # 故事创建命令
   │   │   ├── deploy-odoo.md      # Odoo.sh 部署命令
   │   │   ├── git-push-deploy.md  # Git 推送与部署监控
   │   │   ├── shard-document.md   # 文档分片命令
   │   │   └── track-progress.md   # 进度跟踪命令
   │   ├── config/
   │   │   └── odoo-sh.json        # Odoo.sh 配置（可选）
   │   ├── hooks/
   │   │   ├── post-git-push-hook.sh     # 自动部署监控 hook
   │   │   └── deployment-ready-hook.sh  # 自动测试触发 hook
   │   ├── templates/
   │   │   └── story-template.md   # 用户故事模板
   │   └── agents/
   │       ├── spec-analyst.md
   │       ├── spec-architect.md
   │       ├── spec-developer.md
   │       ├── spec-orchestrator.md
   │       ├── spec-planner.md
   │       ├── spec-progress-tracker.md
   │       ├── spec-reviewer.md
   │       ├── spec-story-manager.md
   │       ├── spec-tester.md
   │       ├── spec-validator.md
   │       ├── senior-backend-architect.md
   │       ├── odoo18-backend-architect.md
   │       ├── odoo-sh-tester.md
   │       ├── senior-frontend-architect.md
   │       ├── odoo18-view-generator.md
   │       ├── odoo18-frontend-architect.md
   │       ├── ui-ux-master.md
   │       ├── doc-sharding-agent.md
   │       ├── git-push-deploy.md
   │       └── refactor-agent.md
   ├── CLAUDE.md
   └── ... (你的项目文件)
   ```

## 快速开始

### 基本使用

```bash
# 启动新项目工作流
询问 Claude："使用 spec-orchestrator 代理创建一个待办事项 Web 应用"

# 协调器将自动：
# 1. 分析需求
# 2. 设计架构
# 3. 规划任务
# 4. 实现代码
# 5. 编写测试
# 6. 审查和验证
```

### 简单示例

```markdown
你：使用 spec-orchestrator 创建一个个人博客平台

Claude (spec-orchestrator)：正在启动个人博客平台的工作流...

[规划阶段 - 45 分钟]
✓ 需求分析完成
✓ 架构设计完成
✓ 任务规划完成
✓ 质量门控 1：通过 (96/100)

[开发阶段 - 2 小时]
✓ 15 个任务已实现
✓ 测试编写完成
✓ 质量门控 2：通过 (88/100)

[验证阶段 - 30 分钟]
✓ 代码审查完成
✓ 最终验证完成
✓ 质量门控 3：通过 (91/100)

项目完成！生成的产物：
- requirements.md（需求文档）
- architecture.md（架构文档）
- 源代码（15 个文件）
- 测试套件（85% 覆盖率）
- 文档
```

## Slash 命令使用

为了最快地启动完整的工作流，请使用我们的自定义斜杠命令：

### 基本用法

```bash
/agent-workflow "创建一个带用户认证和实时更新功能的任务管理 Web 应用"
```

### 高级使用

```bash
# 高质量企业项目
/agent-workflow "开发一个包含客户管理和分析功能的 CRM 系统" --quality=95

# 快速原型开发
/agent-workflow "简单的个人博客网站" --quality=75 --skip-agent=spec-tester

# 基于现有需求
/agent-workflow "基于现有需求的移动应用" --skip-agent=spec-analyst

# 只运行特定阶段
/agent-workflow "微服务电商平台" --phase=planning
```

### 命令选项

- `--quality=[75-95]`: 设置质量门控阈值
- `--skip-agent=[agent名称]`: 跳过特定的 agent
- `--phase=[planning|development|validation|all]`: 运行特定阶段
- `--output-dir=[路径]`: 指定输出目录
- `--language=[zh|en]`: 文档语言

**📖 完整的 slash 命令文档请参见：**
- [agent-workflow.md](./commands/agent-workflow.md) - 主要工作流编排
- [create-story.md](./commands/create-story.md) - 故事创建和管理
- [deploy-odoo.md](./commands/deploy-odoo.md) - Odoo.sh 部署和测试
- [git-push-deploy.md](./commands/git-push-deploy.md) - Git 推送与智能部署监控
- [track-progress.md](./commands/track-progress.md) - 实时进度跟踪
- [shard-document.md](./commands/shard-document.md) - 文档分片和组织

**🎣 Hook 基础自动化：**
- [post-git-push-hook.sh](./hooks/post-git-push-hook.sh) - git push 后自动部署监控
- [deployment-ready-hook.sh](./hooks/deployment-ready-hook.sh) - 部署就绪时自动测试

## 工作原理

### 1. Claude Code Sub-Agents 集成

根据 Claude Code 的文档，sub-agents 的工作方式：

- 在隔离的上下文窗口中运行
- 防止主对话的污染
- 允许专业化、聚焦的交互
- 基于任务上下文自动选择

我们的系统通过为每个开发阶段创建专业代理来利用这些特性。

### 2. 工作流阶段

#### 规划阶段

1. **spec-analyst**：分析需求并创建用户故事
2. **spec-architect**：设计系统架构
3. **spec-planner**：将工作分解为任务
4. **质量门控 1**：验证规划完整性

#### 开发阶段

1. **spec-developer**：基于任务实现代码
2. **spec-tester**：编写全面的测试
3. **质量门控 2**：验证代码质量

#### 验证阶段

1. **spec-reviewer**：审查代码最佳实践
2. **spec-validator**：最终生产就绪检查
3. **质量门控 3**：确保部署就绪

### 3. 代理通信

代理通过结构化文档进行通信：

- 每个代理产生特定的文档
- 下一个代理使用前一个的输出作为输入
- 协调器管理整个流程
- 质量门控确保一致性

## Agent 参考

### 代理分类系统

我们的代理按专业类别组织，以便更好地管理和提供领域专长：

- **spec-agents/**: 核心工作流编排代理
- **backend/**: 后端系统专家
- **frontend/**: 前端开发专家
- **ui-ux/**: 用户体验和设计专家
- **utility/**: 通用工具代理

### 核心工作流代理 (spec-agents/)

| 代理 | 用途 | 输入 | 输出 |
|------|------|------|------|
| spec-orchestrator | 工作流协调 | 项目描述 | 状态报告、路由 |
| spec-analyst | 需求分析 | 用户描述 | requirements.md、user-stories.md |
| spec-architect | 系统设计 | 需求 | architecture.md、api-spec.md |
| spec-planner | 任务规划 | 架构 | tasks.md、test-plan.md |
| spec-developer | 实现 | 任务 | 源代码、单元测试 |
| spec-tester | 测试 | 代码 | 测试套件、覆盖率报告 |
| spec-reviewer | 代码审查 | 代码 | 审查报告、改进建议 |
| spec-validator | 最终验证 | 所有产物 | 验证报告、质量分数 |

### 按类别分类的专业代理

#### 后端专家 (backend/)

| 代理 | 领域 | 集成点 |
|------|------|---------|
| senior-backend-architect | 后端系统与架构 | 架构/开发阶段 |
| odoo18-backend-architect | Odoo 18 后端开发 | 架构/开发阶段 |

#### 前端专家 (frontend/)

| 代理 | 领域 | 集成点 |
|------|------|---------|
| senior-frontend-architect | 前端系统与架构 | 开发阶段 |
| odoo18-view-generator | Odoo 18 XML 视图生成 | 开发阶段 |
| odoo18-frontend-architect | Odoo 18 OWL 前端开发 | 开发阶段 |

#### UI/UX 专家 (ui-ux/)

| 代理 | 领域 | 集成点 |
|------|------|---------|
| ui-ux-master | 用户体验与界面设计 | 规划/开发阶段 |

#### 工具代理 (utility/)

| 代理 | 领域 | 集成点 |
|------|------|---------|
| git-push-deploy | Git 推送与部署监控 | 开发后期、CI/CD 集成 |
| refactor-agent | 代码质量与重构 | 任何阶段 |

## 使用示例

### 示例 1：企业应用

```bash
# 高质量企业系统
使用 spec-orchestrator，质量阈值设为 95：
创建一个企业 CRM 系统，包含：
- 多租户支持
- 基于角色的访问控制
- RESTful API
- 实时仪表板
- 审计日志
```

### 示例 2：快速原型

```bash
# 快速原型，较低质量阈值
使用 spec-orchestrator，质量阈值 75，跳过分析师：
创建一个简单的落地页，带邮件收集功能
```

### 示例 3：基于现有需求

```bash
# 从现有文档开始
使用 spec-orchestrator 从需求开始：
从 ./docs/requirements.md 加载需求并继续工作流
```

### 示例 4：仅特定阶段

```bash
# 仅对现有代码运行验证
使用 spec-orchestrator 仅进行验证阶段：
验证 ./my-app/ 中的项目
```

### 示例 5：Odoo.sh CI/CD 集成

```bash
# 部署 Odoo 模块到测试环境
/deploy-odoo staging --modules=ai_chat,ai_config --test-suite=comprehensive

# 快速部署，最小化测试
/deploy-odoo --test-suite=quick

# 仅健康检查（无部署）
/deploy-odoo --test-suite=health-only

# 直接使用 odoo-sh-tester
使用 odoo-sh-tester：对 AI 模块运行综合测试套件
使用 odoo-sh-tester：检查 odoo.sh 环境健康状况和近期日志
使用 odoo-sh-tester：打开交互式 Odoo shell 进行调试
```

### 示例 6：Git 推送与部署监控

```bash
# 智能 Git 推送与自动化 odoo.sh 部署监控
/git-push-deploy --message="实现 AI 聊天改进" --test-suite=comprehensive

# 快速部署与最小测试
/git-push-deploy --test-suite=quick --timeout=300

# 紧急部署仅健康检查
/git-push-deploy --message="热修复：关键安全更新" --test-suite=health-only

# 多分支部署
/git-push-deploy --branch="staging" --strategy=polling --modules="ai_chat,ai_config"

# 直接使用 git-push-deploy 代理
使用 git-push-deploy：推送当前更改并监控 odoo.sh 部署与综合测试
使用 git-push-deploy：紧急部署消息"修复关键错误"并仅健康检查测试
使用 git-push-deploy：推送到 staging 分支，使用轮询策略和 10 分钟超时
```

### 示例 7：Hook 基础事件驱动自动化

```bash
# Hooks 在 git 操作时自动激活：

# 1. 开发者推送代码
git push origin v18-dev25

# 2. post-git-push-hook.sh 自动：
#    - 检测 Odoo 相关更改
#    - 启动后台部署监控
#    - 跟踪 SSH 连接性和服务状态
#    - 完成时创建部署就绪触发器

# 3. deployment-ready-hook.sh 自动：
#    - 执行综合测试套件
#    - 生成详细测试报告
#    - 提供成功/失败通知
#    - 创建可行动的后续步骤

# 手动 hook 监控：
tail -f .claude/config/deployment-hooks.log

# Hook 状态和控制：
# 查看活动监控进程
ps aux | grep deployment-monitor

# 如需停止部署监控
kill $(cat .claude/config/deployment-monitor.pid)
```

## 质量门控

### 门控 1：规划质量（95% 阈值）

- 需求完整性
- 架构可行性
- 任务分解质量
- 用户故事清晰度

### 门控 2：开发质量（80% 阈值）

- 测试覆盖率
- 代码质量指标
- 安全扫描结果
- 性能基准

### 门控 3：生产就绪（85% 阈值）

- 整体质量分数
- 文档完整性
- 部署就绪度
- 运营要求

## 最佳实践

### 1. 项目准备

- 编写清晰的项目描述
- 包含约束和需求
- 指定质量期望
- 提供现有文档

### 2. 与代理协作

- 让每个代理完成其阶段
- 在阶段之间审查产物
- 有效使用反馈循环
- 信任质量门控

### 3. 自定义

- 根据需要调整质量阈值
- 为简单项目跳过代理
- 添加自定义验证标准
- 与现有工作流集成

### 4. 性能优化

- 为大型项目启用并行执行
- 缓存结果用于迭代开发
- 使用特定阶段执行
- 监控资源使用

## 高级用法

### 自定义工作流

```python
# 创建自定义工作流配置
workflow_config = {
    "quality_threshold": 90,
    "skip_agents": ["spec-analyst"],  # 如果你已有需求
    "parallel": True,
    "custom_validators": ["security-scan", "performance-test"],
    "output_format": "markdown"
}

# 使用自定义配置执行
"使用 spec-orchestrator，配置：" + json.dumps(workflow_config)
```

### CI/CD 集成

```yaml
# GitHub Actions 示例
name: AI 工作流验证
on: [pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: 运行 Spec 验证
        run: |
          # 使用 Claude Code CLI（如果可用）
          claude-code run spec-orchestrator \
            --phase validation \
            --project-path .
```

### 扩展系统

1. **添加新代理**
   - 使用 YAML 前置内容创建代理
   - 定义明确的职责
   - 指定输入/输出格式
   - 更新协调器路由

2. **自定义质量门控**
   - 定义新标准
   - 设置适当的阈值
   - 实现验证逻辑
   - 添加到工作流

3. **领域特定工作流**
   - 创建专门的协调器
   - 定义领域模式
   - 自定义质量标准
   - 针对特定需求优化

## 故障排除

### 常见问题

1. **找不到代理**
   - 验证代理在正确的目录
   - 检查 YAML 前置内容格式
   - 确保适当的文件权限

2. **质量门控失败**
   - 查看失败的具体标准
   - 检查产物完整性
   - 允许代理修改其工作
   - 考虑调整阈值

3. **工作流卡住**
   - 检查协调器状态
   - 查看最后的代理输出
   - 查找错误消息
   - 从最后的检查点重启

### 调试模式

```bash
# 启用详细日志
使用 spec-orchestrator 的调试模式：
创建测试项目并显示所有代理交互
```

## 贡献指南

欢迎贡献！请：

1. 遵循现有的代理格式
2. 添加全面的文档
3. 包含使用示例
4. 与协调器测试
5. 提交带描述的 PR

## 许可证

MIT 许可证 - 详见 LICENSE 文件

## 致谢

- 基于 Claude Code 的 Sub-Agents 功能构建
- 受 BMAD 方法论启发
- 欢迎社区贡献

---

更多信息请参见：

- [Claude Code 文档](https://docs.anthropic.com/en/docs/claude-code)
- [Sub-Agents 指南](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [项目问题](https://github.com/zhsama/claude-sub-agent/issues)
