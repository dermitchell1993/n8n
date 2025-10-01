-- Initialize PARA Productivity System Database
-- Run this after creating the schema to set up initial data

-- Insert sample data for testing (optional - remove in production)
-- This creates example PARA databases in Notion that the workflows expect

-- Environment variables needed in .env file:
-- NOTION_JOTS_DATABASE_ID=your_jots_database_id
-- NOTION_TASKS_DATABASE_ID=your_tasks_database_id
-- NOTION_PROJECTS_DATABASE_ID=your_projects_database_id
-- NOTION_AREAS_DATABASE_ID=your_areas_database_id
-- NOTION_RESOURCES_DATABASE_ID=your_resources_database_id
-- NOTION_ARCHIVES_DATABASE_ID=your_archives_database_id
-- LINEAR_TEAM_ID=your_linear_team_id
-- CODEGEN_API_BASE_URL=https://api.codegen.com
-- CODEGEN_API_KEY=your_codegen_api_key
-- NOTIFICATION_EMAIL=your@email.com

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_para_items_created_at ON para_items(created_at);
CREATE INDEX IF NOT EXISTS idx_para_items_updated_at ON para_items(updated_at);
CREATE INDEX IF NOT EXISTS idx_task_scores_created_at ON task_scores(created_at);
CREATE INDEX IF NOT EXISTS idx_funnel_movements_moved_at ON funnel_movements(moved_at);
CREATE INDEX IF NOT EXISTS idx_strategic_opportunities_created_at ON strategic_opportunities(identified_at);
CREATE INDEX IF NOT EXISTS idx_coherence_issues_created_at ON coherence_issues(detected_at);

-- Sample data for testing (uncomment to use)
-- INSERT INTO para_items (external_id, source, title, content, stage, urgency, importance, created_at) VALUES
-- ('sample_jot_1', 'notion', 'Sample Jot', 'This is a sample jot that should become a task', 'jots', 'medium', 'medium', NOW() - INTERVAL '2 days'),
-- ('sample_task_1', 'linear', 'Sample Task', 'This is a sample task that could become a project', 'tasks', 'high', 'high', NOW() - INTERVAL '1 day'),
-- ('sample_project_1', 'notion', 'Sample Project', 'This is a sample project in the areas stage', 'areas', 'medium', 'high', NOW() - INTERVAL '5 days');

-- Sample task scores (uncomment to use)
-- INSERT INTO task_scores (item_id, score, color_code, score_breakdown, created_at)
-- SELECT id, 8, 'gold', '{"activity": 4, "urgency": 0, "importance": 3, "deadline": 0, "quick_win": 0, "blocker": 0, "cross_impact": 1}', NOW()
-- FROM para_items WHERE title LIKE 'Sample%';

-- Verify installation
DO $$
BEGIN
    RAISE NOTICE 'PARA Productivity System database initialized successfully!';
    RAISE NOTICE 'Tables created: para_items, task_scores, funnel_movements, strategic_opportunities, cross_references, coherence_issues';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Set up your environment variables in .env';
    RAISE NOTICE '2. Import the n8n workflows from the workflows/ directory';
    RAISE NOTICE '3. Configure your Notion databases and Linear workspace';
    RAISE NOTICE '4. Start the n8n workflows and begin your PARA automation!';
END $$;

