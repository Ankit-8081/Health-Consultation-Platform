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

        .hero-banner { position: relative; border-radius: 16px; overflow: hidden; height: 280px; margin-bottom: 2rem; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); }
        .hero-bg { width: 100%; height: 100%; object-fit: cover; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(90deg, rgba(15,23,42,0.85) 0%, rgba(15,23,42,0.4) 70%, rgba(15,23,42,0) 100%); display: flex; flex-direction: column; justify-content: center; padding: 0 3rem; color: #fff; }
        .hero-overlay h2 { font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; }
        .hero-overlay p { font-size: 1rem; color: #e2e8f0; max-width: 500px; }

        .grid-2col { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; }
        .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; }
        .doctor-banner-card { display: flex; gap: 1.25rem; align-items: center; background: #fff; border: 1px solid var(--border); border-radius: 12px; padding: 1rem; margin-bottom: 1rem; }
        .doctor-banner-card img { width: 120px; height: 120px; border-radius: 10px; object-fit: cover; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div>
            <div class="brand"><i class="fa-solid fa-user-doctor"></i><span>Doctor Portal</span></div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="#" class="nav-link active"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-calendar-days"></i> Appointments</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-user-injured"></i> Patients</a></li>
            </ul>
        </div>
    </aside>

    <div class="main-wrapper">
        <header>
            <div>
                <h1 style="font-size: 1.4rem; font-weight:800;">Clinical Dashboard</h1>
                <p style="font-size:0.875rem; color:var(--text-muted);">Welcome back, Dr. Sarah Jenkins</p>
            </div>
        </header>

        <main class="content">
            <div class="hero-banner">
                <img src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=1600&auto=format&fit=crop&q=80" class="hero-bg" alt="Clinical Practice">
                <div class="hero-overlay">
                    <h2>Delivering Quality Care Anywhere</h2>
                    <p>Manage patient visits, conduct online consultations, and review diagnostic charts seamlessly.</p>
                </div>
            </div>

            <div class="grid-2col">
                <div class="card">
                    <h3 style="font-size: 1.1rem; font-weight:700; margin-bottom: 1rem;">Scheduled Consultations</h3>
                    
                    <div class="doctor-banner-card">
                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80" alt="Patient Jannat">
                        <div>
                            <h4 style="font-size: 1rem; font-weight:700;">Jannat</h4>
                            <p style="font-size: 0.85rem; color: var(--text-muted); margin: 0.25rem 0;">Routine Cardiology Checkup & ECG Assessment</p>
                            <span style="background:#dcfce7; color:#15803d; padding:0.2rem 0.6rem; border-radius:6px; font-weight:700; font-size:0.75rem;">10:00 AM Today</span>
                        </div>
                    </div>

                    <div class="doctor-banner-card">
                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80" alt="Patient Rahul">
                        <div>
                            <h4 style="font-size: 1rem; font-weight:700;">Rahul Sharma</h4>
                            <p style="font-size: 0.85rem; color: var(--text-muted); margin: 0.25rem 0;">Follow-up Consultation on Blood Pressure</p>
                            <span style="background:#dcfce7; color:#15803d; padding:0.2rem 0.6rem; border-radius:6px; font-weight:700; font-size:0.75rem;">11:15 AM Today</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h3 style="font-size: 1.1rem; font-weight:700; margin-bottom: 1rem;">Clinical Notes</h3>
                    <img src="https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=500&auto=format&fit=crop&q=80" style="width:100%; height:180px; object-fit:cover; border-radius:8px; margin-bottom:1rem;" alt="Doctor Workstation">
                    <p style="font-size:0.875rem; color:var(--text-muted);">Ensure all digital prescriptions are signed and uploaded prior to concluding video sessions.</p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
