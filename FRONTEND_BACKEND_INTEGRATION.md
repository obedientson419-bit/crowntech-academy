# Frontend-Backend Integration Guide

This guide shows how to connect your existing frontend to the backend API.

## 🔗 Connection Overview

```
Frontend (index.html)  ←→  Backend API (localhost:5000)  ←→  MongoDB
Port: 8000/8080              Port: 5000                       Port: 27017
```

## ✅ Prerequisites

1. ✓ Backend is running: `npm run dev` in `backend/` folder
2. ✓ Database seeded: `npm run seed` (sample data loaded)
3. ✓ Frontend server running (any local server on different port)

## 🔌 Integration Steps

### Step 1: Update Admin Login in `js/main.js`

Find the `handleAdminLogin` function and update it:

**BEFORE (hardcoded):**
```javascript
function handleAdminLogin(event) {
  event.preventDefault();
  showToast('Admin logged in successfully!', 'success');
  document.getElementById('home').style.display = 'none';
  document.getElementById('admin-dashboard').style.display = 'block';
}
```

**AFTER (API call):**
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
      // Store token for future API calls
      localStorage.setItem('authToken', data.token);
      localStorage.setItem('adminUser', JSON.stringify(data.admin));
      
      showToast(`Welcome, ${data.admin.name}!`, 'success');
      
      // Show dashboard
      document.getElementById('home').style.display = 'none';
      document.getElementById('admin-dashboard').style.display = 'block';
      
      // Load dashboard data
      loadDashboardData();
    } else {
      showToast(data.error || 'Login failed', 'error');
    }
  } catch (error) {
    console.error('Login error:', error);
    showToast('Connection error. Is the backend running?', 'error');
  }
}
```

### Step 2: Load Dashboard Data

Add this function to `js/main.js`:

```javascript
async function loadDashboardData() {
  const token = localStorage.getItem('authToken');
  
  if (!token) {
    console.warn('No authentication token');
    return;
  }

  try {
    // Get statistics
    const statsResponse = await fetch('http://localhost:5000/api/admin/stats', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    const stats = await statsResponse.json();
    
    // Update dashboard stats
    updateDashboardStats(stats);
    
    // Get analytics
    const analyticsResponse = await fetch('http://localhost:5000/api/admin/analytics', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    const analytics = await analyticsResponse.json();
    
    // Initialize charts with real data
    initChartsWithData(analytics);
    
  } catch (error) {
    console.error('Failed to load dashboard data:', error);
    showToast('Failed to load dashboard data', 'error');
  }
}

function updateDashboardStats(stats) {
  // Update stat cards with real data
  const statCards = document.querySelectorAll('.stat-card');
  
  statCards[0].querySelector('.stat-number').textContent = stats.totalStudents || 0;
  statCards[1].querySelector('.stat-number').textContent = stats.activeStudents || 0;
  statCards[2].querySelector('.stat-number').textContent = stats.totalCourses || 0;
  statCards[3].querySelector('.stat-number').textContent = Math.round(stats.averageProgress || 0) + '%';
}
```

### Step 3: Load Students

Add this function to load students into the Students tab:

```javascript
async function loadStudents() {
  const token = localStorage.getItem('authToken');
  
  if (!token) {
    showToast('Please login first', 'error');
    return;
  }

  try {
    const response = await fetch('http://localhost:5000/api/students', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    const students = await response.json();
    
    // Get students container
    const container = document.getElementById('students-content');
    
    // Build table
    let html = `
      <table style="width: 100%; border-collapse: collapse;">
        <thead>
          <tr style="background: var(--surface); padding: 1rem;">
            <th style="text-align: left; padding: 0.75rem;">Name</th>
            <th style="text-align: left; padding: 0.75rem;">Email</th>
            <th style="text-align: left; padding: 0.75rem;">Status</th>
            <th style="text-align: left; padding: 0.75rem;">Progress</th>
          </tr>
        </thead>
        <tbody>
    `;
    
    students.forEach(student => {
      html += `
        <tr style="border-bottom: 1px solid var(--border);">
          <td style="padding: 0.75rem;">${student.name}</td>
          <td style="padding: 0.75rem;">${student.email}</td>
          <td style="padding: 0.75rem;">
            <span style="background: ${student.status === 'active' ? '#4ade80' : '#ef4444'}; 
                         color: white; padding: 0.25rem 0.75rem; border-radius: 4px;">
              ${student.status}
            </span>
          </td>
          <td style="padding: 0.75rem;">${student.progress}%</td>
        </tr>
      `;
    });
    
    html += '</tbody></table>';
    container.innerHTML = html;
    
  } catch (error) {
    console.error('Failed to load students:', error);
    showToast('Failed to load students', 'error');
  }
}
```

### Step 4: Load Courses

Add this function to load courses:

```javascript
async function loadCourses() {
  try {
    const response = await fetch('http://localhost:5000/api/courses');
    const courses = await response.json();
    
    // Get courses container
    const container = document.getElementById('courses-content');
    
    let html = '<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem;">';
    
    courses.forEach(course => {
      html += `
        <div style="background: var(--surface); padding: 1.5rem; border-radius: 8px; border: 1px solid var(--border);">
          <h3 style="margin: 0 0 0.5rem 0;">${course.title}</h3>
          <p style="color: var(--text-secondary); font-size: 0.9rem; margin: 0.5rem 0;">
            ${course.description.substring(0, 100)}...
          </p>
          <div style="margin: 1rem 0; font-size: 0.85rem;">
            <p><strong>Instructor:</strong> ${course.instructor}</p>
            <p><strong>Level:</strong> ${course.level}</p>
            <p><strong>Duration:</strong> ${course.duration}</p>
            <p><strong>Price:</strong> $${course.price}</p>
          </div>
          <div style="background: var(--primary); color: white; padding: 0.5rem 1rem; 
                      border-radius: 4px; text-align: center; cursor: pointer;">
            View Details
          </div>
        </div>
      `;
    });
    
    html += '</div>';
    container.innerHTML = html;
    
  } catch (error) {
    console.error('Failed to load courses:', error);
    showToast('Failed to load courses', 'error');
  }
}
```

### Step 5: Update Tab Switching

Modify `switchDashboardTab` to load data when tabs are clicked:

```javascript
function switchDashboardTab(tabName) {
  // Hide all tabs
  document.querySelectorAll('.tab-content').forEach(tab => {
    tab.style.display = 'none';
  });
  
  // Remove active class from all buttons
  document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  
  // Show selected tab
  const selectedTab = document.getElementById(tabName + '-content');
  if (selectedTab) {
    selectedTab.style.display = 'block';
  }
  
  // Add active class to clicked button
  event.target.classList.add('active');
  
  // Load data based on tab
  if (tabName === 'students') {
    loadStudents();
  } else if (tabName === 'courses') {
    loadCourses();
  } else if (tabName === 'overview') {
    loadDashboardData();
  }
}
```

### Step 6: Update Contact Form

Find the contact form submission and update it:

```javascript
async function handleContactSubmit(event) {
  event.preventDefault();
  
  const name = document.getElementById('contactName').value;
  const email = document.getElementById('contactEmail').value;
  const message = document.getElementById('contactMessage').value;
  
  try {
    const response = await fetch('http://localhost:5000/api/contact', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email, message })
    });
    
    if (response.ok) {
      showToast('Message sent successfully!', 'success');
      event.target.reset();
    } else {
      const error = await response.json();
      showToast(error.error || 'Failed to send message', 'error');
    }
  } catch (error) {
    console.error('Error:', error);
    showToast('Connection error', 'error');
  }
}
```

## 📊 Using Chart.js with Real Data

Update the chart initialization functions:

```javascript
async function initChartsWithData(analytics) {
  // Prepare enrollment trend data
  const enrollmentLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  const enrollmentData = [12, 19, 8, 15, 22, 18];
  
  // Get first canvas context
  const enrollmentCtx = document.getElementById('enrollmentChart')?.getContext('2d');
  
  if (enrollmentCtx) {
    new Chart(enrollmentCtx, {
      type: 'line',
      data: {
        labels: enrollmentLabels,
        datasets: [{
          label: 'New Enrollments',
          data: enrollmentData,
          borderColor: 'var(--primary)',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: true } }
      }
    });
  }
  
  // Similarly for other charts...
}
```

## 🧪 Testing Integration

### Test 1: Login
1. Open index.html in browser
2. Click "Admin Login" button
3. Enter: admin@crowntech.com / admin123
4. Should see success toast and dashboard

### Test 2: View Students
1. Click "Students" tab in dashboard
2. Should load and display student list from database

### Test 3: View Courses
1. Click "Courses" tab in dashboard
2. Should load and display courses from database

### Test 4: Contact Form
1. Scroll to contact section
2. Fill in name, email, message
3. Submit
4. Should see success message

## 🔒 Security Notes

1. **Never expose JWT secret** in frontend
2. **Store token in localStorage** (already done)
3. **Include token in Authorization header** for protected routes
4. **Token expires in 24 hours** - user must re-login
5. **Use HTTPS** in production (not needed for localhost)

## ❌ Troubleshooting Integration

### "Failed to load students - 401"
- Token expired or missing
- Solution: Re-login to get new token

### "Connection error. Is the backend running?"
- Backend server is not running
- Solution: Run `npm run dev` in backend folder

### CORS errors in browser
- Backend and frontend on different origins
- Solution: CORS already enabled in server.js, should work

### Data not updating
- Charts may need full page refresh
- Try: `window.location.reload()`

## 📈 What's Next?

1. ✅ Backend API running
2. ✅ Frontend connected to API
3. **Optional:** Add more features
   - Student registration form
   - Course enrollment endpoint
   - Payment processing
   - Email notifications
   - Real-time notifications

---

**Status:** Frontend-Backend integration ready!
