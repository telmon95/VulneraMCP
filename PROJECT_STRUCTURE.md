# Project Structure

This document outlines the organization of the AI Bug Bounty Hunter MCP Server project.

## Core Project Files

### Source Code
- `src/` - TypeScript source code
  - `helpers/` - Helper utilities
  - `integrations/` - Integration modules (Caido, PostgreSQL, Redis, ZAP)
  - `mcp/` - MCP server implementation
  - `tools/` - MCP tools (recon, security testing, JS analysis, etc.)
  - `types/` - TypeScript type definitions
  - `utils/` - Utility functions

### Build Output
- `dist/` - Compiled JavaScript output (generated from `src/`)

### Configuration
- `package.json` - Node.js dependencies and scripts
- `package-lock.json` - Dependency lock file
- `tsconfig.json` - TypeScript configuration
- `mcp.json` - MCP server configuration
- `mcp.json.example` - Example MCP configuration
- `docker-compose.yml` - Docker Compose configuration
- `Dockerfile` - Docker image definition
- `.env.example` - Environment variables example
- `.gitignore` - Git ignore rules

### Database & Setup
- `init-db.js` - Database initialization script
- `init-db-direct.js` - Direct database initialization
- `setup-postgres.sh` - PostgreSQL setup script
- `scripts/` - Utility scripts

### Documentation
- `README.md` - Main project documentation
- `QUICKSTART.md` - Quick start guide
- `QUICK_SETUP.md` - Setup instructions
- `MCP_SETUP.md` - MCP server setup guide
- `MCP_CONFIG_README.md` - MCP configuration guide
- `ZAP_INTEGRATION.md` - ZAP integration documentation
- `TRAINING.md` - Training data documentation
- `TRAINING_QUICKSTART.md` - Training quick start
- `TRAINING_DATA_SOURCES.md` - Training data sources
- `TRAINING_EXAMPLES.md` - Training examples
### Extensions
- `burp-extension/` - Burp Suite extension code

### Data
- `training_data_examples.json` - Example training data

### Legal
- `LICENSE` - MIT License

## Archive Folder

Non-core project files are stored in the `archive/` folder:

- `archive/blog-files/` - Blog post drafts and related files
- `archive/screenshot-utilities/` - Screenshot generation scripts
- `archive/test-scripts/` - Experimental and test scripts
- `archive/misc/` - Miscellaneous files

See `archive/README.md` for more details.

## Getting Started

1. Install dependencies: `npm install`
2. Configure environment: Copy `.env.example` to `.env` and fill in values
3. Set up database: Run `./setup-postgres.sh` or `node init-db.js`
4. Build project: `npm run build`
5. Start server: `npm start`

For detailed setup instructions, see `QUICKSTART.md` and `MCP_SETUP.md`.



