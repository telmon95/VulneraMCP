# VulneraMCP

> **An AI-Powered Bug Bounty Hunting Platform** - Comprehensive Model Context Protocol (MCP) server for security testing, vulnerability research, and bug bounty hunting.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.5-blue.svg)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-20+-green.svg)](https://nodejs.org/)

VulneraMCP integrates with industry-standard security tools (ZAP, Caido, Burp Suite) and provides AI-powered automation for reconnaissance, JavaScript analysis, security testing, and vulnerability detection. All findings are automatically stored in PostgreSQL for analysis and reporting.

## 🌟 Features

### 🔍 Reconnaissance Tools
- **Subdomain Discovery**: Subfinder, Amass integration
- **Live Host Detection**: HTTPx for checking active endpoints
- **DNS Resolution**: DNS record enumeration (A, AAAA, CNAME, MX, TXT)
- **Full Recon Workflow**: Automated multi-tool reconnaissance

### 🔐 Security Testing
- **XSS Testing**: Automated cross-site scripting detection
- **SQL Injection**: SQLi vulnerability testing with sqlmap fallback
- **IDOR Detection**: Insecure Direct Object Reference testing
- **CSP Analysis**: Content Security Policy misconfiguration detection
- **Auth Bypass**: Authentication bypass attempt testing
- **CSRF Testing**: Cross-Site Request Forgery detection with advanced techniques

### 📜 JavaScript Analysis
- **JS Download**: Download and analyze JavaScript files
- **Code Beautification**: Format and beautify minified JS
- **Endpoint Extraction**: Find API endpoints and URLs in JS
- **Secret Detection**: Heuristic API key and token extraction
- **Full Analysis**: Combined download, beautify, and analyze workflow

### 🕷️ Integration
- **Spider Scans**: Automated web crawling
- **Active Scanning**: Vulnerability scanning
- **Proxy Integration**: Process requests through ZAP proxy
- **Alert Management**: Retrieve and analyze security alerts
- **Context Management**: Define scanning contexts

### 💾 Database Integration
- **PostgreSQL**: Store findings, test results, and scores
- **Redis**: Working memory and caching (optional)
- **Finding Management**: Save and retrieve bug findings
- **Test Result Storage**: Track all security tests with statistics

### 🖼️ Rendering Tools
- **Screenshots**: Capture webpage screenshots with Puppeteer
- **DOM Extraction**: Extract and analyze page structure
- **Form Extraction**: Find and analyze web forms
- **JavaScript Execution**: Execute JS in page context

### 🤖 AI Training & Pattern Matching
- **Training Data Import**: Import from HTB, PortSwigger labs
- **Pattern Matching**: Learn from successful exploits
- **Writeup Analysis**: Extract patterns from bug bounty writeups
- **CSRF Patterns**: Pre-loaded CSRF exploitation patterns

### 📊 Web Dashboard
- **Real-time Statistics**: View test results and findings
- **Finding Management**: Browse and analyze discovered vulnerabilities
- **Visual Analytics**: Track testing progress and success rates

## 🚀 Quick Start

### Prerequisites

- **Node.js** 20+ and npm
- **PostgreSQL** 18+ (or Docker)
- **Redis** (optional, for caching)
- **ZAP** (optional, for active scanning)
- **Caido** (optional, for traffic analysis)

### Installation

```bash
# Clone the repository
git clone https://github.com/telmonmaluleka/VulneraMCP.git
cd VulneraMCP

# Install dependencies
npm install

# Build the project
npm run build
```

### Configuration

1. **Copy environment template:**
   ```bash
   cp mcp.json.example mcp.json
   ```

2. **Configure your environment variables:**
   - Set up PostgreSQL connection details
   - Configure Caido API token (if using)
   - Set ZAP API URL (default: http://localhost:8081)

3. **Initialize the database:**
   ```bash
   node init-db.js
   ```

### Running the Server

```bash
# Start the MCP server
npm start

# Start the dashboard (in another terminal)
npm run dashboard

# Access dashboard at http://localhost:3000
```

### Docker Setup

```bash
# Start all services with Docker Compose
docker-compose up -d

# Or use the startup script
./start-services.sh
```

## 📖 Usage

### Via MCP Client (Cursor, Claude Desktop, etc.)

The server provides MCP tools that can be called through any MCP-compatible client:

**Reconnaissance:**
```
recon.subfinder domain: example.com
recon.httpx input: example.com,subdomain.example.com
recon.full domain: example.com
```

**Security Testing:**
```
security.test_xss url: https://example.com/search?q=<script>
security.test_sqli url: https://example.com/user?id=1
security.test_csrf url: https://example.com/profile/update
```

**JavaScript Analysis:**
```
js.analyze url: https://example.com/static/app.js
js.extract_secrets source: <javascript_code>
```

**ZAP Integration:**
```
zap.start_spider url: https://example.com
zap.start_active_scan url: https://example.com
zap.get_alerts baseURL: https://example.com
```

**Caido Integration:**
```
caido.query httpql: "req.host.cont:\"example.com\" AND req.path.cont:\"api\""
caido.agent_discover_endpoints host: example.com
```

### Rate Limiting & Best Practices

When testing bug bounty programs, always respect rate limits:

```javascript
// Example: 2 requests/second limit
const rateLimiter = require('./hunting/rate-limiter');
const limiter = rateLimiter(2); // 2 req/sec

await limiter();
// Make your request
```

## 🏗️ Project Structure

```
VulneraMCP/
├── src/
│   ├── integrations/    # External service integrations
│   │   ├── zap.ts       # OWASP ZAP integration
│   │   ├── caido.ts     # Caido integration
│   │   ├── postgres.ts  # PostgreSQL database
│   │   └── redis.ts     # Redis caching
│   ├── tools/           # MCP tools (recon, security, etc.)
│   ├── mcp/             # MCP server implementation
│   └── index.ts         # Main entry point
├── public/              # Dashboard frontend
├── hunting/             # Bug bounty hunting scripts
├── dist/                # Compiled TypeScript output
└── dashboard-server.js  # Dashboard API server
```

## 🔧 Configuration

### MCP Server Configuration (`mcp.json`)

```json
{
  "name": "vulneramcp",
  "command": "node",
  "args": ["dist/index.js"],
  "env": {
    "POSTGRES_HOST": "localhost",
    "POSTGRES_PORT": "5433",
    "POSTGRES_USER": "postgres",
    "POSTGRES_DB": "bugbounty"
  }
}
```

### Environment Variables

```bash
# PostgreSQL
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_DB=bugbounty

# ZAP
ZAP_API_URL=http://localhost:8081

# Caido
CAIDO_API_TOKEN=your_token

# Redis (optional)
REDIS_HOST=localhost
REDIS_PORT=6379
```

## 📊 Dashboard

The web dashboard provides:
- **Statistics**: Test results, success rates, vulnerability distribution
- **Findings**: Detailed view of discovered vulnerabilities
- **Search & Filter**: Find specific findings by target, type, severity

Access at: `http://localhost:3000`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool is for authorized security testing only. Always:
- Get proper authorization before testing
- Respect rate limits and terms of service
- Follow responsible disclosure practices
- Never use on systems you don't own or have explicit permission to test

## 🙏 Acknowledgments

- ZAP for vulnerability scanning
- The bug bounty community for inspiration and feedback

## 📚 Documentation

- [Quick Start Guide](QUICK_START.md)
- [ZAP Integration](ZAP_INTEGRATION.md)
- [Dashboard Guide](DASHBOARD_README.md)
- [Training Data](TRAINING.md)

## 🐛 Issues

Found a bug? Have a feature request? Please open an issue on [GitHub](https://github.com/telmonmaluleka/VulneraMCP/issues).

## 📧 Contact

- GitHub: [@telmonmaluleka](https://github.com/telmonmaluleka)
- Issues: [GitHub Issues](https://github.com/telmonmaluleka/VulneraMCP/issues)

