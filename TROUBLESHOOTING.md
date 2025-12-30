# 🔧 Troubleshooting Guide

Complete troubleshooting for common issues.

## ❌ "npm: command not found"

### Problem
You get an error that npm is not recognized.

### Solution
1. **Install Node.js** from https://nodejs.org/
2. **Restart PowerShell** (close and reopen)
3. **Verify installation:**
   ```powershell
   node --version
   npm --version
   ```

---

## ❌ "Cannot find module 'express'"

### Problem
Server crashes when starting, says modules not found.

### Solution
1. **Install dependencies:**
   ```powershell
   cd backend
   npm install
   ```
2. **Wait for installation** to complete
3. **Start server again:**
   ```powershell
   npm run dev
   ```

---

## ❌ "EADDRINUSE: address already in use :::5000"

### Problem
Server won't start because port 5000 is already in use.

### Solutions

**Option 1: Find and stop the process**
```powershell
# See what's using port 5000
netstat -ano | findstr :5000

# Kill the process (replace PID with number from above)
taskkill /PID <PID> /F

# Then start server again
npm run dev
```

**Option 2: Use different port**
1. Edit `backend/.env`
2. Change: `PORT=5000` to `PORT=5001`
3. Start server: `npm run dev`

---

## ❌ "MongoDB connection error"

### Problem
Server starts but shows "✗ MongoDB connection error"

### Solutions

**Option 1: Install MongoDB locally**
1. Download from: https://www.mongodb.com/try/download/community
2. Install it
3. Start the MongoDB service
4. Try server again: `npm run dev`

**Option 2: Use MongoDB Atlas (Cloud)**
1. Go to: https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create a cluster
4. Get connection string
5. Edit `backend/.env`:
   ```
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/crowntech
   ```
6. Restart server

**Option 3: Start MongoDB manually**
```powershell
# If MongoDB installed locally
mongod

# Leave this running while server starts
```

---

## ❌ "Cannot POST /api/auth/login"

### Problem
API endpoint not found or returning 404.

### Solutions
1. **Verify server is running**
   - You should see "✓ Server running on http://localhost:5000" in terminal

2. **Check endpoint exists**
   - Routes should be mounted in `server.js`
   - Check `backend/routes/auth.js` exists

3. **Check URL is correct**
   - Should be: `http://localhost:5000/api/auth/login`
   - Not: `http://localhost:3000/...` or similar

4. **Restart server**
   - Stop: Ctrl+C in terminal
   - Start: `npm run dev`

---

## ❌ "Request failed with status code 401"

### Problem
Protected endpoint returns 401 Unauthorized.

### Solutions
1. **Missing token**
   - Make sure to include: `Authorization: Bearer <token>`

2. **Expired token**
   - Tokens last 24 hours
   - Login again: `POST /api/auth/login`
   - Get new token

3. **Invalid token**
   - Clear browser localStorage
   - Login again to get valid token

4. **Wrong token format**
   - Should be: `Bearer YOUR_TOKEN_HERE`
   - Not: `YOUR_TOKEN_HERE` (missing "Bearer ")

---

## ❌ "CORS error in browser"

### Problem
Frontend can't reach backend due to CORS error.

### Solutions
1. **Check server is running**
   - Backend should be on port 5000
   - Frontend on different port (8000, 8080, 3000, etc.)

2. **Verify CORS is enabled**
   - Check `server.js` line ~10:
   ```javascript
   app.use(cors());
   ```

3. **Restart both**
   - Stop backend: Ctrl+C
   - Stop frontend: Ctrl+C
   - Start backend: `npm run dev` (in `backend/`)
   - Start frontend server (in frontend/)

4. **Check browser console**
   - Open DevTools: F12
   - Look for exact error message
   - Share it with debugging

---

## ❌ "Database seeding fails"

### Problem
`npm run seed` shows errors.

### Solutions
1. **Ensure MongoDB is running**
   - Seed requires active database
   - Start MongoDB first, then seed

2. **Clear old data first**
   ```powershell
   # MongoDB shell (if installed)
   mongo
   # Then in mongo shell:
   # > use crowntech
   # > db.dropDatabase()
   # > exit
   ```

3. **Check .env file**
   - Make sure `MONGODB_URI` is correct
   - Default: `mongodb://localhost:27017/crowntech`

4. **Check errors in terminal**
   - Look for specific error message
   - Common: "Cannot connect to MongoDB"

5. **Run seed again**
   ```powershell
   npm run seed
   ```

---

## ❌ "Token already exists" (when logging in)

### Problem
Getting duplicate key error for admin email.

### Solution
Database already has admin from previous seed. Either:

**Option 1: Reseed (clears everything)**
```powershell
npm run seed
```

**Option 2: Use same credentials**
- Credentials: admin@crowntech.com / admin123
- From previous seed

**Option 3: Manual database cleanup**
```powershell
mongo
# > use crowntech
# > db.admins.deleteMany({})
# > exit

npm run seed
```

---

## ❌ "Port 5000 still in use after killing process"

### Problem
Process keeps showing as in use even after taskkill.

### Solutions
1. **Wait a few seconds** and try again
2. **Restart your computer** (nuclear option)
3. **Use different port**
   - Edit `.env`: `PORT=5001`
   - Start again: `npm run dev`

---

## ❌ "Server keeps crashing"

### Problem
Server starts then immediately exits.

### Solutions
1. **Check terminal for error message**
   - Read the full error carefully
   - Copy exact error text

2. **Common causes:**
   ```
   "Cannot find module" 
   → Run: npm install

   "MongoServerError"
   → MongoDB not running

   "Port in use"
   → Change PORT in .env

   "Syntax error"
   → Check your code edits
   ```

3. **Check for syntax errors**
   - Make sure all brackets are matched
   - Check file you recently edited

4. **Restart everything**
   ```powershell
   # Close all terminals
   # Reopen terminal
   # Start fresh
   npm run dev
   ```

---

## ❌ "Changes don't appear after editing"

### Problem
You edited a file but changes don't show up.

### Solution
Nodemon should auto-reload. If not:

1. **Save your file** (Ctrl+S)
2. **Wait 2-3 seconds** for auto-reload
3. **Check terminal** for "restarted" message

If still not working:
1. **Stop server:** Ctrl+C
2. **Start again:** `npm run dev`

---

## ❌ "Cannot get students - empty array"

### Problem
`GET /api/students` returns empty array `[]`

### Solutions
1. **Database not seeded**
   ```powershell
   npm run seed
   ```

2. **Wrong URL**
   - Check: `http://localhost:5000/api/students`

3. **Database cleared**
   - Reseed: `npm run seed`

---

## ❌ "Admin login returns 401"

### Problem
Login fails with "Invalid credentials"

### Solutions
1. **Check credentials**
   - Email: `admin@crowntech.com`
   - Password: `admin123`

2. **After reseeding**
   - Old login might not work
   - Run: `npm run seed`
   - Then try credentials again

3. **Password changed**
   - Edit `.env` to change password
   - Run: `npm run seed`

---

## ❌ "ENOENT: no such file or directory"

### Problem
Error saying a file doesn't exist.

### Solutions
1. **Check file location**
   - File might be in wrong folder
   - Verify path is correct

2. **Check .env file exists**
   ```powershell
   # In backend folder
   ls .env
   ```

3. **Recreate missing file**
   - Copy from documentation
   - Save in correct location

---

## ❌ "UnhandledPromiseRejectionWarning"

### Problem
Async error in server showing unhandled rejection.

### Solutions
1. **Check server.js error handler**
   - Should have try-catch around async operations
   - Should have error handling middleware

2. **Look at exact error**
   - Read the error message
   - Search that error in code

3. **Restart server**
   ```powershell
   npm run dev
   ```

---

## ❌ "Seed script runs but no data appears"

### Problem
`npm run seed` finishes but students/courses not in database.

### Solutions
1. **Check MongoDB is running**
   - Seed might connect but not save
   - Ensure MongoDB service is active

2. **Clear and reseed**
   ```powershell
   # Manually clear
   # Then reseed
   npm run seed
   ```

3. **Check database name**
   - Should be: `crowntech`
   - Check in `.env`: `MONGODB_URI`

4. **Look for errors in output**
   - Scroll up in terminal
   - Look for "Error" messages

---

## ❌ "Postman / Curl requests not working"

### Problem
API calls from Postman/curl returning errors.

### Solutions
1. **Check server is running**
   - Terminal should show: "✓ Server running"

2. **Check URL is correct**
   - Should be: `http://localhost:5000/api/...`
   - Check spelling of endpoint

3. **Check method is correct**
   - Login should be: `POST`
   - Get courses should be: `GET`

4. **Check headers**
   - For login: `Content-Type: application/json`
   - For protected: `Authorization: Bearer <token>`

5. **Check body**
   - For POST: Include JSON body
   - Valid JSON (no syntax errors)

---

## ❌ "Frontend can't connect to backend"

### Problem
Frontend showing "Connection error"

### Solutions
1. **Backend running?**
   - Check terminal: `npm run dev`

2. **Correct URL?**
   - Should be: `http://localhost:5000`
   - Check in `js/main.js`

3. **Different ports?**
   - Frontend: 8000/8080/3000
   - Backend: 5000
   - They MUST be different

4. **CORS issue?**
   - CORS already enabled
   - Check backend `.js` line ~10

5. **Check browser console**
   - F12 to open DevTools
   - Look for errors
   - Copy exact error message

---

## 🆘 Still Not Working?

### Diagnostic Steps
1. **Copy exact error message** from terminal or browser
2. **Check all files exist**
   ```powershell
   dir backend\models\
   dir backend\routes\
   dir backend\middleware\
   ```

3. **Verify Node/npm installed**
   ```powershell
   node --version
   npm --version
   ```

4. **Verify MongoDB running**
   ```powershell
   mongod --version
   ```

5. **Check .env file contents**
   ```powershell
   type backend\.env
   ```

6. **Completely restart**
   - Close all terminals
   - Close VS Code
   - Reopen everything
   - Try again

### Get Help
- Look for exact error message in this guide
- Check terminal output carefully
- Review `backend/README.md` documentation
- Check `ARCHITECTURE.md` for system overview

---

## ✅ Everything Working?

Great! Now:
1. Test all endpoints with Postman/curl
2. Connect frontend to API
3. Test in browser
4. Enjoy your backend! 🎉

**Remember:** Most issues are:
- MongoDB not running
- Port already in use
- Dependencies not installed
- npm install needed

Quick fix for 90% of issues:
```powershell
# Stop server (Ctrl+C)
cd backend
npm install
npm run dev
```
