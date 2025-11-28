#!/usr/bin/env node

/**
 * Dashboard Server for Bug Bounty MCP
 * Provides a web UI and REST API for viewing findings and statistics
 */

require('dotenv').config();
const express = require('express');
const path = require('path');
const cors = require('cors');
const { initPostgres } = require('./dist/integrations/postgres');

const app = express();
const PORT = process.env.DASHBOARD_PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Initialize PostgreSQL connection
let pool;
try {
  // Ensure password is always a string (not undefined)
  if (!process.env.POSTGRES_PASSWORD) {
    process.env.POSTGRES_PASSWORD = ''; // Set your password here or via environment variable
  }
  
  // Ensure it's a string
  if (typeof process.env.POSTGRES_PASSWORD !== 'string') {
    process.env.POSTGRES_PASSWORD = String(process.env.POSTGRES_PASSWORD);
  }
  
  // Use postgres superuser (from PostgreSQL installer) if POSTGRES_USER not set
  if (!process.env.POSTGRES_USER) {
    process.env.POSTGRES_USER = 'postgres';
  }
  
  // Set default port to 5433 (PostgreSQL 18 default)
  if (!process.env.POSTGRES_PORT) {
    process.env.POSTGRES_PORT = '5433';
  }
  
  pool = initPostgres();
  console.log('✅ PostgreSQL connected for dashboard');
} catch (error) {
  console.error('⚠️  PostgreSQL not available:', error.message);
  console.log('Dashboard will run but without database features');
  console.log('Tip: Set POSTGRES_PASSWORD environment variable if needed');
}

// API Routes

// Get statistics
app.get('/api/statistics', async (req, res) => {
  if (!pool) {
    return res.status(503).json({ error: 'Database not available' });
  }

  try {
    const client = await pool.connect();
    
    try {
      // Total findings count
      const totalRes = await client.query('SELECT COUNT(*) as count FROM findings');
      const totalFindings = parseInt(totalRes.rows[0].count) || 0;

      // Findings by severity
      const severityRes = await client.query(`
        SELECT severity, COUNT(*) as count 
        FROM findings 
        GROUP BY severity
      `);
      
      const bySeverity = {
        critical: 0,
        high: 0,
        medium: 0,
        low: 0,
        informational: 0
      };

      severityRes.rows.forEach(row => {
        const severity = (row.severity || '').toLowerCase();
        if (bySeverity.hasOwnProperty(severity)) {
          bySeverity[severity] = parseInt(row.count) || 0;
        }
      });

      // Recent activity (last 24 hours)
      const recentRes = await client.query(`
        SELECT COUNT(*) as count 
        FROM findings 
        WHERE timestamp > NOW() - INTERVAL '24 hours'
      `);
      const recentFindings = parseInt(recentRes.rows[0].count) || 0;

      res.json({
        totalFindings,
        bySeverity,
        recentFindings,
        timestamp: new Date().toISOString()
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching statistics:', error);
    res.status(500).json({ error: 'Failed to fetch statistics', details: error.message });
  }
});

// Get findings
app.get('/api/findings', async (req, res) => {
  if (!pool) {
    return res.status(503).json({ error: 'Database not available', findings: [] });
  }

  try {
    const limit = parseInt(req.query.limit) || 100;
    const target = req.query.target;
    const severity = req.query.severity;
    
    let query = 'SELECT * FROM findings WHERE 1=1';
    const params = [];
    let paramIndex = 1;

    if (target) {
      query += ` AND target ILIKE $${paramIndex}`;
      params.push(`%${target}%`);
      paramIndex++;
    }

    if (severity) {
      query += ` AND severity = $${paramIndex}`;
      params.push(severity);
      paramIndex++;
    }

    query += ` ORDER BY timestamp DESC LIMIT $${paramIndex}`;
    params.push(limit);

    const client = await pool.connect();
    try {
      const result = await client.query(query, params);
      res.json({
        findings: result.rows.map(row => ({
          id: row.id,
          target: row.target,
          type: row.type,
          severity: row.severity,
          description: row.description,
          payload: row.payload,
          response: row.response,
          score: row.score,
          timestamp: row.timestamp,
          status: row.status
        })),
        count: result.rows.length
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching findings:', error);
    res.status(500).json({ error: 'Failed to fetch findings', details: error.message, findings: [] });
  }
});

// Get test results
app.get('/api/test-results', async (req, res) => {
  if (!pool) {
    return res.status(503).json({ error: 'Database not available', results: [] });
  }

  try {
    const limit = parseInt(req.query.limit) || 50;
    const target = req.query.target;
    const testType = req.query.testType;
    const success = req.query.success;

    let query = 'SELECT * FROM test_results WHERE 1=1';
    const params = [];
    let paramIndex = 1;

    if (target) {
      query += ` AND target ILIKE $${paramIndex}`;
      params.push(`%${target}%`);
      paramIndex++;
    }

    if (testType) {
      query += ` AND test_type = $${paramIndex}`;
      params.push(testType);
      paramIndex++;
    }

    if (success !== undefined) {
      query += ` AND success = $${paramIndex}`;
      params.push(success === 'true');
      paramIndex++;
    }

    query += ` ORDER BY timestamp DESC LIMIT $${paramIndex}`;
    params.push(limit);

    const client = await pool.connect();
    try {
      const result = await client.query(query, params);
      res.json({
        results: result.rows.map(row => ({
          id: row.id,
          target: row.target,
          testType: row.test_type,
          success: row.success,
          score: row.score,
          resultData: row.result_data,
          errorMessage: row.error_message,
          timestamp: row.timestamp
        })),
        count: result.rows.length
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching test results:', error);
    res.status(500).json({ error: 'Failed to fetch test results', details: error.message, results: [] });
  }
});

// Health check
app.get('/api/health', async (req, res) => {
  const health = {
    status: 'ok',
    database: pool ? 'connected' : 'disconnected',
    timestamp: new Date().toISOString()
  };
  res.json(health);
});

// Serve dashboard
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, () => {
  console.log(`\n🎯 Bug Bounty Dashboard Server`);
  console.log(`   📊 Dashboard: http://localhost:${PORT}`);
  console.log(`   🔌 API: http://localhost:${PORT}/api`);
  console.log(`   ❤️  Health: http://localhost:${PORT}/api/health\n`);
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n\nShutting down dashboard server...');
  if (pool) {
    pool.end();
  }
  process.exit(0);
});

