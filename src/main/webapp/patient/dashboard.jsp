<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Portal | HealthConsult</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #007670; --bg-body: #f8fafc; --sidebar-bg: #0f172a; --card-bg: #ffffff; --text-main: #0f172a; --text-muted: #64748b; --border: #e2e8f0; }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Plus Jakarta Sans", sans-serif; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-body); color: var(--text-main); }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #fff; padding: 1.5rem 1rem; display: flex; flex-direction: column; justify-content: space-between; }
        .brand { display: flex; align-items: center; gap: 0.75rem; padding: 0.5rem 0.75rem; margin-bottom: 2rem; color: #2dd4bf; font-size: 1.25rem; font-weight: 800; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 0.35rem; }
        .nav-link { display: flex; align-items: center; gap: 0.85rem; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 8px; font-size: 0.9rem; font-weight: 600; }
        .nav-link.active { background-color: var(--primary); color: #fff; }
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        header { background: var(--card-bg); border-bottom: 1px solid var(--border); padding: 1.25rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .content { padding: 2rem; max-width: 1400px; margin: 0 auto; width: 100%; }
        
        /* Realistic Full Hero Banner */
        .hero-banner { position: relative; border-radius: 16px; overflow: hidden; height: 320px; margin-bottom: 2.5rem; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); }
        .hero-bg { width: 100%; height: 100%; object-fit: cover; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(90deg, rgba(15,23,42,0.85) 0%, rgba(15,23,42,0.3) 70%, rgba(15,23,42,0) 100%); display: flex; flex-direction: column; justify-content: center; padding: 0 3rem; color: #fff; }
        .hero-overlay h2 { font-size: 2.25rem; font-weight: 800; line-height: 1.2; margin-bottom: 0.75rem; max-width: 600px; }
        .hero-overlay p { font-size: 1.05rem; color: #e2e8f0; max-width: 520px; margin-bottom: 1.5rem; line-height: 1.5; }
        .btn-banner { background: #007670; color: #fff; padding: 0.85rem 1.75rem; border-radius: 8px; font-weight: 700; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; width: fit-content; transition: background 0.2s; }
        .btn-banner:hover { background: #005a55; }

        /* Vision Split Grid */
        .section-title { font-size: 1.35rem; font-weight: 800; margin-bottom: 1.25rem; color: #0f172a; }
        .grid-2col { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem; }
        .vision-card { background: #fff; border: 1px solid var(--border); border-radius: 14px; overflow: hidden; display: flex; flex-direction: column; }
        .vision-img { width: 100%; height: 220px; object-fit: cover; }
        .vision-body { padding: 1.5rem; }
        .vision-body h3 { font-size: 1.15rem; font-weight: 700; margin-bottom: 0.5rem; color: #0f172a; }
        .vision-body p { font-size: 0.9rem; color: var(--text-muted); line-height: 1.6; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div>
            <div class="brand"><i class="fa-solid fa-heart-pulse"></i><span>HealthConsult</span></div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="#" class="nav-link active"><i class="fa-solid fa-house"></i> Home</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-user-doctor"></i> Find Doctors</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-calendar-check"></i> Consultations</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-file-medical"></i> Health Records</a></li>
            </ul>
        </div>
    </aside>

    <div class="main-wrapper">
        <header>
            <div>
                <h1 style="font-size: 1.4rem; font-weight:800;">Patient Portal</h1>
                <p style="font-size:0.875rem; color:var(--text-muted);">Empowering families to live healthier lives</p>
            </div>
        </header>

        <main class="content">
            <!-- Main Realistic Banner -->
            <div class="hero-banner">
                <img src="https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1600&auto=format&fit=crop&q=80" class="hero-bg" alt="Wellness and Health">
                <div class="hero-overlay">
                    <h2>Empowering families to live healthier lives</h2>
                    <p>Connect with top certified medical professionals, book consultations, and stay healthy at every stage of your journey.</p>
                    <a href="#" class="btn-banner"><i class="fa-solid fa-calendar-plus"></i> Schedule Consultation</a>
                </div>
            </div>

            <h2 class="section-title">Healthcare Partnering & Wellness</h2>

            <!-- Dual Real Photography Cards -->
            <div class="grid-2col">
                <div class="vision-card">
                    <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&auto=format&fit=crop&q=80" class="vision-img" alt="Medical Consultation">
                    <div class="vision-body">
                        <h3>In-Person & Online Consultation</h3>
                        <p>Our goal is to be the healthcare partner for our members around the world, providing seamless access to specialists when you need them most.</p>
                    </div>
                </div>

                <div class="vision-card">
                    <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&auto=format&fit=crop&q=80" class="vision-img" alt="Doctor Client Discussion">
                    <div class="vision-body">
                        <h3>Personalized Medical Care</h3>
                        <p>Work directly with doctors who tailor treatment plans around your family individual health requirements and lifestyle goals.</p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
