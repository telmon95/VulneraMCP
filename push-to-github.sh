#!/bin/bash

# Script to push VulneraMCP to GitHub
# Run this after creating the repository on GitHub

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}🚀 Pushing VulneraMCP to GitHub${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Check if remote already exists
if git remote | grep -q origin; then
    echo -e "${YELLOW}⚠️  Remote 'origin' already exists${NC}"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin https://github.com/telmonmaluleka/VulneraMCP.git
    else
        echo -e "${RED}❌ Exiting. Please update remote manually.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} Adding remote origin..."
    git remote add origin https://github.com/telmonmaluleka/VulneraMCP.git
fi

# Verify remote
echo -e "${GREEN}✓${NC} Remote URL:"
git remote -v | grep origin

echo ""
echo -e "${YELLOW}⚠️  Make sure you've created the repository on GitHub:${NC}"
echo "   https://github.com/new"
echo "   Repository name: VulneraMCP"
echo "   Visibility: Public"
echo ""
read -p "Have you created the repository? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Please create the repository first: https://github.com/new${NC}"
    exit 1
fi

# Ensure we're on main branch
git branch -M main 2>/dev/null || true

# Push to GitHub
echo ""
echo -e "${GREEN}✓${NC} Pushing to GitHub..."
if git push -u origin main; then
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Successfully pushed to GitHub!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e "🌐 Repository URL: ${BLUE}https://github.com/telmonmaluleka/VulneraMCP${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Visit your repository: https://github.com/telmonmaluleka/VulneraMCP"
    echo "  2. Add topics/tags for discoverability"
    echo "  3. Create initial release (optional):"
    echo "     git tag -a v1.0.0 -m 'Initial release' && git push origin v1.0.0"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Push failed!${NC}"
    echo ""
    echo "Possible reasons:"
    echo "  - Repository doesn't exist yet (create at https://github.com/new)"
    echo "  - Authentication issue (check GitHub credentials)"
    echo "  - Network connectivity issue"
    echo ""
    exit 1
fi

