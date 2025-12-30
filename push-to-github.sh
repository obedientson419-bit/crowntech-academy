#!/bin/bash
# Quick push to GitHub script
# Usage: ./push-to-github.sh "Your commit message"

COMMIT_MSG="${1:-Update: CrownTech Academy}"

echo "Committing changes..."
git add .
git commit -m "$COMMIT_MSG"

echo "Pushing to GitHub..."
git push -u origin main

echo "✓ Pushed to GitHub!"
echo "Monitor Render and Vercel dashboards for auto-deployment."
