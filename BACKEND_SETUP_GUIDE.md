# CrownTech Academy - Backend Setup Guide

## Overview

Your backend is a complete Node.js/Express API server with MongoDB database integration. It handles:
- User authentication (JWT-based)
- Student enrollment management
- Course catalog
- Contact form submissions
- Admin analytics & statistics

## 🎯 5-Minute Quick Start

### Step 1: Navigate to backend folder
```powershell
cd c:\Users\DELL\Pictures\my web\backend
```

### Step 2: Install dependencies
```powershell
npm install
```

### Step 3: Ensure MongoDB is running
MongoDB should be running on your system. If not:
- Install MongoDB Community Edition from: https://www.mongodb.com/try/download/community
- Or use MongoDB Atlas (cloud): https://www.mongodb.com/cloud/atlas

### Step 4: Start the server
```powershell
npm run dev
```

You should see:
```
✓ MongoDB connected
✓ Server running on http://localhost:5000
```

### Step 5: Seed sample data (optional but recommended)
Open a NEW PowerShell window and run:
```powershell
cd c:\Users\DELL\Pictures\my web\backend
npm run seed
```

You should see:
```
✓ Admin created
✓ 6 courses created
✓ 12 students created
✓ Database seeded successfully!
```

## 📝 Default Admin Credentials

After seeding:
- **Email:** admin@crowntech.com
- **Password:** admin123

## 🧪 Test the API

### 1. Open Postman, Insomnia, or VS Code REST Client

### 2. Test Login
```http
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "admin@crowntech.com",
  "password": "admin123"
}
```

Expected Response:
```json
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "admin": {
    "id": "...",
    "name": "Admin User",
    "email": "admin@crowntech.com",
    "role": "super_admin"
  }
}
```

### 3. Test Getting Courses
```http
GET http://localhost:5000/api/courses
```

This returns all available courses without authentication.

### 4. Test Protected Route (Get Students)
Copy the `token` from the login response, then:

```http
GET http://localhost:5000/api/students
Authorization: Bearer <paste_token_here>
```

## 🔧 Environment Variables

Edit `backend/.env`:

```env
# Database
MONGODB_URI=mongodb://localhost:27017/crowntech

# Server
PORT=5000
NODE_ENV=development

# Security
JWT_SECRET=your-secret-key-change-this

# Default Admin Credentials
ADMIN_EMAIL=admin@crowntech.com
ADMIN_PASSWORD=admin123

# Email (optional)
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
```

## 📊 API Endpoints Summary

| Method | Endpoint | Auth? | Purpose |
|--------|----------|-------|---------|
| POST | `/api/auth/login` | No | Admin login |
| GET | `/api/auth/profile` | ✓ | Get admin profile |
| GET | `/api/students` | ✓ | List all students |
| POST | `/api/students` | No | Register new student |
| GET | `/api/courses` | No | List all courses |
| GET | `/api/admin/stats` | ✓ | Dashboard stats |
| GET | `/api/admin/analytics` | ✓ | Analytics data |
| POST | `/api/contact` | No | Submit contact form |

**✓ = Requires Authentication Token**

## 🔌 Connecting Frontend to Backend

Update `js/main.js` to call the backend API instead of hardcoded data:

### Example: Login
```javascript
async function handleAdminLogin(event) {
  event.preventDefault();
  
  const email = document.getElementById('adminEmail').value;
  const password = document.getElementById('adminPassword').value;
  
  try {
    const response = await fetch('http://localhost:5000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });
    
    const data = await response.json();
    
    if (response.ok) {
      localStorage.setItem('authToken', data.token);
      showToast('Login successful!', 'success');
      // Show dashboard
    } else {
      showToast(data.error, 'error');
    }
  } catch (error) {
    showToast('Login failed', 'error');
  }
}
```

### Example: Get Students
```javascript
async function loadStudents() {
  const token = localStorage.getItem('authToken');
  
  try {
    const response = await fetch('http://localhost:5000/api/students', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    const students = await response.json();
    // Display students in table
  } catch (error) {
    console.error('Failed to load students', error);
  }
}
```

## 🐛 Common Issues & Solutions

### ❌ "MongoDB connection error"
**Solution:** 
- Check if MongoDB is running: `Get-Process mongod` (Windows)
- Or start it: Download and install MongoDB Community

### ❌ "EADDRINUSE: address already in use :::5000"
**Solution:**
- Port 5000 is already in use. Change in `.env`: `PORT=5001`
- Or kill the process: `Get-Process -Name node | Stop-Process`

### ❌ "Cannot find module 'mongoose'"
**Solution:**
```powershell
npm install
```

### ❌ "Token invalid/expired"
**Solution:**
- Delete `authToken` from browser localStorage
- Login again to get a new token

### ❌ CORS errors in browser console
**Solution:**
- Ensure backend is running on port 5000
- Frontend should be on a different port (8000, 8080, etc.)
- CORS is already enabled in `server.js`

## 📂 File Structure Reference

```
backend/
├── server.js          ← Main server file (don't edit usually)
├── seed.js            ← Run with: npm run seed
├── package.json       ← Dependencies & scripts
├── .env              ← Environment variables (edit these)
├── models/
│   ├── Admin.js      ← Admin user schema
│   ├── Student.js    ← Student schema
│   ├── Course.js     ← Course schema
│   └── Contact.js    ← Contact form schema
├── routes/
│   ├── auth.js       ← Login & authentication
│   ├── students.js   ← Student CRUD
│   ├── courses.js    ← Course CRUD
│   ├── contact.js    ← Contact form
│   └── admin.js      ← Analytics & stats
└── middleware/
    └── auth.js       ← JWT verification
```

## 🚀 Next Steps

1. **Start server:** `npm run dev` (in `backend/` folder)
2. **Seed data:** `npm run seed` (in another terminal)
3. **Test API:** Use Postman/Insomnia or curl
4. **Connect frontend:** Update `js/main.js` with API calls
5. **Test in browser:** Open `index.html` and test admin login

## 📞 Need Help?

Check `backend/README.md` for detailed API documentation.

All endpoints are documented with example requests and responses.

---

**Happy coding! 🎉**
