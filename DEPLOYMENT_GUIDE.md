# CrownTech Academy — Deployment Guide

This guide walks you through deploying the CrownTech Academy project to **Render** (backend) and **Vercel** (frontend).

## Prerequisites

- GitHub account
- Render account (free tier available)
- Vercel account (free tier available)
- MongoDB Atlas account (free tier available)
- MySQL database (Render Managed DB or external provider like PlanetScale)
- Domain (optional; can use Render/Vercel subdomains initially)

## Quick Overview

1. **Push repo to GitHub** (public or private)
2. **Deploy backend to Render** (Node/Express API)
3. **Deploy frontend to Vercel** (static HTML/CSS/JS)
4. **Configure databases** (MongoDB Atlas, MySQL)
5. **Set environment variables** on both platforms
6. **Point domain** to Render (API) and Vercel (frontend) via DNS

---

## Step 1: Initialize Git & Push to GitHub

### 1a. Initialize Git in your project root (if not already done)

```bash
cd "C:\Users\DELL\Pictures\my web"
git init
git add .
git commit -m "Initial commit: CrownTech Academy full-stack"
```

### 1b. Create a GitHub repository

1. Go to [github.com/new](https://github.com/new)
2. Create a **new public or private repository** (e.g., `crowntech-academy`)
3. Copy the HTTPS or SSH URL

### 1c. Add remote and push

```bash
git remote add origin https://github.com/<YOUR_USERNAME>/crowntech-academy.git
git branch -M main
git push -u origin main
```

> After this, your full project (frontend + backend folders) will be on GitHub.

---

## Step 2: Deploy Backend to Render

### 2a. Sign up & create a new Web Service

1. Go to [render.com](https://render.com) and sign in
2. Click **New → Web Service**
3. Connect your GitHub repository (authorize Render)
4. Select the repository `crowntech-academy`

### 2b. Configure the Web Service

Fill in the form:

- **Name:** `crowntech-backend`
- **Root Directory:** `backend`
- **Environment:** `Node`
- **Build Command:** `npm install`
- **Start Command:** `npm start`
- **Instance Type:** Free (or Starter)

### 2c. Add Environment Variables

In the **Environment** section, add these variables:

```
MONGODB_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/crowntech
JWT_SECRET=<generate-a-random-string-here>
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=<your-email@gmail.com>
EMAIL_PASSWORD=<app-password-from-gmail>
EMAIL_FROM=noreply@crowntech.com

MYSQL_HOST=<mysql-host>
MYSQL_PORT=3306
MYSQL_USER=<mysql-user>
MYSQL_PASS=<mysql-password>
MYSQL_DB=crowntech

NODE_ENV=production
```

> Replace values with your actual credentials (see sections below for MongoDB Atlas & MySQL setup).

### 2d. Deploy

Click **Create Web Service**. Render will:
- Clone your repo
- Install dependencies
- Start the server
- Provide a URL like `https://crowntech-backend.onrender.com`

> Backend is now live! Keep this URL for frontend config.

---

## Step 3: Deploy Frontend to Vercel

### 3a. Sign up & create a new project

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click **New Project**
3. Import your GitHub repository `crowntech-academy`

### 3b. Configure the project

- **Framework Preset:** Other (HTML/CSS/JS static)
- **Root Directory:** `.` (or leave empty if static files are in root)
- **Build Command:** (leave empty or use `echo "no build"`)
- **Output Directory:** `.` (root, since frontend is in root)

### 3c. Add Environment Variables (optional)

If you want to configure the backend API URL for the frontend:

```
NEXT_PUBLIC_API_BASE_URL=https://crowntech-backend.onrender.com
```

(However, `js/apply.js` already tries both relative and hardcoded localhost URLs, so this is optional.)

### 3d. Deploy

Click **Deploy**. Vercel will:
- Clone your repo
- Deploy to a live URL like `https://crowntech-academy.vercel.app`

> Frontend is now live!

---

## Step 4: Configure Databases

### MongoDB Atlas Setup

1. Go to [mongodb.com/cloud/atlas](https://mongodb.com/cloud/atlas)
2. Create a free cluster (M0 tier)
3. Create a database user with a password
4. Whitelist IP 0.0.0.0/0 (or Render's IPs)
5. Copy the **Connection String** (SRV URI)
6. Use it for `MONGODB_URI` in Render env vars

### MySQL Setup

**Option A: Use Render Managed DB**
1. In Render dashboard, go to **Databases → New Database**
2. Create a PostgreSQL or MySQL DB
3. Copy connection details
4. Add to Render Web Service env vars

**Option B: Use PlanetScale (MySQL-compatible)**
1. Go to [planetscale.com](https://planetscale.com)
2. Create a free MySQL database
3. Copy connection string
4. Set `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASS`, `MYSQL_DB` in env vars

---

## Step 5: Update Frontend API URLs

### Update `js/apply.js` to use production backend

Open `js/apply.js` and update the endpoints array to include your Render URL:

```javascript
const endpoints = ['/api/applications', 'https://crowntech-backend.onrender.com/api/applications'];
```

Or, set a global base URL in `js/main.js`:

```javascript
const API_BASE = window.location.origin.includes('localhost') ? 'http://localhost:5000' : 'https://crowntech-backend.onrender.com';
```

Then use `fetch(`${API_BASE}/api/auth/request-otp`, ...)` throughout.

---

## Step 6: Point Domain to Deployment (Optional)

If you own a custom domain (e.g., `crowntech.com`):

### Frontend (Vercel)

1. In Vercel Project Settings → **Domains**
2. Add your domain (e.g., `crowntech.com`)
3. Vercel provides CNAME records
4. In your domain registrar (Namecheap, GoDaddy, etc.), add CNAME pointing to Vercel

### Backend API (Render)

1. In Render Service Settings → **Custom Domains**
2. Add subdomain (e.g., `api.crowntech.com`)
3. Add CNAME to your registrar pointing to Render

### DNS Example

In your registrar's DNS settings:

```
@ (or crowntech.com)    CNAME   cname.vercel-dns.com
api                     CNAME   crowntech-backend.onrender.com
www                     CNAME   cname.vercel-dns.com
```

---

## Step 7: Test & Verify

### Backend Health Check

Visit: `https://crowntech-backend.onrender.com/api/health`

Expected response:
```json
{ "status": "Server is running", "timestamp": "..." }
```

### Frontend

Visit: `https://crowntech-academy.vercel.app`

- Test login form (OTP requests will POST to backend)
- Test apply form (should upload files and print confirmation)
- Check browser console for any fetch errors

---

## Troubleshooting

### Backend shows "Application Error"

1. Check Render logs: **Dashboard → Service → Logs**
2. Ensure all env vars are set
3. Verify MongoDB and MySQL are accessible from Render

### Frontend API calls fail

1. Check CORS settings in `backend/server.js` (should allow all origins)
2. Verify backend URL in fetch calls
3. Check browser console for errors

### Uploads not persisting

Render's free tier uses ephemeral storage. For persistent uploads:
- Integrate AWS S3 or DigitalOcean Spaces
- Use a managed file service

---

## Continuous Deployment

Both Render and Vercel automatically redeploy on GitHub push (if configured).

To update:
1. Make changes locally
2. `git add .` → `git commit -m "..."` → `git push origin main`
3. Render/Vercel auto-rebuild and deploy within minutes

---

## Next Steps

- Set up email notifications for applications (see `backend/routes/applications.js`)
- Add admin panel to view applications (extend dashboard)
- Monitor logs and uptime on Render/Vercel dashboards
- Consider upgrading to paid tiers if traffic grows

---

**Questions?** Check Render docs: [render.com/docs](https://render.com/docs) | Vercel docs: [vercel.com/docs](https://vercel.com/docs)
