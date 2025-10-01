-- PARA Productivity System Database Schema
-- Designed for Amplenote-style Task Score philosophy

-- Main table for all PARA items across stages
CREATE TABLE IF NOT EXISTS para_items (
    id SERIAL PRIMARY KEY,
    external_id VARCHAR(255), -- Notion page ID or Linear issue ID
    source VARCHAR(50) NOT NULL, -- 'notion' or 'linear'
    title TEXT NOT NULL,
    content TEXT,
    stage VARCHAR(50) NOT NULL, -- 'jots', 'tasks', 'projects', 'areas', 'resources', 'archives'
    urgency VARCHAR(20), -- 'low', 'medium', 'urgent'
    importance VARCHAR(20), -- 'low', 'medium', 'high'
    due_date TIMESTAMP,
    estimated_duration INTEGER, -- minutes
    blocks_others BOOLEAN DEFAULT FALSE,
    affected_areas TEXT[], -- PostgreSQL array of affected areas
    tags TEXT[], -- PostgreSQL array of tags
    last_opened TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_score_update TIMESTAMP,
    notion_database_id VARCHAR(255),
    linear_project_id VARCHAR(255),
    metadata JSONB -- Flexible storage for additional properties
);

-- Task scores with history
CREATE TABLE IF NOT EXISTS task_scores (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES para_items(id) ON DELETE CASCADE,
    score INTEGER NOT NULL CHECK (score >= 0 AND score <= 20),
    color_code VARCHAR(20) NOT NULL, -- 'red', 'gold', 'normal'
    score_breakdown JSONB, -- Detailed breakdown of score components
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(item_id) -- Only one current score per item
);

-- Audit trail of funnel movements
CREATE TABLE IF NOT EXISTS funnel_movements (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES para_items(id) ON DELETE CASCADE,
    from_stage VARCHAR(50),
    to_stage VARCHAR(50) NOT NULL,
    movement_reason TEXT,
    moved_by VARCHAR(50), -- 'auto' or 'manual'
    moved_at TIMESTAMP DEFAULT NOW()
);

-- Strategic opportunities identified by AI analysis
CREATE TABLE IF NOT EXISTS strategic_opportunities (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES para_items(id) ON DELETE CASCADE,
    opportunity_type VARCHAR(100), -- 'building_block', 'high_impact', 'near_completion', 'needs_triage'
    description TEXT,
    confidence_score DECIMAL(3,2), -- 0.00 to 1.00
    affected_areas TEXT[],
    potential_impact TEXT,
    identified_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'resolved', 'dismissed'
    resolved_at TIMESTAMP
);

-- Cross-references between items
CREATE TABLE IF NOT EXISTS cross_references (
    id SERIAL PRIMARY KEY,
    source_item_id INTEGER REFERENCES para_items(id) ON DELETE CASCADE,
    target_item_id INTEGER REFERENCES para_items(id) ON DELETE CASCADE,
    relationship_type VARCHAR(50), -- 'blocks', 'depends_on', 'related_to', 'parent_of'
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(source_item_id, target_item_id, relationship_type)
);

-- Database coherence issues and fixes
CREATE TABLE IF NOT EXISTS coherence_issues (
    id SERIAL PRIMARY KEY,
    issue_type VARCHAR(100), -- 'broken_link', 'orphaned_page', 'inconsistent_tagging', etc.
    description TEXT,
    affected_items INTEGER[], -- Array of item IDs
    severity VARCHAR(20), -- 'low', 'medium', 'high', 'critical'
    status VARCHAR(20) DEFAULT 'open', -- 'open', 'fixed', 'ignored'
    detected_at TIMESTAMP DEFAULT NOW(),
    fixed_at TIMESTAMP,
    fix_description TEXT
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_para_items_stage ON para_items(stage);
CREATE INDEX IF NOT EXISTS idx_para_items_external_id ON para_items(external_id);
CREATE INDEX IF NOT EXISTS idx_para_items_source ON para_items(source);
CREATE INDEX IF NOT EXISTS idx_task_scores_item_id ON task_scores(item_id);
CREATE INDEX IF NOT EXISTS idx_task_scores_score ON task_scores(score);
CREATE INDEX IF NOT EXISTS idx_funnel_movements_item_id ON funnel_movements(item_id);
CREATE INDEX IF NOT EXISTS idx_strategic_opportunities_item_id ON strategic_opportunities(item_id);
CREATE INDEX IF NOT EXISTS idx_strategic_opportunities_type ON strategic_opportunities(opportunity_type);
CREATE INDEX IF NOT EXISTS idx_cross_references_source ON cross_references(source_item_id);
CREATE INDEX IF NOT EXISTS idx_cross_references_target ON cross_references(target_item_id);
CREATE INDEX IF NOT EXISTS idx_coherence_issues_status ON coherence_issues(status);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_para_items_updated_at
    BEFORE UPDATE ON para_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

