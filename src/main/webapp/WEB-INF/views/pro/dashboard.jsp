<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Professional dashboard" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <section class="page-banner">
        <div>
            <h1>Welcome back, <c:out value="${sessionScope.userName}" />!</h1>
            <p>See today's consultations and keep your working hours up to date so patients can book you.</p>
            <p><a class="btn-primary btn-inline" href="${pageContext.request.contextPath}/pro/schedule"><i class="fa-solid fa-calendar-plus" aria-hidden="true"></i> Manage availability</a></p>
        </div>
        <div class="banner-art" aria-hidden="true"><i class="fa-solid fa-stethoscope"></i></div>
    </section>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <div class="stat-grid">
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-calendar-check"></i></span>
            <div><p class="stat-label">Today's appointments</p><p class="stat-value">8</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon stat-icon-success" aria-hidden="true"><i class="fa-solid fa-clipboard-check"></i></span>
            <div><p class="stat-label">Upcoming consultations</p><p class="stat-value">5</p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-user-clock"></i></span>
            <div><p class="stat-label">New bookings</p><p class="stat-value">3</p></div>
        </div>
    </div>

    <section class="card">
        <div class="card-head">
            <h2 class="card-title"><i class="fa-solid fa-list-ul" aria-hidden="true"></i> Today's appointment queue</h2>
            <span class="sample-tag">Sample data</span>
        </div>
        <div class="table-wrap">
            <table class="table">
                <caption class="visually-hidden">Sample appointment queue for today</caption>
                <thead><tr><th scope="col">Time</th><th scope="col">Patient</th><th scope="col">Reason</th><th scope="col">Status</th></tr></thead>
                <tbody>
                    <tr>
                        <td>10:00 - 10:30</td>
                        <td><span class="person"><span class="avatar avatar-sm" aria-hidden="true">PS</span> Priya Sharma</span></td>
                        <td>Recurring headache</td><td><span class="pill pill-success">Booked</span></td>
                    </tr>
                    <tr>
                        <td>11:00 - 11:30</td>
                        <td><span class="person"><span class="avatar avatar-sm" aria-hidden="true">AS</span> Arjun Singh</span></td>
                        <td>Seasonal cold and cough</td><td><span class="pill pill-success">Booked</span></td>
                    </tr>
                    <tr>
                        <td>14:00 - 14:30</td>
                        <td><span class="person"><span class="avatar avatar-sm" aria-hidden="true">NG</span> Neha Gupta</span></td>
                        <td>Skin rash on forearm</td><td><span class="pill pill-warning">Pending</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
