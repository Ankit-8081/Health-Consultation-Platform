<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard - HealthConsult Pro</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #00a3e0;
            --primary-dark: #0082b4;
            --bg-light: #f4f8fa;
            --card-shadow: 0 4px 20px rgba(0, 163, 224, 0.08);
        }
        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background-color: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .navbar-brand {
            color: var(--primary-color) !important;
            font-weight: 700;
        }
        .sidebar {
            background-color: #ffffff;
            min-height: calc(100vh - 70px);
            box-shadow: 2px 0 10px rgba(0,0,0,0.03);
        }
        .sidebar .nav-link {
            color: #495057;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: var(--bg-light);
            color: var(--primary-color);
        }
        .sidebar .nav-link i {
            margin-right: 10px;
            color: var(--primary-color);
        }
        .stat-card {
            background: #ffffff;
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-3px);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background-color: rgba(0, 163, 224, 0.1);
            color: var(--primary-color);
        }
        .card-custom {
            background: #ffffff;
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
        }
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: #fff;
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
        }
        .btn-primary-custom:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            color: #fff;
        }
        .avatar-img {
            width: 45px;
            height: 45px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #e2e8f0;
        }
        .banner-card {
            background: linear-gradient(135deg, #e0f2fe 0%, #ffffff 100%);
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
        }
    </style>
</head>
<body>

    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light sticky-top py-3">
        <div class="container-fluid px-4">
            <a class="navbar-brand fs-4" href="#"><i class="fa-solid fa-notes-medical me-2"></i>HealthConsult Pro</a>
            <div class="d-flex align-items-center">
                <img src="https://images.unsplash.com/photo-1594824813576-96f00125c179?auto=format&fit=crop&q=80&w=200" alt="Dr. Aditi Sharma" class="avatar-img me-2">
                <div class="me-3 text-start">
                    <span class="d-block fw-bold text-dark" style="font-size: 0.95rem;"><c:out value="${sessionScope.userName}"/></span>
                    <span class="d-block text-muted" style="font-size: 0.8rem;">Senior Consultant</span>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/logout" style="display:inline"><button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3 ms-2">Logout</button></form>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar Navigation -->
            <div class="col-md-3 col-lg-2 sidebar p-3 d-none d-md-block">
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link active" href="#"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/pro/schedule"><i class="fa-solid fa-calendar-days"></i> Manage Schedule</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-user-injured"></i> My Patients</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-file-prescription"></i> Prescriptions</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-gear"></i> Settings</a></li>
                </ul>
            </div>

            <!-- Main Content Area -->
            <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
                
                <!-- Welcome Banner with Realistic Medical Team Vibe -->
                <div class="card banner-card p-4 mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h2 class="fw-bold text-dark mb-2">Welcome back, <c:out value="${sessionScope.userName}"/>!</h2>
                            <p class="text-muted mb-3">You have <strong>8 consultations</strong> scheduled for today. Your next appointment starts in 15 minutes.</p>
                            <a href="${pageContext.request.contextPath}/pro/schedule" class="btn btn-primary-custom">
                                <i class="fa-solid fa-calendar-plus me-1"></i> Manage Availability
                            </a>
                        </div>
                        <div class="col-lg-4 text-center d-none d-lg-block">
                            <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=400" alt="Medical Team" class="img-fluid rounded-4" style="max-height: 140px; object-fit: cover;">
                        </div>
                    </div>
                </div>

                <!-- Statistics Stat Cards Row -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon me-3"><i class="fa-solid fa-calendar-check"></i></div>
                                <div>
                                    <h6 class="text-muted mb-1">Today's Appointments</h6>
                                    <h3 class="fw-bold mb-0">8</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon me-3" style="background-color: rgba(40, 167, 69, 0.1); color: #28a745;"><i class="fa-solid fa-video"></i></div>
                                <div>
                                    <h6 class="text-muted mb-1">Upcoming Consultations</h6>
                                    <h3 class="fw-bold mb-0">5</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon me-3" style="background-color: rgba(255, 193, 7, 0.1); color: #ffc107;"><i class="fa-solid fa-user-clock"></i></div>
                                <div>
                                    <h6 class="text-muted mb-1">New Patient Requests</h6>
                                    <h3 class="fw-bold mb-0">3</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Today's Patient Queue Table Section -->
                <div class="card card-custom p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="fa-solid fa-list-ul me-2 text-primary"></i>Today's Appointment Queue</h5>
                        <span class="badge bg-primary rounded-pill px-3 py-2">Live Feed</span>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Time Slot</th>
                                    <th>Patient Name</th>
                                    <th>Patient Photo</th>
                                    <th>Reason / Symptoms</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-semibold">10:00 AM - 10:30 AM</td>
                                    <td>Rahul Singh</td>
                                    <td><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150" alt="Patient" class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover;"></td>
                                    <td>Post-op follow-up & vitals check</td>
                                    <td><span class="badge bg-success bg-opacity-15 text-success px-3 py-2">Confirmed</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary px-3 rounded-pill fw-semibold">Start Call</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">11:00 AM - 11:30 AM</td>
                                    <td>Priya Patel</td>
                                    <td><img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=150" alt="Patient" class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover;"></td>
                                    <td>Initial Consultation for chronic migraine</td>
                                    <td><span class="badge bg-warning bg-opacity-15 text-warning px-3 py-2">Pending</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-secondary px-3 rounded-pill fw-semibold">Review Details</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">02:00 PM - 02:30 PM</td>
                                    <td>Amit Kumar</td>
                                    <td><img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150" alt="Patient" class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover;"></td>
                                    <td>Routine check-up & lab review</td>
                                    <td><span class="badge bg-success bg-opacity-15 text-success px-3 py-2">Confirmed</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary px-3 rounded-pill fw-semibold">Join Room</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
