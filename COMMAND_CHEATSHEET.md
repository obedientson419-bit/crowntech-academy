# ⚡ Command Cheatsheet

Quick reference for all commands you'll need.

## 🚀 Startup Commands

### First Time Setup
```powershell
# 1. Navigate to backend
cd c:\Users\DELL\Pictures\my web\backend

# 2. Install all dependencies
npm install

# 3. Start the server
npm run dev

# 4. In NEW PowerShell window, seed data
npm run seed
```

### Daily Startup (after initial setup)
```powershell
cd backend
npm run dev
```

## 🔌 API Testing

### Test Login (Copy & Paste)
```powershell
# Login to get token
curl -X POST http://localhost:5000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"email\":\"admin@crowntech.com\",\"password\":\"admin123\"}'
```

### Get All Courses (no auth needed)
```powershell
curl http://localhost:5000/api/courses
```

### Get Students (protected - need token)
```powershell
# First login to get token, then use it here:
curl http://localhost:5000/api/students `
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Submit Contact Form
```powershell
curl -X POST http://localhost:5000/api/contact `
  -H "Content-Type: application/json" `
  -d '{\"name\":\"John\",\"email\":\"john@example.com\",\"message\":\"Hello\"}'
```

## 🗄️ Database Commands

### Seed Database
```powershell
npm run seed
```

### Check MongoDB Connection
```powershell
# Test if MongoDB is running
mongo --version

# Start MongoDB (if installed locally)
mongod

# Or use MongoDB Atlas (cloud) - just update MONGODB_URI in .env
```

### Clear All Data
```powershell
# Use MongoDB shell
# Or delete and reseed:
npm run seed
```

## 📦 Dependency Management

### Install Dependencies
```powershell
npm install

# Or update to latest
npm update
```

### Add New Package
```powershell
npm install package-name

# Save as dev dependency
npm install --save-dev package-name
```

### Check Installed Packages
```powershell
npm list

# Only top-level
npm list --depth=0
```

## 🐛 Debugging

### View Server Logs
```powershell
# Server logs appear in the terminal where npm run dev is running
# Look for:
# ✓ MongoDB connected
# ✓ Server running on http://localhost:5000
```

### Check if Port is in Use
```powershell
# Windows - check what's using port 5000
netstat -ano | findstr :5000

# Kill process using port (if needed)
taskkill /PID <PID> /F
```

### Restart Server
```powershell
# Stop running server (Ctrl + C in terminal)
# Then restart
npm run dev
```

### Clear npm Cache
```powershell
npm cache clean --force
```

## 📝 File Editing

### Edit Environment Variables
```powershell
# Edit .env file
notepad backend\.env

# Or use VS Code
code backend\.env
```

### View File Contents
```powershell
# Show file contents
Get-Content backend\server.js

# Show with line numbers
Get-Content backend\server.js -ReadCount 0 | Select-Object -Index (0..20)
```

### Search in Files
```powershell
# Find text in files
Select-String -Path "backend\routes\*" -Pattern "POST"

# Search all JavaScript files
Select-String -Path "backend\**\*.js" -Pattern "function"
```

## 🔐 Security

### Generate New JWT Secret
```powershell
# Generate random string for JWT_SECRET in .env
[System.Guid]::NewGuid().ToString()

# Or use this stronger method
$random = -join ((33..126) | Get-Random -Count 64 | %{[char]$_})
Write-Host $random
```

### Change Admin Password
Edit `.env` file:
```env
ADMIN_PASSWORD=your_new_password
```

Then reseed:
```powershell
npm run seed
```

## 🚢 Deployment Commands

### Build for Production
```powershell
# Set environment
$env:NODE_ENV = "production"

# Start server
npm start
```

### Create Production Build
```powershell
# Nothing special needed - Node.js just runs the code
# But you can create a .env.production file with production settings
```

## 🧹 Cleanup Commands

### Remove node_modules (free up space)
```powershell
cd backend
Remove-Item -Recurse -Force node_modules

# Reinstall when needed
npm install
```

### Clear All Logs
```powershell
# Logs are in terminal output, nothing to clear
# But if you save logs to file, delete them:
Remove-Item logs\*.log
```

## 📊 Useful File Navigation

### Open Files in VS Code
```powershell
# Open entire backend folder
code c:\Users\DELL\Pictures\my web\backend

# Open specific file
code c:\Users\DELL\Pictures\my web\backend\server.js

# Open from current directory
code .
```

### Navigate Directories
```powershell
# Go to backend
cd c:\Users\DELL\Pictures\my web\backend

# Go to root
cd ..

# Go to parent of parent
cd ..\..

# Go home
cd ~

# List files
ls
# or
Get-ChildItem

# List with details
dir
```

## 🔍 Useful Checks

### Check Node Version
```powershell
node --version
# or
node -v
```

### Check npm Version
```powershell
npm --version
# or
npm -v
```

### Check MongoDB Status
```powershell
# If installed locally
Get-Process mongod

# Or try connecting
mongo --eval "db.version()"
```

### Check if Port is Running
```powershell
# Check if something is listening on port 5000
netstat -an | findstr :5000

# More detailed check
Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
```

## 📚 Documentation Files Quick Access

```powershell
# Open quick reference
code c:\Users\DELL\Pictures\my web\QUICK_REFERENCE.md

# Open setup guide
code c:\Users\DELL\Pictures\my web\BACKEND_SETUP_GUIDE.md

# Open integration guide
code c:\Users\DELL\Pictures\my web\FRONTEND_BACKEND_INTEGRATION.md

# Open API docs
code c:\Users\DELL\Pictures\my web\backend\README.md

# Open architecture diagram
code c:\Users\DELL\Pictures\my web\ARCHITECTURE.md
```

## 🎯 Common Workflow

```powershell
# 1. Start work session
cd c:\Users\DELL\Pictures\my web\backend
npm run dev

# 2. In new PowerShell, seed if needed
npm run seed

# 3. Test API
curl http://localhost:5000/api/health

# 4. Make code changes
# (edit files while server is running)

# 5. Server auto-reloads (via nodemon)

# 6. Test changes
curl http://localhost:5000/api/courses

# 7. When done, stop server
# Ctrl + C in the npm run dev terminal

# 8. Commit to git
git add .
git commit -m "Update backend routes"
```

## 💾 Git Commands (optional)

```powershell
# Initialize repo (one time)
git init

# Check status
git status

# Stage changes
git add .

# Commit changes
git commit -m "Your message here"

# View history
git log

# See what changed
git diff
```

## 🎓 Learning Resources

```powershell
# View package.json to understand dependencies
code package.json

# Check npm scripts
Get-Content package.json | Select-String "scripts" -A 10

# View API routes
code routes\

# Check database models
code models\
```

## ⚠️ Emergency Commands

### Kill All Node Processes
```powershell
Get-Process -Name node | Stop-Process -Force
```

### Reset Everything
```powershell
# Remove node_modules and reinstall
Remove-Item -Recurse -Force node_modules
npm install

# Reseed database
npm run seed
```

### Check Disk Space
```powershell
Get-PSDrive C | Select-Object Used, Free
```

---

**Pro Tip:** Bookmark the quick reference for faster development!

**Most Used Commands:**
```
npm run dev          # Start server
npm run seed         # Load sample data
npm install          # Install dependencies
curl http://localhost:5000/api/health   # Test server
```
