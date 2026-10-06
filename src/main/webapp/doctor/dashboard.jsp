<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Portal | HealthConsult</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-teal: #007670;
            --dark-teal: #004d47;
            --accent-green: #22c55e;
            --bg-light: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-dark); }

        /* HEADER */
        header {
            background: #ffffff;
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--primary-teal);
            text-decoration: none;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .status-badge {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #f0fdf4;
            color: #166534;
            padding: 0.4rem 0.85rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 700;
            border: 1px solid #bbf7d0;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            background-color: #22c55e;
            border-radius: 50%;
        }

        .nav-back {
            text-decoration: none;
            color: #475569;
            font-weight: 700;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
            transition: color 0.2s;
        }

        .nav-back:hover { color: var(--primary-teal); }

        /* CONTAINER */
        .dashboard-container {
            max-width: 1280px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        /* WELCOME BANNER */
        .welcome-banner {
            background: linear-gradient(135deg, #005a54 0%, #003a36 100%);
            border-radius: 16px;
            padding: 2rem 2.5rem;
            color: #ffffff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            box-shadow: 0 10px 25px rgba(0, 77, 71, 0.15);
        }

        .profile-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .doc-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid #ffffff;
            object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .banner-text h1 {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 0.3rem;
        }

        .banner-text p {
            color: #cbd5e1;
            font-size: 0.95rem;
        }

        .banner-cta {
            background: #22c55e;
            color: #000;
            font-weight: 800;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background 0.2s;
        }

        .banner-cta:hover { background: #16a34a; color: #fff; }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-top: 0.2rem;
        }

        .stat-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }

        /* MAIN CONTENT GRID */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }

        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.75rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            margin-bottom: 2rem;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-dark);
        }

        /* APPOINTMENTS TABLE */
        .table-responsive { overflow-x: auto; }
        .app-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .app-table th {
            padding: 0.85rem 1rem;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-muted);
            background: #f8fafc;
            border-bottom: 1px solid var(--border-color);
        }

        .app-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .patient-cell {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .patient-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .patient-name {
            font-weight: 700;
            color: var(--text-dark);
        }

        .patient-meta {
            font-size: 0.78rem;
            color: var(--text-muted);
        }

        .type-tag {
            display: inline-block;
            padding: 0.25rem 0.6rem;
            border-radius: 6px;
            font-size: 0.78rem;
            font-weight: 700;
        }

        .type-video { background: #e0f2fe; color: #0369a1; }
        .type-visit { background: #fef3c7; color: #b45309; }

        .btn-action {
            padding: 0.45rem 0.9rem;
            border-radius: 6px;
            font-weight: 700;
            font-size: 0.82rem;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .btn-start { background: var(--primary-teal); color: #fff; }
        .btn-start:hover { background: var(--dark-teal); }

        /* RIGHT SIDEBAR CARDS */
        .patient-queue-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .patient-queue-item:last-child { border-bottom: none; }

        .consultation-banner {
            background-image: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.7)), url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600&auto=format&fit=crop&q=80');
            background-size: cover;
            background-position: center;
            border-radius: 12px;
            padding: 1.5rem;
            color: #ffffff;
            margin-top: 1rem;
        }

        .consultation-banner h4 { font-size: 1.1rem; margin-bottom: 0.5rem; }
        .consultation-banner p { font-size: 0.85rem; color: #e2e8f0; margin-bottom: 1rem; }
    </style>
</head>
<body>

    <!-- TOP HEADER -->
    <header>
        <a href="../index.jsp" class="brand-logo">
            <i class="fa-solid fa-user-doctor"></i> Doctor Portal
        </a>
        <div class="header-actions">
            <div class="status-badge">
                <span class="status-dot"></span> Available for Consultations
            </div>
            <a href="../index.jsp" class="nav-back">
                <i class="fa-solid fa-arrow-left"></i> Back to Home
            </a>
        </div>
    </header>

    <!-- MAIN DASHBOARD -->
    <div class="dashboard-container">

        <!-- WELCOME BANNER -->
        <div class="welcome-banner">
            <div class="profile-info">
                <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80" alt="Doctor Profile" class="doc-avatar">
                <div class="banner-text">
                    <h1>Welcome back, Dr. Alexander Smith</h1>
                    <p>Senior Cardiologist • Specialist Consultation ID: #DOC-88219</p>
                </div>
            </div>
            <a href="#" class="banner-cta">
                <i class="fa-solid fa-video"></i> Start Next Call
            </a>
        </div>

        <!-- STATS CARDS -->
        <div class="stats-grid">
            <div class="stat-card">
                <div>
                    <div class="stat-label">Today's Appointments</div>
                    <div class="stat-number">12</div>
                </div>
                <div class="stat-icon" style="background: #e0f2fe; color: #0284c7;">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Pending Consultations</div>
                    <div class="stat-number">4</div>
                </div>
                <div class="stat-icon" style="background: #fef3c7; color: #d97706;">
                    <i class="fa-solid fa-clock"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Completed Sessions</div>
                    <div class="stat-number">8</div>
                </div>
                <div class="stat-icon" style="background: #dcfce7; color: #15803d;">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Total Patients</div>
                    <div class="stat-number">1,248</div>
                </div>
                <div class="stat-icon" style="background: #f3e8ff; color: #7e22ce;">
                    <i class="fa-solid fa-users"></i>
                </div>
            </div>
        </div>

        <!-- TWO COLUMN LAYOUT -->
        <div class="content-grid">

            <!-- LEFT: APPOINTMENTS SCHEDULE -->
            <div class="section-card">
                <div class="section-header">
                    <h2 class="section-title"><i class="fa-solid fa-clipboard-list"></i> Today's Consultation Schedule</h2>
                    <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">October 6, 2026</span>
                </div>

                <div class="table-responsive">
                    <table class="app-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Time</th>
                                <th>Mode</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="patient-cell">
                                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" alt="Patient" class="patient-img">
                                        <div>
                                            <div class="patient-name">Sarah Jenkins</div>
                                            <div class="patient-meta">28 Yrs • Female</div>
                                        </div>
                                    </div>
                                </td>
                                <td><strong>03:45 PM</strong></td>
                                <td><span class="type-tag type-video"><i class="fa-solid fa-video"></i> Video Call</span></td>
                                <td><span style="color: #d97706; font-weight: 700;">Waiting</span></td>
                                <td><a href="#" class="btn-action btn-start"><i class="fa-solid fa-circle-play"></i> Join Call</a></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="patient-cell">
                                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80" alt="Patient" class="patient-img">
                                        <div>
                                            <div class="patient-name">Michael Chang</div>
                                            <div class="patient-meta">42 Yrs • Male</div>
                                        </div>
                                    </div>
                                </td>
                                <td><strong>04:15 PM</strong></td>
                                <td><span class="type-tag type-visit"><i class="fa-solid fa-building-user"></i> In-Person</span></td>
                                <td><span style="color: #0284c7; font-weight: 700;">Confirmed</span></td>
                                <td><a href="#" class="btn-action btn-start" style="background:#475569;"><i class="fa-solid fa-file-medical"></i> Records</a></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="patient-cell">
                                        <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80" alt="Patient" class="patient-img">
                                        <div>
                                            <div class="patient-name">Emily Davis</div>
                                            <div class="patient-meta">35 Yrs • Female</div>
                                        </div>
                                    </div>
                                </td>
                                <td><strong>05:00 PM</strong></td>
                                <td><span class="type-tag type-video"><i class="fa-solid fa-video"></i> Video Call</span></td>
                                <td><span style="color: #64748b; font-weight: 700;">Scheduled</span></td>
                                <td><a href="#" class="btn-action btn-start" style="background:#0284c7;"><i class="fa-solid fa-bell"></i> Remind</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- RIGHT SIDEBAR -->
            <div>
                <!-- QUICK WAITING QUEUE -->
                <div class="section-card">
                    <div class="section-header">
                        <h3 class="section-title"><i class="fa-solid fa-user-clock"></i> Virtual Queue</h3>
                        <span class="status-badge" style="padding: 0.2rem 0.6rem; font-size: 0.75rem;">2 Online</span>
                    </div>

                    <div class="patient-queue-item">
                        <div class="patient-cell">
                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80" alt="Patient" class="patient-img">
                            <div>
                                <div class="patient-name">Robert Taylor</div>
                                <div class="patient-meta">Heart Checkup • 5m ago</div>
                            </div>
                        </div>
                        <a href="#" style="color: var(--primary-teal); font-size: 1.2rem;"><i class="fa-circle-right fa-solid"></i></a>
                    </div>

                    <div class="patient-queue-item">
                        <div class="patient-cell">
                            <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80" alt="Patient" class="patient-img">
                            <div>
                                <div class="patient-name">Elena Rostova</div>
                                <div class="patient-meta">Prescription Refill</div>
                            </div>
                        </div>
                        <a href="#" style="color: var(--primary-teal); font-size: 1.2rem;"><i class="fa-circle-right fa-solid"></i></a>
                    </div>
                </div>

                <!-- CLINICAL LABS PROMO -->
                <div class="consultation-banner">
                    <h4><i class="fa-solid fa-stethoscope"></i> E-Prescription Portal</h4>
                    <p>Issue digitally signed prescriptions and order diagnostic lab tests directly to patient portals.</p>
                    <a href="#" class="btn-action btn-start"><i class="fa-solid fa-pen-to-square"></i> Issue Prescription</a>
                </div>
            </div>

        </div>

    </div>

</body>
</html>
