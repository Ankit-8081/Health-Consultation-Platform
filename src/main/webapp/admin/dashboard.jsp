<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | HealthConsult</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #2563eb; --bg-body: #f8fafc; --sidebar-bg: #0f172a; --card-bg: #ffffff; --text-main: #0f172a; --text-muted: #64748b; --border: #e2e8f0; }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Plus Jakarta Sans", sans-serif; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-body); color: var(--text-main); }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #fff; padding: 1.5rem 1rem; display: flex; flex-direction: column; justify-content: space-between; }
        .brand { display: flex; align-items: center; gap: 0.75rem; padding: 0.5rem 0.75rem; margin-bottom: 2rem; color: #60a5fa; font-size: 1.25rem; font-weight: 800; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 0.35rem; }
        .nav-link { display: flex; align-items: center; gap: 0.85rem; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 8px; font-size: 0.9rem; font-weight: 600; }
        .nav-link.active { background-color: var(--primary); color: #fff; }
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        header { background: var(--card-bg); border-bottom: 1px solid var(--border); padding: 1.25rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .content { padding: 2rem; max-width: 1400px; margin: 0 auto; width: 100%; }

        .hero-banner { position: relative; border-radius: 16px; overflow: hidden; height: 260px; margin-bottom: 2rem; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); }
        .hero-bg { width: 100%; height: 100%; object-fit: cover; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(90deg, rgba(15,23,42,0.85) 0%, rgba(15,23,42,0.3) 70%, rgba(15,23,42,0) 100%); display: flex; flex-direction: column; justify-content: center; padding: 0 3rem; color: #fff; }
        .hero-overlay h2 { font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; }

        .grid-2col { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; }
        .verify-card { display: flex; gap: 1rem; align-items: center; padding: 1rem; border: 1px solid var(--border); border-radius: 10px; margin-bottom: 1rem; }
        .verify-card img { width: 70px; height: 70px; border-radius: 50%; object-fit: cover; }
        .btn-act { padding: 0.4rem 0.8rem; border-radius: 6px; font-weight: 700; border: none; cursor: pointer; font-size: 0.8rem; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div>
            <div class="brand"><i class="fa-solid fa-shield-halved"></i><span>Admin Console</span></div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="#" class="nav-link active"><i class="fa-solid fa-chart-pie"></i> Overview</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-user-doctor"></i> Doctor Verification</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-users"></i> Users</a></li>
            </ul>
        </div>
    </aside>

    <div class="main-wrapper">
        <header>
            <div>
                <h1 style="font-size: 1.4rem; font-weight:800;">Admin Control Center</h1>
                <p style="font-size:0.875rem; color:var(--text-muted);">Platform Verification & Operational Management</p>
            </div>
        </header>

        <main class="content">
            <div class="hero-banner">
                <img src="https://images.unsplash.com/photo-1516549655169-df83a0774514?w=1600&auto=format&fit=crop&q=80" class="hero-bg" alt="Healthcare Management">
                <div class="hero-overlay">
                    <h2>Global Healthcare Partner Network</h2>
                    <p style="color:#e2e8f0; font-size:0.95rem;">Review physician credentials and monitor system-wide healthcare operations.</p>
                </div>
            </div>

            <div class="grid-2col">
                <div class="card">
                    <h3 style="font-size: 1.1rem; font-weight:700; margin-bottom: 1rem;">Pending Doctor Approvals</h3>

                    <div class="verify-card">
                        <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=200&auto=format&fit=crop&q=80" alt="Dr. Manoj Verma">
                        <div>
                            <h4 style="font-size:0.95rem; font-weight:700;">Dr. Manoj Verma</h4>
                            <p style="font-size:0.8rem; color:var(--text-muted);">Neurology • License: MED-99201</p>
                            <div style="margin-top:0.5rem; display:flex; gap:0.5rem;">
                                <button class="btn-act" style="background:#dcfce7; color:#15803d;"><i class="fa-solid fa-check"></i> Approve</button>
                                <button class="btn-act" style="background:#fee2e2; color:#b91c1c;"><i class="fa-solid fa-xmark"></i> Reject</button>
                            </div>
                        </div>
                    </div>

                    <div class="verify-card">
                        <img src="https://images.unsplash.com/photo-1594824813566-78a933758f46?w=200&auto=format&fit=crop&q=80" alt="Dr. Ananya Roy">
                        <div>
                            <h4 style="font-size:0.95rem; font-weight:700;">Dr. Ananya Roy</h4>
                            <p style="font-size:0.8rem; color:var(--text-muted);">Dermatology • License: MED-88312</p>
                            <div style="margin-top:0.5rem; display:flex; gap:0.5rem;">
                                <button class="btn-act" style="background:#dcfce7; color:#15803d;"><i class="fa-solid fa-check"></i> Approve</button>
                                <button class="btn-act" style="background:#fee2e2; color:#b91c1c;"><i class="fa-solid fa-xmark"></i> Reject</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h3 style="font-size: 1.1rem; font-weight:700; margin-bottom: 1rem;">Verification Guidelines</h3>
                    <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600&auto=format&fit=crop&q=80" style="width:100%; height:180px; object-fit:cover; border-radius:8px; margin-bottom:1rem;" alt="Verification Standard">
                    <p style="font-size:0.875rem; color:var(--text-muted);">Cross-check medical registration numbers against state council registries before approving practitioner access.</p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
