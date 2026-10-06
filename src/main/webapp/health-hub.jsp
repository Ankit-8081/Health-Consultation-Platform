<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Hub | MediBuddy vHealth</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-purple: #6b3ba7;
            --primary-red: #d92528;
            --primary-blue: #007670;
            --bg-light: #f4f6f9;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Plus Jakarta Sans", sans-serif; }
        body { background-color: #f8fafc; color: var(--text-dark); }

        /* HEADER & NAVBAR */
        header { background: #ffffff; border-bottom: 1px solid var(--border-color); padding: 1rem 5%; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 10px rgba(0,0,0,0.03); }
        .brand-logo { display: flex; align-items: center; gap: 0.5rem; text-decoration: none; }
        .logo-symbol { font-size: 1.8rem; color: var(--primary-red); font-weight: 800; }
        .logo-text { font-size: 1.5rem; font-weight: 800; color: var(--primary-red); line-height: 1.1; }
        .logo-text span { display: block; font-size: 1.1rem; color: var(--primary-purple); font-weight: 700; }
        .nav-links { display: flex; align-items: center; gap: 1.5rem; list-style: none; }
        .nav-links a { text-decoration: none; color: #475569; font-weight: 600; font-size: 0.95rem; transition: color 0.2s; }
        .nav-links a:hover { color: var(--primary-purple); }

        /* QUICK SERVICES BAR (MEDIBUDDY ICONS) */
        .services-bar { background: #ffffff; padding: 1.5rem 5%; display: flex; justify-content: center; gap: 2.5rem; flex-wrap: wrap; border-bottom: 1px solid var(--border-color); }
        .service-item { display: flex; flex-direction: column; align-items: center; gap: 0.5rem; cursor: pointer; text-decoration: none; width: 100px; text-align: center; }
        .service-icon { width: 56px; height: 56px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: var(--primary-purple); transition: transform 0.2s, background 0.2s; }
        .service-item:hover .service-icon { transform: translateY(-4px); background: #e0e7ff; }
        .service-label { font-size: 0.85rem; font-weight: 700; color: #334155; line-height: 1.2; }

        /* BANNER CONSULT CTA */
        .consult-cta-banner { max-width: 1100px; margin: 1.5rem auto; background: #ffffff; border-radius: 50px; padding: 1rem 2.5rem; border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 15px rgba(0,0,0,0.04); }
        .consult-cta-banner h3 { font-size: 1.2rem; font-weight: 800; color: #1e1b4b; }
        .btn-consult { background: #ffffff; border: 1px solid var(--border-color); color: #2563eb; padding: 0.6rem 1.5rem; border-radius: 25px; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 0.5rem; transition: background 0.2s; }
        .btn-consult:hover { background: #f0f7ff; }

        /* PURPLE HEALTH HUB HEADER */
        .health-hub-header { background: var(--primary-purple); padding: 3rem 1rem; text-align: center; color: #ffffff; margin-top: 1rem; }
        .health-hub-title { font-size: 3rem; font-weight: 900; letter-spacing: 2px; border: 3px solid #ffffff; display: inline-block; padding: 0.25rem 2rem; font-family: serif; text-transform: uppercase; }

        /* MAIN HUB CONTAINER */
        .hub-container { max-width: 1200px; margin: -2rem auto 3rem auto; background: #ffffff; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); padding: 2rem; }

        /* TAB NAVIGATION */
        .hub-tabs { display: flex; border-bottom: 2px solid var(--border-color); margin-bottom: 2rem; overflow-x: auto; }
        .tab-btn { padding: 0.85rem 1.5rem; background: none; border: none; font-size: 0.95rem; font-weight: 700; color: #64748b; cursor: pointer; border-bottom: 3px solid transparent; transition: all 0.2s; white-space: nowrap; }
        .tab-btn.active { background: var(--primary-purple); color: #ffffff; border-radius: 6px 6px 0 0; }
        .tab-btn:hover:not(.active) { color: var(--primary-purple); }

        /* GRID CONTENT LAYOUT */
        .grid-main { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2.5rem; }
        .grid-card { border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; background: #fff; display: flex; flex-direction: column; }
        .grid-card img { width: 100%; height: 260px; object-fit: cover; }
        .card-body { padding: 1.5rem; flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .card-tag { display: inline-block; background: #f3e8ff; color: var(--primary-purple); font-size: 0.75rem; font-weight: 800; padding: 0.25rem 0.6rem; border-radius: 4px; margin-bottom: 0.75rem; text-transform: uppercase; }
        .card-title { font-size: 1.25rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem; line-height: 1.3; }
        .card-desc { font-size: 0.9rem; color: var(--text-muted); line-height: 1.6; margin-bottom: 1rem; }
        .card-link { color: var(--primary-purple); font-weight: 700; text-decoration: none; font-size: 0.9rem; display: flex; align-items: center; gap: 0.35rem; }

        /* EXPERT CARE SECTION (CANNER / HEART) */
        .expert-care-banner { background: #fff7ed; border: 1px solid #ffedd5; border-radius: 16px; padding: 2rem; display: grid; grid-template-columns: 1fr 1.2fr; gap: 2rem; align-items: center; margin-top: 2rem; }
        .care-procedures { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
        .proc-box { background: #ffffff; border: 1px solid #fed7aa; border-radius: 10px; padding: 0.85rem; text-align: center; }
        .proc-box img { width: 45px; height: 45px; object-fit: contain; margin-bottom: 0.5rem; }
        .proc-box p { font-size: 0.8rem; font-weight: 700; color: #9a3412; }
        .expert-info h2 { font-size: 1.75rem; font-weight: 800; color: #7c2d12; margin-bottom: 0.75rem; }
        .expert-info p { font-size: 0.95rem; color: #9a3412; margin-bottom: 1.25rem; line-height: 1.5; }
        .btn-care { background: #ea580c; color: #ffffff; padding: 0.75rem 1.5rem; border-radius: 8px; font-weight: 700; text-decoration: none; display: inline-block; }

        footer { text-align: center; padding: 2rem; color: var(--text-muted); font-size: 0.85rem; border-top: 1px solid var(--border-color); background: #fff; margin-top: 3rem; }
    </style>
</head>
<body>

    <!-- TOP NAVIGATION NAVBAR -->
    <header>
        <a href="#" class="brand-logo">
            <i class="fa-solid fa-square-plus logo-symbol"></i>
            <div class="logo-text">MediBuddy <span>vHealth</span></div>
        </a>
        <ul class="nav-links">
            <li><a href="patient/dashboard.jsp">Home</a></li>
            <li><a href="#">About Us</a></li>
            <li><a href="#">Contact us</a></li>
            <li><a href="index.jsp" style="color: var(--primary-purple); font-weight: 800;">Login</a></li>
        </ul>
    </header>

    <!-- MEDIBUDDY QUICK SERVICES BAR -->
    <div class="services-bar">
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-stethoscope"></i></div>
            <span class="service-label">Talk to Doctor</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-pills"></i></div>
            <span class="service-label">Medicine</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-hospital-user"></i></div>
            <span class="service-label">Book Dr. Appointment</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-vial-virus"></i></div>
            <span class="service-label">Lab Test & Packages</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-user-nurse"></i></div>
            <span class="service-label">Surgery</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon" style="color:#d97706; background:#fef3c7;"><i class="fa-solid fa-crown"></i></div>
            <span class="service-label" style="color:#b45309;">MediBuddy GOLD</span>
        </a>
        <a href="#" class="service-item">
            <div class="service-icon"><i class="fa-solid fa-ellipsis"></i></div>
            <span class="service-label">More</span>
        </a>
    </div>

    <!-- CONSULT CTA BANNER -->
    <div class="consult-cta-banner">
        <h3>Consult with Top Doctors Online, 24x7</h3>
        <a href="#" class="btn-consult">Start Consultation <i class="fa-solid fa-arrow-right"></i></a>
    </div>

    <!-- PURPLE HEALTH HUB HEADER SECTION -->
    <div class="health-hub-header">
        <div class="health-hub-title">HEALTH HUB</div>
    </div>

    <!-- MAIN HEALTH HUB CONTENT BOARD -->
    <div class="hub-container">
        
        <!-- TABS BAR -->
        <div class="hub-tabs">
            <button class="tab-btn active">Food & Nutrition</button>
            <button class="tab-btn">Myth & Fact</button>
            <button class="tab-btn">Preventive health</button>
            <button class="tab-btn">Stay Fit</button>
            <button class="tab-btn">Wellness</button>
            <button class="tab-btn">Featured</button>
        </div>

        <!-- MAIN FEATURED ARTICLES GRID -->
        <div class="grid-main">
            <!-- Article Card 1 -->
            <div class="grid-card">
                <img src="https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&auto=format&fit=crop&q=80" alt="Medication & Supplements">
                <div class="card-body">
                    <div>
                        <span class="card-tag">Food & Nutrition</span>
                        <h3 class="card-title">Understanding Dietary Supplements vs. Natural Nutrition</h3>
                        <p class="card-desc">Learn how daily nutritional intake influences overall vitality and when doctor-prescribed vitamins or medical supplements are recommended for family health maintenance.</p>
                    </div>
                    <a href="#" class="card-link">Read Full Article <i class="fa-solid fa-chevron-right"></i></a>
                </div>
            </div>

            <!-- Article Card 2 -->
            <div class="grid-card">
                <img src="https://images.unsplash.com/photo-1543362906-acfc16c67564?w=800&auto=format&fit=crop&q=80" alt="Family Healthy Meals">
                <div class="card-body">
                    <div>
                        <span class="card-tag">Family Wellness</span>
                        <h3 class="card-title">Building Balanced Meals for Every Stage of Life</h3>
                        <p class="card-desc">Practical guidance on optimizing macronutrient intake, improving digestive health, and keeping family members active through proper meal planning and dietary choices.</p>
                    </div>
                    <a href="#" class="card-link">Read Full Article <i class="fa-solid fa-chevron-right"></i></a>
                </div>
            </div>
        </div>

        <!-- EXPERT CARE SECTION (HEART & CANCER SPECIALTIES) -->
        <div class="expert-care-banner">
            <div class="care-procedures">
                <div class="proc-box">
                    <i class="fa-solid fa-heart-pulse" style="font-size: 2rem; color: #dc2626; margin-bottom: 0.5rem;"></i>
                    <p>Angioplasty Stenting</p>
                </div>
                <div class="proc-box">
                    <i class="fa-solid fa-ribbon" style="font-size: 2rem; color: #e11d48; margin-bottom: 0.5rem;"></i>
                    <p>Cancer Treatment</p>
                </div>
                <div class="proc-box">
                    <i class="fa-solid fa-radiation" style="font-size: 2rem; color: #ea580c; margin-bottom: 0.5rem;"></i>
                    <p>Radiation Therapy</p>
                </div>
                <div class="proc-box">
                    <i class="fa-solid fa-file-waveform" style="font-size: 2rem; color: #0284c7; margin-bottom: 0.5rem;"></i>
                    <p>Coronary Angiogram</p>
                </div>
                <div class="proc-box">
                    <i class="fa-solid fa-heart-circle-check" style="font-size: 2rem; color: #16a34a; margin-bottom: 0.5rem;"></i>
                    <p>Heart Surgery</p>
                </div>
                <div class="proc-box">
                    <i class="fa-solid fa-vial" style="font-size: 2rem; color: #9333ea; margin-bottom: 0.5rem;"></i>
                    <p>Chemotherapy</p>
                </div>
            </div>

            <div class="expert-info">
                <h2>Get Expert Care for Heart and Cancer Conditions</h2>
                <p>Access top tier surgical specialists, advanced oncological consultations, and comprehensive cardiac care packages tailored for your recovery.</p>
                <a href="#" class="btn-care">FIND CARE NOW <i class="fa-solid fa-chevron-right"></i></a>
            </div>
        </div>

    </div>

    <footer>
        &copy; 2026 HealthConsult / MediBuddy vHealth. All rights reserved.
    </footer>

</body>
</html>
