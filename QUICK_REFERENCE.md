# 🚀 Backend Quick Reference Card

## Folder Structure
```
c:\Users\DELL\Pictures\my web\
├── index.html                    ← Frontend
├── css/style.css
├── js/main.js
├── assets/images/
└── backend/                      ← Backend (START HERE!)
    ├── package.json
    ├── server.js
    ├── seed.js
    ├── .env
    ├── models/
    ├── routes/
    └── middleware/
```

## ⚡ Quick Commands

```powershell
# 1. Open PowerShell in backend folder
cd c:\Users\DELL\Pictures\my web\backend

# 2. Install dependencies (first time only)
npm install

# 3. Start backend server
npm run dev

# 4. Seed database (in NEW PowerShell window)
npm run seed
```

## 🔐 Default Login
- Email: `admin@crowntech.com`
- Password: `admin123`

## 🔗 API Base URL
```
http://localhost:5000
```

## 📡 Key Endpoints

| Method | Endpoint | Auth? | Example |
|--------|----------|-------|---------|
| POST | `/api/auth/login` | ❌ | Login admin |
| GET | `/api/students` | ✅ | List students |
| POST | `/api/students` | ❌ | Register student |
| GET | `/api/courses` | ❌ | List courses |
| GET | `/api/admin/stats` | ✅ | Dashboard stats |
| POST | `/api/contact` | ❌ | Submit contact form |

**✅ = Need Bearer Token**

## 🧪 Test Login (Copy & Paste)

### Using curl (PowerShell):
```powershell
curl -X POST http://localhost:5000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"email\":\"admin@crowntech.com\",\"password\":\"admin123\"}'
```

### Using PowerShell invoke-webrequest:
```powershell
$body = @{
    email = "admin@crowntech.com"
    password = "admin123"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:5000/api/auth/login `
  -Method POST `
  -ContentType "application/json" `
  -Body $body
```

## ✅ Status Checklist

- [ ] MongoDB installed & running
- [ ] `npm install` completed
- [ ] `.env` file created
- [ ] `npm run dev` showing "✓ Server running"
- [ ] `npm run seed` shows success
- [ ] Can login with admin@crowntech.com / admin123
- [ ] Frontend connecting to API

## 🔧 Edit These Files

1. **`backend/.env`** - Change database URL, port, admin password
2. **`backend/models/*.js`** - Modify database schemas
3. **`backend/routes/*.js`** - Add/edit API endpoints
4. **`js/main.js`** - Connect frontend to API calls

## 📊 Database

Default database name: `crowntech`

Collections after seed:
- `admins` (1 document)
- `students` (12 documents)
- `courses` (6 documents)
- `contacts` (empty)

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| "port 5000 in use" | Change PORT in .env or kill process |
| "MongoDB connection error" | Ensure mongod is running |
| "Cannot find module" | Run `npm install` |
| "CORS error" | Ensure backend running & CORS enabled |
| "Token invalid" | Delete localStorage authToken, login again |

## 📝 File Locations

| File | Purpose |
|------|---------|
| `backend/server.js` | Main Express server |
| `backend/seed.js` | Populate test data |
| `backend/models/` | Database schemas |
| `backend/routes/` | API endpoints |
| `backend/middleware/auth.js` | JWT verification |

## 🔄 Development Flow

1. **Start Backend:**
   ```powershell
   cd backend
   npm run dev
   ```

2. **Seed Data (new terminal):**
   ```powershell
   cd backend
   npm run seed
   ```

3. **Test API (Postman/curl):**
   - POST login → get token
   - GET courses → list all
   - GET students (with token) → list students

4. **Connect Frontend:**
   - Update `js/main.js` with API calls
   - Use token from login for protected routes

5. **Monitor Server:**
   - Watch terminal for logs
   - Errors appear in backend terminal

## 🎯 Integration Checklist

After backend is running:

- [ ] Update `handleAdminLogin()` to call `/api/auth/login`
- [ ] Store token from login response
- [ ] Add token to Authorization header for protected routes
- [ ] Update `loadStudents()` to fetch from `/api/students`
- [ ] Update `loadCourses()` to fetch from `/api/courses`
- [ ] Update contact form to POST to `/api/contact`
- [ ] Test admin login in browser
- [ ] Verify data loading from database

## 📞 Documentation Files

- **`backend/README.md`** - Full API docs
- **`BACKEND_SETUP_GUIDE.md`** - Installation steps
- **`BACKEND_STRUCTURE.md`** - File structure explained
- **`FRONTEND_BACKEND_INTEGRATION.md`** - How to connect frontend

## 💡 Pro Tips

1. Use `npm run dev` for auto-reload during development
2. Keep browser console open to see API errors
3. Test API with curl/Postman before frontend integration
4. Check `.env` file matches your MongoDB URI
5. Backend logs show all requests - watch for errors

## 🆘 Need Help?

1. Check error message in terminal
2. Verify MongoDB is running
3. Confirm port isn't already in use
4. Try restarting: Stop (Ctrl+C) and `npm run dev` again
5. Check `.env` file has all required variables

---

**Everything is ready! 🎉 Start with: `npm run dev` in backend folder**
