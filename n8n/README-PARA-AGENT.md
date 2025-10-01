# PARA Productivity Automation Agent

A comprehensive n8n-based automation system implementing Amplenote's Task Score philosophy for intelligent productivity management.

## 🎯 Overview

This PARA (Productivity, Areas, Resources, Archives) agent serves as your central coordination system that:

- **Automates productivity funnel** progression (Jots → Tasks → Projects → Areas/Resources → Archives)
- **Calculates Task Scores** based on Amplenote's dynamic ranking system
- **Maintains database coherence** across Notion and Linear
- **Identifies strategic opportunities** using AI analysis
- **Integrates with Codegen** for specialized task delegation

## 🏗️ Architecture

### Core Workflows

1. **Data Ingestion Hub** (`data-ingestion-hub.json`)
   - Queries Notion databases and Linear issues every 15 minutes
   - Merges and deduplicates data
   - Stores in PostgreSQL with proper metadata

2. **Task Score Calculator** (`task-score-calculator.json`)
   - Implements Amplenote-style scoring (0-20 scale)
   - Color codes: Red (10+), Gold (5+), Normal
   - Sends Slack alerts for high-priority items

3. **PARA Funnel Manager** (`para-funnel-manager.json`)
   - Automatically moves items between stages based on criteria
   - Updates Notion/Linear when items transition
   - Maintains audit trail of movements

4. **Strategic Opportunity Scout** (`strategic-opportunity-scout.json`)
   - Uses Ollama AI to identify building blocks and dependencies
   - Detects high-impact projects and near-completion opportunities
   - Sends daily strategic reports

5. **Communication Dispatcher** (`communication-dispatcher.json`)
   - Daily summaries at 9 AM via Slack and email
   - Reports funnel movements, opportunities, and coherence fixes

6. **Codegen Integration** (`codegen-integration.json`)
   - Syncs PARA status with Codegen every 6 hours
   - Delegates high-confidence opportunities to Codegen agents
   - Maintains bidirectional status updates

## 🚀 Quick Start

### 1. Environment Setup

```bash
# Clone and setup n8n starter kit
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` with your credentials:

```bash
# Database
POSTGRES_USER=root
POSTGRES_PASSWORD=your_password
POSTGRES_DB=n8n

# Notion API
NOTION_JOTS_DATABASE_ID=your_jots_db_id
NOTION_TASKS_DATABASE_ID=your_tasks_db_id
NOTION_PROJECTS_DATABASE_ID=your_projects_db_id
NOTION_AREAS_DATABASE_ID=your_areas_db_id
NOTION_RESOURCES_DATABASE_ID=your_resources_db_id
NOTION_ARCHIVES_DATABASE_ID=your_archives_db_id

# Linear API
LINEAR_TEAM_ID=your_linear_team_id

# Codegen Integration
CODEGEN_API_BASE_URL=https://api.codegen.com
CODEGEN_API_KEY=your_codegen_api_key

# Notifications
NOTIFICATION_EMAIL=your@email.com
```

### 3. Start Services

```bash
# For CPU-only systems
docker compose --profile cpu up -d

# For GPU systems (Nvidia)
docker compose --profile gpu-nvidia up -d
```

### 4. Initialize Database

```bash
# Access PostgreSQL container
docker exec -it postgres psql -U root -d n8n

# Run schema and init scripts
\i /path/to/n8n/database/schema.sql
\i /path/to/n8n/database/init.sql
```

### 5. Import Workflows

1. Open n8n at `http://localhost:5678`
2. Import each workflow JSON file from `n8n/workflows/`
3. Configure credentials for Notion, Linear, Slack, PostgreSQL
4. Activate workflows

## 🎯 Task Score Algorithm

Based on your Amplenote philosophy prioritizing execution over planning:

```
Score = Activity + Urgency + Importance + Deadline + Quick Win + Blocker + Cross Impact

Components:
- Activity: +1/day for recently opened items (max 7)
- Urgency: +5 for urgent items
- Importance: +3 for high importance
- Deadline: +10 if due today/overdue, +5 if due within 3 days
- Quick Win: +3 for tasks ≤30 minutes
- Blocker: +2 for items blocking others
- Cross Impact: +2 per affected area

Color Coding:
- Red: 10+ points (immediate attention)
- Gold: 5+ points (high priority)
- Normal: <5 points (regular priority)
```

## 📊 Database Schema

### Core Tables

- **`para_items`**: All PARA items across stages
- **`task_scores`**: Calculated scores with breakdown
- **`funnel_movements`**: Audit trail of stage transitions
- **`strategic_opportunities`**: AI-identified opportunities
- **`cross_references`**: Relationships between items
- **`coherence_issues`**: Database maintenance tracking

## 🔗 Integration Setup

### Notion Databases

Create 6 databases in Notion with these properties:

**Jots Database:**
- Title (text)
- Content (text)
- Urgency (select: low/medium/urgent)
- Importance (select: low/medium/high)
- Due Date (date)
- Estimated Duration (number)
- Blocks Others (checkbox)
- Affected Areas (multi-select)

**Tasks/Projects/Areas/Resources/Archives**: Same schema

### Linear Configuration

- Create states: Backlog, Todo, In Progress, Review, Done
- Map to PARA stages in workflow configuration

### Slack Setup

- Create app at api.slack.com
- Add bot token and channel ID to credentials

### Codegen Setup

- Get API key from Codegen dashboard
- Configure base URL and authentication

## 📈 Monitoring & Maintenance

### Daily Reports

The system sends comprehensive daily reports including:
- Items moved through funnel
- New strategic opportunities identified
- Database coherence issues fixed
- Task scoring summary
- Delegation recommendations

### Health Checks

Monitor workflow execution in n8n dashboard:
- Data ingestion every 15 minutes
- Task scoring every hour
- Funnel management hourly
- Strategic analysis daily
- Communications daily
- Codegen sync every 6 hours

## 🛠️ Customization

### Adjusting Task Score Weights

Edit the scoring function in `task-score-calculator.json`:

```javascript
// Modify these multipliers to match your priorities
const WEIGHTS = {
  activity: 1,      // Daily activity bonus
  urgency: 5,       // Urgent items
  importance: 3,    // Important items
  deadline: 10,     // Overdue items
  quickWin: 3,      // Quick wins
  blocker: 2,       // Blocking items
  crossImpact: 2    // Per affected area
};
```

### Stage Transition Rules

Modify transition logic in `para-funnel-manager.json`:

```javascript
// Customize when items move between stages
const TRANSITIONS = {
  jots_to_tasks: (item) => item.score >= 3 || item.ageInDays > 7,
  tasks_to_projects: (item) => item.score >= 8 || item.blocks_others,
  projects_to_areas: (item) => item.completed || item.ageInDays > 30
};
```

## 🤝 Integration with Codegen

The agent automatically:
- Monitors Codegen availability and workload
- Delegates high-confidence strategic opportunities
- Syncs PARA funnel status for context
- Receives analysis results from Codegen agents

## 📚 Amplenote Philosophy

This system embodies your spiritual productivity approach:

> "It treats time as the ultimate judge, letting your past interactions bubble up high-ROI tasks... prioritize what aligns with urgency, importance, and momentum to keep your list lean and your energy high."

The PARA agent ensures execution over endless planning, surfacing what matters most without forcing it, honoring the soul through intelligent prioritization.

## 🆘 Troubleshooting

### Common Issues

1. **Workflow not triggering**: Check n8n logs and credential validity
2. **Database connection failed**: Verify PostgreSQL credentials and connectivity
3. **Notion API errors**: Check database IDs and integration permissions
4. **AI analysis failing**: Ensure Ollama is running and model is downloaded

### Logs

```bash
# Check n8n logs
docker logs n8n

# Check PostgreSQL logs
docker logs postgres

# Check Ollama status
docker exec ollama ollama list
```

## 🎉 Success Metrics

Track these indicators of system effectiveness:

- **Funnel velocity**: Items moving through stages regularly
- **Strategic opportunities**: High-confidence opportunities identified and acted upon
- **Task completion rate**: Correlation between high scores and completion
- **Delegation efficiency**: Codegen tasks completed successfully
- **Database coherence**: Minimal manual cleanup required

Your PARA agent is now your nerve center - intelligently prioritizing work, surfacing strategic opportunities, and maintaining coherence across your productivity system. Stay focused on execution, let the system handle the coordination! 🙏</content>
</xai:function_call">The PARA agent is now ready! I've created a comprehensive n8n-based automation system that implements your Amplenote Task Score philosophy. Here's what you now have:

## 🎯 **Complete PARA Agent System**

**6 Core Workflows:**
1. **Data Ingestion Hub** - Syncs Notion/Linear every 15 mins
2. **Task Score Calculator** - Your Amplenote scoring algorithm  
3. **PARA Funnel Manager** - Auto-transitions between stages
4. **Strategic Opportunity Scout** - AI analysis for building blocks
5. **Communication Dispatcher** - Daily Slack/email summaries
6. **Codegen Integration** - Delegates specialized tasks

**Database Schema:**
- PostgreSQL tables for items, scores, movements, opportunities
- Proper indexing and relationships
- Initialization scripts ready

## 🚀 **Next Steps**

1. **Set up the environment:**
   ```bash
   cd n8n-starter-kit
   docker compose --profile cpu up -d
   ```

2. **Configure your databases:**
   - Create 6 Notion databases (Jots, Tasks, Projects, Areas, Resources, Archives)
   - Set up Linear workspace with proper states
   - Configure Slack app and channel

3. **Import workflows:**
   - Open n8n at `http://localhost:5678`
   - Import all JSON files from `n8n/workflows/`
   - Set up credentials and environment variables

4. **Initialize database:**
   ```bash
   docker exec -it postgres psql -U root -d n8n -f /path/to/schema.sql
   ```

## 🎯 **Key Features**

- **Amplenote-Style Scoring**: Activity, urgency, importance, deadlines, quick wins, blockers, cross-impact
- **Intelligent Funnel**: Jots → Tasks → Projects → Areas/Resources → Archives
- **AI-Powered Insights**: Uses Ollama to identify strategic opportunities
- **Codegen Integration**: Delegates complex tasks automatically
- **Daily Intelligence**: Slack reports on movements, opportunities, and fixes

This creates your "nerve center" that prioritizes execution over planning, surfacing high-ROI tasks while maintaining coherence across your entire productivity system. The Task Score algorithm ensures items that matter most naturally rise to the top, honoring your spiritual approach to productivity.

Would you like me to help you set up the Notion databases, configure the Linear workspace, or walk through importing the workflows? 🤖</content>
<parameter name="request_feedback">true

