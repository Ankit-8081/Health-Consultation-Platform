<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Admin dashboard" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <section class="page-banner">
        <div>
            <h1>Admin control center</h1>
            <p>Review professionals and keep an eye on how the platform is being used.</p>
        </div>
        <div class="banner-art" aria-hidden="true"><i class="fa-solid fa-shield-halved"></i></div>
    </section>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <div class="stat-grid">
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-users"></i></span>
            <div><p class="stat-label">Registered users</p><p class="stat-value">6</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon stat-icon-success" aria-hidden="true"><i class="fa-solid fa-user-doctor"></i></span>
            <div><p class="stat-label">Professionals</p><p class="stat-value">2</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-calendar-check"></i></span>
            <div><p class="stat-label">Active bookings</p><p class="stat-value">2</p></div>
        </div>
    </div>

    <div class="two-col">
        <section class="card">
            <div class="card-head">
                <h2 class="card-title"><i class="fa-solid fa-user-check" aria-hidden="true"></i> Pending doctor approvals</h2>
                <span class="sample-tag">Sample data</span>
            </div>
            <div class="approval">
                <span class="avatar avatar-lg" aria-hidden="true">MV</span>
                <div>
                    <h3>Dr. Manoj Verma</h3>
                    <p>Neurology, license MED-99201</p>
                    <div class="approval-actions">
                        <button type="button" class="btn-success-soft" disabled title="Available in Review 2">Approve</button>
                        <button type="button" class="btn-danger-soft" disabled title="Available in Review 2">Reject</button>
                    </div>
                </div>
            </div>
            <div class="approval">
                <span class="avatar avatar-lg" aria-hidden="true">AR</span>
                <div>
                    <h3>Dr. Ananya Roy</h3>
                    <p>Dermatology, license MED-88312</p>
                    <div class="approval-actions">
                        <button type="button" class="btn-success-soft" disabled title="Available in Review 2">Approve</button>
                        <button type="button" class="btn-danger-soft" disabled title="Available in Review 2">Reject</button>
                    </div>
                </div>
            </div>
        </section>

        <section class="card">
            <h2 class="card-title"><i class="fa-solid fa-clipboard-list" aria-hidden="true"></i> Verification guidelines</h2>
            <ul class="note-list">
                <li>Check the medical registration number against the state council registry.</li>
                <li>Confirm the qualification and years of experience on the profile.</li>
                <li>Professionals are created by an administrator. Public registration is for patients only.</li>
            </ul>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
