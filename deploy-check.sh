#!/bin/bash
# Deployment automation script for CrownTech Academy
# Run this after pushing to GitHub to verify Render + Vercel deployments

echo "=== CrownTech Academy Deployment Check ==="
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
  echo "❌ Git not initialized. Run: git init && git add . && git commit -m 'initial'"
  exit 1
fi

echo "✓ Git repository found"
echo ""

# Prompt for GitHub URL
read -p "Enter your GitHub repo URL (e.g., https://github.com/user/repo): " GITHUB_URL
read -p "Enter Render backend URL (e.g., https://app-name.onrender.com): " RENDER_URL
read -p "Enter Vercel frontend URL (e.g., https://app-name.vercel.app): " VERCEL_URL

echo ""
echo "Testing endpoints..."
echo ""

# Test backend health
echo "Testing backend health check..."
HEALTH_RESPONSE=$(curl -s "$RENDER_URL/api/health" -w "\n%{http_code}")
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "200" ]; then
  echo "✓ Backend is responding"
else
  echo "⚠ Backend returned HTTP $HTTP_CODE (may still be deploying)"
fi

echo ""
echo "Testing frontend..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL")

if [ "$FRONTEND_RESPONSE" = "200" ]; then
  echo "✓ Frontend is accessible"
else
  echo "⚠ Frontend returned HTTP $FRONTEND_RESPONSE"
fi

echo ""
echo "=== Deployment Status ==="
echo "GitHub:  $GITHUB_URL"
echo "Backend: $RENDER_URL"
echo "Frontend: $VERCEL_URL"
echo ""
echo "Next steps:"
echo "1. Visit your frontend URL and test features"
echo "2. Check Render logs if backend has issues"
echo "3. Update frontend API URLs to point to Render backend"
echo "4. Configure domain DNS (optional)"
