# 📁 Backend File Structure

```
backend/
│
├── 📄 server.js                    ← Main Express app (READY TO START)
├── 📄 seed.js                      ← Database seeding script
├── 📄 package.json                 ← Dependencies & npm scripts
├── 📄 .env                         ← Configuration (EDIT THIS)
├── 📄 .gitignore                   ← Git ignore rules
├── 📄 README.md                    ← Full API documentation
│
├── 📁 models/                      ← Database schemas
│   ├── Admin.js                    ✓ Complete - Admin user with bcrypt
│   ├── Student.js                  ✓ Complete - Student enrollment
│   ├── Course.js                   ✓ Complete - Course details
│   ├── Contact.js                  ✓ Complete - Contact messages
│   └── Assignment.js               ✓ Complete - Assignment tracking
│
├── 📁 routes/                      ← API endpoints
│   ├── auth.js                     ✓ Complete - Login, register, profile
│   ├── students.js                 ✓ Complete - Student CRUD + stats
│   ├── courses.js                  ✓ Complete - Course CRUD
│   ├── contact.js                  ✓ Complete - Contact form handling
│   └── admin.js                    ✓ Complete - Analytics & statistics
│
└── 📁 middleware/
    └── auth.js                     ✓ Complete - JWT verification
```

## ✅ What's Ready

### Server Core
- ✓ Express server configured
- ✓ MongoDB connection setup
- ✓ CORS enabled for frontend
- ✓ JSON parser middleware
- ✓ Error handling
- ✓ 404 handler

### Database Models (5 complete)
- ✓ Admin (with bcrypt password hashing)
- ✓ Student (with course reference)
- ✓ Course (with syllabus array)
- ✓ Contact (for contact form)
- ✓ Assignment (optional advanced feature)

### API Routes (5 route files)
- ✓ Authentication (/api/auth)
  - POST login, register
  - GET profile
  - POST logout
- ✓ Students (/api/students)
  - GET all, GET by ID, POST create
  - PUT update, DELETE remove
  - GET stats/count
- ✓ Courses (/api/courses)
  - GET all, GET by ID, POST create
  - PUT update, DELETE remove
- ✓ Contact (/api/contact)
  - POST submit form
  - GET all messages, GET by ID
  - PUT respond to message
- ✓ Admin Analytics (/api/admin)
  - GET stats (students, courses, trends)
  - GET activities (recent enrollments)
  - GET analytics (distributions, breakdown)

### Security
- ✓ JWT authentication middleware
- ✓ Bcrypt password hashing
- ✓ Protected admin routes
- ✓ Environment variable configuration

## 🚀 Quick Commands

```powershell
# Navigate to backend
cd backend

# Install dependencies
npm install

# Start server (development)
npm run dev

# Seed sample data
npm run seed

# Start server (production)
npm start
```

## 📊 Database Collections

After `npm run seed`, your MongoDB will have:

```
crowntech (database)
├── admins          (1 document - admin@crowntech.com)
├── students        (12 documents - sample students)
├── courses         (6 documents - sample courses)
├── contacts        (empty - receives contact form submissions)
└── assignments     (empty - optional feature)
```

## 🔐 Authentication Flow

```
Frontend                          Backend
  │                                 │
  ├─ POST /api/auth/login ────────→ ├─ Check credentials
  │  (email, password)               ├─ Hash password match
  │                                 │
  │ ← {token, admin} ───────────────┤ Generate JWT
  │                                 │
  └─ Store token in localStorage    └─ Token valid for 24h
     │
     ├─ GET /api/students ────────→ ├─ Verify token
     │  (Authorization: Bearer token) ├─ Return protected data
     │ ← [students array] ──────────┤
     │
```

## 🧪 API Testing

### Option 1: Postman / Insomnia
- Import this curl command:
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@crowntech.com","password":"admin123"}'
```

### Option 2: VS Code REST Client
- Create `test.http` file:
```http
@baseUrl = http://localhost:5000

### Login
POST {{baseUrl}}/api/auth/login
Content-Type: application/json

{
  "email": "admin@crowntech.com",
  "password": "admin123"
}

### Get Courses (no auth needed)
GET {{baseUrl}}/api/courses
```

## 📈 Scale Your Backend

To extend functionality:

1. **Add new model:** Create `backend/models/YourModel.js`
2. **Add new routes:** Create `backend/routes/yourroutes.js`
3. **Mount routes:** Add to `server.js`: `app.use('/api/your', require('./routes/yourroutes'))`
4. **Add validation:** Use express-validator in routes
5. **Add emails:** Uncomment nodemailer in contact.js

---

**Status:** ✅ Backend is 100% ready to use!
**Next:** Start server and seed data, then integrate with frontend.
