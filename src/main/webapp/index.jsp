<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthConsult | Online Doctor Consultations 24/7</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #007670;
            --dark-green: #004d47;
            --accent-green: #22c55e;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--light-bg); color: var(--text-dark); }

        /* NAVBAR */
        header {
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            padding: 1.1rem 6%;
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
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--primary-green);
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #334155;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.2s;
        }

        .nav-links a:hover { color: var(--primary-green); }

        .btn-login {
            background: var(--primary-green);
            color: #ffffff !important;
            padding: 0.65rem 1.4rem;
            border-radius: 10px;
            font-weight: 700 !important;
            transition: background 0.2s;
        }

        .btn-login:hover { background: var(--dark-green); }

        /* HERO SECTION */
        .hero {
            background: linear-gradient(135deg, #004d47 0%, #002d2a 100%);
            padding: 4.5rem 6% 5.5rem 6%;
            color: #ffffff;
            position: relative;
            overflow: hidden;
        }

        .hero-container {
            max-width: 1280px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1.25fr;
            gap: 3rem;
            align-items: center;
        }

        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.45rem 1rem;
            border-radius: 30px;
            font-size: 0.85rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #a7f3d0;
        }

        .hero-title {
            font-size: 3.2rem;
            font-weight: 800;
            line-height: 1.15;
            margin-bottom: 1.2rem;
            letter-spacing: -0.5px;
        }

        .hero-title span { color: #4ade80; }

        .hero-subtitle {
            font-size: 1.05rem;
            color: #cbd5e1;
            line-height: 1.6;
            margin-bottom: 2.2rem;
            max-width: 520px;
        }

        .btn-consult {
            background: var(--accent-green);
            color: #042f2e;
            padding: 0.9rem 2rem;
            border-radius: 12px;
            font-weight: 800;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.3);
            transition: all 0.2s;
        }

        .btn-consult:hover {
            background: #16a34a;
            color: #ffffff;
            transform: translateY(-2px);
        }

        /* DOCTOR CARDS GRID */
        .doctors-cards-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.2rem;
        }

        .doc-card-hero {
            position: relative;
            border-radius: 18px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 380px;
        }

        .doc-card-hero:hover {
            transform: translateY(-6px);
            box-shadow: 0 18px 35px rgba(0,0,0,0.4);
        }

        .doc-card-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: top center;
            display: block;
        }

        .doc-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0, 30, 28, 0.95) 0%, rgba(0, 30, 28, 0.5) 70%, transparent 100%);
            padding: 1.25rem 1rem 1rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .doc-name { font-size: 1.05rem; font-weight: 800; color: #ffffff; }
        .doc-role { font-size: 0.82rem; color: #a7f3d0; font-weight: 600; }
        .doc-rating { font-size: 0.78rem; color: #fbbf24; font-weight: 700; margin-top: 0.2rem; }

        /* LIVE STATS BAR */
        .stats-bar {
            max-width: 1280px;
            margin: -2.5rem auto 4rem auto;
            padding: 0 6%;
            position: relative;
            z-index: 10;
        }

        .stats-grid {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 1.8rem 2.5rem;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
        }

        .stat-item {
            text-align: center;
            border-right: 1px solid var(--border-color);
        }

        .stat-item:last-child { border-right: none; }
        .stat-value { font-size: 2rem; font-weight: 800; color: var(--primary-green); }
        .stat-label { font-size: 0.85rem; color: var(--text-muted); font-weight: 600; margin-top: 0.2rem; }

        /* SPECIALTIES SECTION */
        .section-container {
            max-width: 1280px;
            margin: 0 auto 4rem auto;
            padding: 0 6%;
        }

        .section-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .section-title { font-size: 2rem; font-weight: 800; color: var(--text-dark); margin-bottom: 0.5rem; }
        .section-desc { font-size: 1rem; color: var(--text-muted); }

        .specialties-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.25rem;
        }

        .spec-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 1.5rem 1rem;
            text-align: center;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: var(--text-dark);
        }

        .spec-card:hover {
            border-color: var(--primary-green);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 118, 112, 0.08);
        }

        .spec-icon {
            width: 55px;
            height: 55px;
            background: #e6f4f3;
            color: var(--primary-green);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin: 0 auto 1rem auto;
        }

        .spec-name { font-size: 0.95rem; font-weight: 700; }

        /* HOW IT WORKS */
        .workflow-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 2rem;
        }

        .work-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            position: relative;
        }

        .work-number {
            width: 38px;
            height: 38px;
            background: var(--primary-green);
            color: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.9rem;
            margin: 0 auto 1.2rem auto;
        }

        /* FOOTER */
        footer {
            background: #0b1329;
            color: #94a3b8;
            padding: 3rem 6% 2rem 6%;
            border-top: 1px solid #1e293b;
        }

        .footer-container {
            max-width: 1280px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #1e293b;
            padding-bottom: 2rem;
            margin-bottom: 1.5rem;
        }

        .footer-brand { font-size: 1.4rem; font-weight: 800; color: #22d3ee; }
        .footer-copy { font-size: 0.85rem; text-align: center; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <header>
        <a href="index.jsp" class="brand-logo">
            <i class="fa-solid fa-heart-pulse"></i> HealthConsult
        </a>

        <ul class="nav-links">
            <li><a href="index.jsp">Find Doctors</a></li>
            <li><a href="patient/dashboard.jsp">Patient Portal</a></li>
            <li><a href="doctor/dashboard.jsp">Doctor Portal</a></li>
            <li><a href="#">Admin Portal</a></li>
            <li><a href="patient/dashboard.jsp" class="btn-login">Login / Register</a></li>
        </ul>
    </header>

    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-container">
            <div>
                <div class="hero-tag">
                    <i class="fa-solid fa-shield-halved"></i> Verified Doctor Consultations
                </div>
                <h1 class="hero-title">
                    Consult Certified<br>
                    Doctors <span>Online 24/7</span>
                </h1>
                <p class="hero-subtitle">
                    Connect with top medical specialists via secure video or audio call in under 10 minutes. Safe, private, and convenient care from anywhere.
                </p>
                <a href="patient/dashboard.jsp" class="btn-consult">
                    Consult Now <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>

            <!-- DOCTORS GRID -->
            <div class="doctors-cards-container">
                <div class="doc-card-hero">
                    <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=500&auto=format&fit=crop&q=80" alt="Dr. Julian Ross">
                    <div class="doc-overlay">
                        <div class="doc-name">Dr. Julian Ross</div>
                        <div class="doc-role">General Physician</div>
                        <div class="doc-rating"><i class="fa-solid fa-star"></i> 4.9 (140+ reviews)</div>
                    </div>
                </div>

                <div class="doc-card-hero">
                    <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500&auto=format&fit=crop&q=80" alt="Dr. Sarah Jenkins">
                    <div class="doc-overlay">
                        <div class="doc-name">Dr. Sarah Jenkins</div>
                        <div class="doc-role">Cardiologist</div>
                        <div class="doc-rating"><i class="fa-solid fa-star"></i> 4.8 (95+ reviews)</div>
                    </div>
                </div>

                <div class="doc-card-hero">
                    <img src="https://images.unsplash.com/photo-1594824813571-2153349aed06?w=500&auto=format&fit=crop&q=80" alt="Dr. Elena Vance">
                    <div class="doc-overlay">
                        <div class="doc-name">Dr. Elena Vance</div>
                        <div class="doc-role">Neurologist</div>
                        <div class="doc-rating"><i class="fa-solid fa-star"></i> 4.9 (210+ reviews)</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- LIVE STATS BAR -->
    <div class="stats-bar">
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value">500+</div>
                <div class="stat-label">Verified Doctors</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">98.4%</div>
                <div class="stat-label">Positive Feedback</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">&lt; 10 Mins</div>
                <div class="stat-label">Average Response Time</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">250k+</div>
                <div class="stat-label">Consultations Done</div>
            </div>
        </div>
    </div>

    <!-- POPULAR SPECIALTIES -->
    <div class="section-container">
        <div class="section-header">
            <h2 class="section-title">Explore Medical Specialties</h2>
            <p class="section-desc">Consult with experienced doctors across all major departments</p>
        </div>

        <div class="specialties-grid">
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-stethoscope"></i></div>
                <div class="spec-name">General Physician</div>
            </a>
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-heart-pulse"></i></div>
                <div class="spec-name">Cardiology</div>
            </a>
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-brain"></i></div>
                <div class="spec-name">Neurology</div>
            </a>
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-child"></i></div>
                <div class="spec-name">Pediatrics</div>
            </a>
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-bone"></i></div>
                <div class="spec-name">Orthopedics</div>
            </a>
            <a href="patient/dashboard.jsp" class="spec-card">
                <div class="spec-icon"><i class="fa-solid fa-virus"></i></div>
                <div class="spec-name">Dermatology</div>
            </a>
        </div>
    </div>

    <!-- HOW IT WORKS -->
    <div class="section-container">
        <div class="section-header">
            <h2 class="section-title">How Online Consultation Works</h2>
            <p class="section-desc">Get quality healthcare in 3 simple steps</p>
        </div>

        <div class="workflow-grid">
            <div class="work-card">
                <div class="work-number">1</div>
                <h3 style="font-size:1.1rem; font-weight:800; margin-bottom:0.5rem;">Select Specialist</h3>
                <p style="font-size:0.88rem; color:var(--text-muted);">Choose a certified doctor based on specialty, rating, or language preference.</p>
            </div>
            <div class="work-card">
                <div class="work-number">2</div>
                <h3 style="font-size:1.1rem; font-weight:800; margin-bottom:0.5rem;">Instant Video Call</h3>
                <p style="font-size:0.88rem; color:var(--text-muted);">Connect via encrypted video or voice call right from your browser or phone.</p>
            </div>
            <div class="work-card">
                <div class="work-number">3</div>
                <h3 style="font-size:1.1rem; font-weight:800; margin-bottom:0.5rem;">Get Prescription</h3>
                <p style="font-size:0.88rem; color:var(--text-muted);">Receive digital prescriptions and diagnostic lab orders instantly in your portal.</p>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer>
        <div class="footer-container">
            <div class="footer-brand"><i class="fa-solid fa-heart-pulse"></i> HealthConsult</div>
            <div style="display:flex; gap:1.5rem; font-size:0.9rem;">
                <a href="patient/dashboard.jsp" style="color:#94a3b8; text-decoration:none;">Patient Portal</a>
                <a href="doctor/dashboard.jsp" style="color:#94a3b8; text-decoration:none;">Doctor Portal</a>
                <a href="#" style="color:#94a3b8; text-decoration:none;">Privacy Policy</a>
            </div>
        </div>
        <div class="footer-copy">© 2026 HealthConsult Platform. All rights reserved.</div>
    </footer>

</body>
</html>
