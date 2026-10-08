<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="My appointments" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <h1>My appointments</h1>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <section class="card">
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
