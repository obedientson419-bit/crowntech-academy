# CrownTech Academy — Full-Stack Deployment Quick Start

## One-Click Deployment (Step-by-Step)

### Phase 1: GitHub Setup (5 min)

1. **Initialize Git:**
   ```bash
   cd "C:\Users\DELL\Pictures\my web"
   git init
   git add .
   git commit -m "Initial commit: CrownTech Academy"
   ```

2. **Create a GitHub repository:**
   - Go to [github.com/new](https://github.com/new)
   - Name: `crowntech-academy`
   - Visibility: Public (for Render/Vercel free tier)
   - Click "Create repository"

3. **Push to GitHub:**
   ```bash
   git remote add origin https://github.com/<YOUR_USERNAME>/crowntech-academy.git
   git branch -M main
   git push -u origin main
   ```

---

### Phase 2: Backend Deployment on Render (10 min)

1. **Sign up at [render.com](https://render.com)**

2. **Create a Web Service:**
   - Click "New" → "Web Service"
   - Select your GitHub repo
   - Click "Connect"

3. **Configure:**
   - Name: `crowntech-backend`
   - Runtime: `Node`
   - Root Directory: `backend`
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Instance Type: Free

4. **Add Environment Variables:**
   Click "Advanced" and add:
   ```
   MONGODB_URI = mongodb+srv://user:pass@cluster.mongodb.net/crowntech
   JWT_SECRET = your-random-secret-key-here
   EMAIL_HOST = smtp.gmail.com
   EMAIL_PORT = 587
   EMAIL_USER = your@gmail.com
   EMAIL_PASSWORD = your-app-password
   EMAIL_FROM = noreply@crowntech.com
   MYSQL_HOST = your-mysql-host
   MYSQL_USER = your-user
   MYSQL_PASS = your-pass
   MYSQL_DB = crowntech
   NODE_ENV = production
   ```

5. **Deploy:** Click "Create Web Service"
   - Wait ~2 minutes for build/deploy
   - Copy your backend URL (e.g., `https://crowntech-backend.onrender.com`)

---

### Phase 3: Frontend Deployment on Vercel (5 min)

1. **Sign up at [vercel.com](https://vercel.com)**

2. **New Project:**
   - Click "New Project"
   - Import your GitHub repo
   - Click "Import"

3. **Configure:**
   - Framework: "Other" (static HTML/CSS/JS)
   - Root Directory: `.` (dot)
   - Build Command: (leave empty)
   - Output Directory: `.` (dot)
   - Click "Deploy"

4. **Wait for deployment** (~1 minute)
   - Copy your frontend URL (e.g., `https://crowntech-academy.vercel.app`)

---

### Phase 4: Update Frontend to Use Backend (2 min)

In `js/apply.js`, update the endpoints:

```javascript
const endpoints = ['/api/applications', 'https://crowntech-backend.onrender.com/api/applications'];
```

In `js/main.js`, update any other backend calls similarly.

Then **push the changes:**
```bash
git add js/apply.js js/main.js
git commit -m "Update: point frontend to production backend"
git push origin main
```

Vercel auto-redeploys.

---

### Phase 5: Database Setup (15 min)

#### MongoDB Atlas
1. Go to [mongodb.com/cloud/atlas](https://mongodb.com/cloud/atlas)
2. Create free cluster (M0)
3. Create a database user
4. Whitelist IP: `0.0.0.0/0`
5. Copy SRV connection string → set as `MONGODB_URI` in Render env

#### MySQL
**Option A: Render Managed DB**
- In Render, "Databases" → "New Database" → MySQL
- Copy credentials → set in Render env vars

**Option B: PlanetScale (free MySQL)** 
- Go to [planetscale.com](https://planetscale.com), create DB
- Copy connection details → set in Render env vars

---

### Phase 6: Test Everything

1. **Health Check:**
   ```bash
   curl https://crowntech-backend.onrender.com/api/health
   ```

2. **Visit Frontend:**
   - Open `https://crowntech-academy.vercel.app`
   - Test login (OTP)
   - Test apply form (file upload)
   - Check browser console for errors

3. **Monitor Logs:**
   - Render: Dashboard → Service → Logs
   - Vercel: Dashboard → Project → Deployments → Logs

---

### Optional: Custom Domain

1. **Buy domain** (Namecheap, GoDaddy, etc.)

2. **Add to Vercel (frontend):**
   - Project Settings → Domains
   - Add your domain
   - Follow CNAME instructions

3. **Add to Render (backend):**
   - Service Settings → Custom Domains
   - Add `api.yourdomain.com`
   - Follow CNAME instructions

4. **Update DNS** in registrar with provided CNAME records

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Backend "Application Error" | Check Render Logs → ensure env vars set, DBs accessible |
| Frontend API calls fail | Check browser console → verify backend URL in fetch calls |
| Uploads not working | Render free tier has ephemeral storage; integrate S3 or Spaces |
| Slow deployment | Free tier has lower resources; upgradable to paid for speed |

---

## Auto-Deployment Workflow

After initial setup, future updates are automatic:

```bash
# Make changes locally
git add .
git commit -m "Feature: add X"
git push origin main

# Render + Vercel auto-deploy within minutes! ✓
```

---

**Estimated Time:** ~45 minutes (including database setup)

**Cost:** FREE (using free tiers of all services)

For detailed guide, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
