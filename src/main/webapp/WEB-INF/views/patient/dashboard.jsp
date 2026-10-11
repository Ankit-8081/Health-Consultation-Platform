<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Patient dashboard" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <section class="page-banner">
        <div>
            <h1>Hello, <c:out value="${sessionScope.userName}" />!</h1>
            <p>Book a consultation, check your appointments and keep track of your health in one place.</p>
            <p><a class="btn-primary btn-inline" href="${pageContext.request.contextPath}/patient/book"><i class="fa-solid fa-stethoscope" aria-hidden="true"></i> Book new consultation</a></p>
        </div>
        <div class="banner-art" aria-hidden="true"><i class="fa-solid fa-user-doctor"></i></div>
    </section>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <div class="stat-grid">
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-calendar-check"></i></span>
            <div><p class="stat-label">Upcoming appointments</p><p class="stat-value">2</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon stat-icon-success" aria-hidden="true"><i class="fa-solid fa-file-prescription"></i></span>
            <div><p class="stat-label">Advice received</p><p class="stat-value">4</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-file-medical"></i></span>
            <div><p class="stat-label">Health records</p><p class="stat-value">3</p></div>
        </div>
    </div>

    <section class="card section-gap">
        <div class="card-head">
            <h2 class="card-title"><i class="fa-solid fa-calendar-days" aria-hidden="true"></i> My upcoming appointments</h2>
            <span><span class="sample-tag">Sample data</span> <a href="${pageContext.request.contextPath}/patient/appointments">View all bookings</a></span>
        </div>
        <div class="table-wrap">
            <table class="table">
                <caption class="visually-hidden">Sample upcoming appointments</caption>
                <thead><tr><th scope="col">Doctor</th><th scope="col">Specialty</th><th scope="col">Date and time</th><th scope="col">Status</th></tr></thead>
                <tbody>
                    <tr>
                        <td><span class="person"><span class="avatar avatar-sm" aria-hidden="true">AV</span> Dr. Asha Verma</span></td>
                        <td>General Physician</td><td>12 Oct 2026, 09:30</td>
                        <td><span class="pill pill-success">Booked</span></td>
                    </tr>
                    <tr>
                        <td><span class="person"><span class="avatar avatar-sm" aria-hidden="true">RM</span> Dr. Rohan Mehta</span></td>
                        <td>Dermatologist</td><td>14 Oct 2026, 14:00</td>
                        <td><span class="pill pill-warning">Pending</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>

    <section class="card">
        <h2 class="card-title"><i class="fa-solid fa-user-doctor" aria-hidden="true"></i> Consult our specialists</h2>
        <div class="specialist-grid">
            <div class="specialist-card">
                <span class="avatar avatar-lg" aria-hidden="true">AV</span>
                <h3>Dr. Asha Verma</h3><p>General Physician, 8 years</p>
                <a class="btn-outline" href="${pageContext.request.contextPath}/patient/book">Consult now</a>
            </div>
            <div class="specialist-card">
                <span class="avatar avatar-lg" aria-hidden="true">RM</span>
                <h3>Dr. Rohan Mehta</h3><p>Dermatologist, 5 years</p>
                <a class="btn-outline" href="${pageContext.request.contextPath}/patient/book">Consult now</a>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
