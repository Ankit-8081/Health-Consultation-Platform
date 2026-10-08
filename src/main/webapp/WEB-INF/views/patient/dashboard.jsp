<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Portal - HealthConsult Pro</title>
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
            <a class="navbar-brand fs-4" href="#"><i class="fa-solid fa-heart-pulse me-2"></i>HealthConsult Patient Portal</a>
            <div class="d-flex align-items-center">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200" alt="Patient Avatar" class="avatar-img me-2">
                <div class="me-3 text-start">
                    <span class="d-block fw-bold text-dark" style="font-size: 0.95rem;"><c:out value="${sessionScope.userName}"/></span>
                    <span class="d-block text-muted" style="font-size: 0.8rem;">Patient ID: #HC-8492</span>
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
                    <li class="nav-item"><a class="nav-link active" href="#"><i class="fa-solid fa-house-medical"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/book"><i class="fa-solid fa-calendar-plus"></i> Book Consultation</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-receipt"></i> Prescriptions</a></li>
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-user-gear"></i> Profile Settings</a></li>
                </ul>
            </div>

            <!-- Main Content Area -->
            <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
                
                <!-- Welcome Banner -->
                <div class="card banner-card p-4 mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h2 class="fw-bold text-dark mb-2">Hello, <c:out value="${sessionScope.userName}"/>! Take charge of your health today.</h2>
                            <p class="text-muted mb-3">Consult India's top verified specialists online, check your prescriptions, and manage upcoming appointments seamlessly.</p>
                            <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary-custom">
                                <i class="fa-solid fa-stethoscope me-1"></i> Book New Consultation
                            </a>
                        </div>
                        <div class="col-lg-4 text-center d-none d-lg-block">
                            <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=400" alt="Healthcare consultation" class="img-fluid rounded-4" style="max-height: 140px; object-fit: cover;">
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
                                    <h6 class="text-muted mb-1">Upcoming Appointments</h6>
                                    <h3 class="fw-bold mb-0">2</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon me-3" style="background-color: rgba(40, 167, 69, 0.1); color: #28a745;"><i class="fa-solid fa-file-prescription"></i></div>
                                <div>
                                    <h6 class="text-muted mb-1">Active Prescriptions</h6>
                                    <h3 class="fw-bold mb-0">4</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon me-3" style="background-color: rgba(255, 193, 7, 0.1); color: #ffc107;"><i class="fa-solid fa-flask"></i></div>
                                <div>
                                    <h6 class="text-muted mb-1">Lab Reports Ready</h6>
                                    <h3 class="fw-bold mb-0">1</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments Table Section -->
                <div class="card card-custom p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>My Upcoming Appointments</h5>
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="text-decoration-name fw-semibold text-primary" style="font-size: 0.9rem;">View All Bookings</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Doctor</th>
                                    <th>Specialty</th>
                                    <th>Date & Time</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="https://images.unsplash.com/photo-1594824813576-96f00125c179?auto=format&fit=crop&q=80&w=150" alt="Doctor" class="rounded-circle me-2" style="width: 35px; height: 35px; object-fit: cover;">
                                            <span class="fw-semibold">Dr. Aditi Sharma</span>
                                        </div>
                                    </td>
                                    <td>General Physician</td>
                                    <td>Oct 08, 2026 - 10:00 AM</td>
                                    <td><span class="badge bg-success bg-opacity-15 text-success px-3 py-2">Confirmed</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary px-3 rounded-pill fw-semibold">Join Video Call</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=150" alt="Doctor" class="rounded-circle me-2" style="width: 35px; height: 35px; object-fit: cover;">
                                            <span class="fw-semibold">Dr. Vikram Singh</span>
                                        </div>
                                    </td>
                                    <td>Neurologist</td>
                                    <td>Oct 12, 2026 - 02:30 PM</td>
                                    <td><span class="badge bg-warning bg-opacity-15 text-warning px-3 py-2">Pending</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-secondary px-3 rounded-pill fw-semibold">Reschedule</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Featured Top Specialists Section (MFine Style) -->
                <div class="card card-custom p-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-user-doctor me-2 text-primary"></i>Consult Top Specialists Online</h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-white text-center">
                                <img src="https://images.unsplash.com/photo-1594824813576-96f00125c179?auto=format&fit=crop&q=80&w=200" alt="Specialist" class="rounded-circle mb-2" style="width: 70px; height: 70px; object-fit: cover;">
                                <h6 class="fw-bold mb-1">Dr. Aditi Sharma</h6>
                                <p class="text-muted small mb-2">General Medicine • 10 yrs exp</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-sm btn-outline-primary w-100 rounded-pill">Consult Now</a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-white text-center">
                                <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200" alt="Specialist" class="rounded-circle mb-2" style="width: 70px; height: 70px; object-fit: cover;">
                                <h6 class="fw-bold mb-1">Dr. Vikram Singh</h6>
                                <p class="text-muted small mb-2">Neurology • 12 yrs exp</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-sm btn-outline-primary w-100 rounded-pill">Consult Now</a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-white text-center">
                                <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200" alt="Specialist" class="rounded-circle mb-2" style="width: 70px; height: 70px; object-fit: cover;">
                                <h6 class="fw-bold mb-1">Dr. Priya Nair</h6>
                                <p class="text-muted small mb-2">Pediatrics • 8 yrs exp</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-sm btn-outline-primary w-100 rounded-pill">Consult Now</a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
