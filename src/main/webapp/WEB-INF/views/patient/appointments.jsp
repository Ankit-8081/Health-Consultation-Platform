<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="My appointments" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <section class="page-banner">
        <div>
            <h1>My appointments</h1>
            <p>Your upcoming and past consultations. You can cancel an upcoming one before the cut-off time.</p>
        </div>
        <a class="btn-primary btn-inline" href="${pageContext.request.contextPath}/patient/book"><i class="fa-solid fa-stethoscope" aria-hidden="true"></i> Book new consultation</a>
    </section>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <c:set var="nBooked" value="0" />
    <c:set var="nDone" value="0" />
    <c:set var="nCancelled" value="0" />
    <c:forEach var="a" items="${appointments}">
        <c:choose>
            <c:when test="${a.status == 'BOOKED'}"><c:set var="nBooked" value="${nBooked + 1}" /></c:when>
            <c:when test="${a.status == 'COMPLETED'}"><c:set var="nDone" value="${nDone + 1}" /></c:when>
            <c:otherwise><c:set var="nCancelled" value="${nCancelled + 1}" /></c:otherwise>
        </c:choose>
    </c:forEach>
    <div class="stat-grid">
        <div class="stat-card">
            <span class="stat-icon" aria-hidden="true"><i class="fa-solid fa-calendar-check"></i></span>
            <div><p class="stat-label">Upcoming</p><p class="stat-value"><c:out value="${nBooked}" /></p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon stat-icon-success" aria-hidden="true"><i class="fa-solid fa-circle-check"></i></span>
            <div><p class="stat-label">Completed</p><p class="stat-value"><c:out value="${nDone}" /></p></div>
        </div>
        <div class="stat-card">
            <span class="stat-icon stat-icon-danger" aria-hidden="true"><i class="fa-solid fa-ban"></i></span>
            <div><p class="stat-label">Cancelled</p><p class="stat-value"><c:out value="${nCancelled}" /></p></div>
        </div>
    </div>

    <section class="card">
        <h2 class="card-title"><i class="fa-solid fa-calendar-days" aria-hidden="true"></i> All appointments</h2>
        <c:choose>
            <c:when test="${empty appointments}">
                <p class="empty-state">No appointments yet.
                    <a href="${pageContext.request.contextPath}/patient/book">Book your first consultation.</a></p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="table">
                        <caption class="visually-hidden">Your appointments</caption>
                        <thead>
                            <tr>
                                <th scope="col">Date</th><th scope="col">Time</th><th scope="col">Professional</th>
                                <th scope="col">Reason</th><th scope="col">Status</th><th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${appointments}">
                                <tr>
                                    <td><c:out value="${a.date}" /></td>
                                    <td><c:out value="${a.startTime}" /> - <c:out value="${a.endTime}" /></td>
                                    <td><c:out value="${a.professionalName}" /></td>
                                    <td><c:out value="${a.reason}" /></td>
                                    <td><span class="badge badge-${a.status}"><c:out value="${a.status}" /></span></td>
                                    <td>
                                        <c:if test="${a.status == 'BOOKED'}">
                                            <form action="${pageContext.request.contextPath}/patient/appointments/cancel" method="post" class="inline-form">
                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                <button type="submit" class="btn-danger">Cancel</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
