<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="My schedule" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <h1>My working hours</h1>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <section class="card section-gap" aria-labelledby="add-hours-title">
        <h2 id="add-hours-title">Add working hours</h2>
        <form action="${pageContext.request.contextPath}/pro/schedule" method="post" class="form-row">
            <div class="form-group">
                <label for="day">Day</label>
                <select id="day" name="day" required
                        class="${not empty errors.day ? 'input-error' : ''}"
                        <c:if test="${not empty errors.day}">aria-invalid="true" aria-describedby="day-error"</c:if>>
                    <option value="" disabled <c:if test="${empty form.day}">selected</c:if>>Choose a day</option>
                    <option value="1" <c:if test="${form.day == '1'}">selected</c:if>>Monday</option>
                    <option value="2" <c:if test="${form.day == '2'}">selected</c:if>>Tuesday</option>
                    <option value="3" <c:if test="${form.day == '3'}">selected</c:if>>Wednesday</option>
                    <option value="4" <c:if test="${form.day == '4'}">selected</c:if>>Thursday</option>
                    <option value="5" <c:if test="${form.day == '5'}">selected</c:if>>Friday</option>
                    <option value="6" <c:if test="${form.day == '6'}">selected</c:if>>Saturday</option>
                    <option value="7" <c:if test="${form.day == '7'}">selected</c:if>>Sunday</option>
                </select>
                <c:if test="${not empty errors.day}">
                    <span id="day-error" class="field-error" role="alert"><c:out value="${errors.day}" /></span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="start">Start time</label>
                <input type="time" id="start" name="start" required value="<c:out value='${form.start}' />"
                       class="${not empty errors.start ? 'input-error' : ''}"
                       <c:if test="${not empty errors.start}">aria-invalid="true" aria-describedby="start-error"</c:if>>
                <c:if test="${not empty errors.start}">
                    <span id="start-error" class="field-error" role="alert"><c:out value="${errors.start}" /></span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="end">End time</label>
                <input type="time" id="end" name="end" required value="<c:out value='${form.end}' />"
                       class="${not empty errors.end ? 'input-error' : ''}"
                       <c:if test="${not empty errors.end}">aria-invalid="true" aria-describedby="end-error"</c:if>>
                <c:if test="${not empty errors.end}">
                    <span id="end-error" class="field-error" role="alert"><c:out value="${errors.end}" /></span>
                </c:if>
            </div>
            <div class="form-group form-action">
                <button type="submit" class="btn-primary">Save hours</button>
            </div>
        </form>
    </section>

    <section class="card" aria-labelledby="hours-title">
        <h2 id="hours-title">Your weekly hours</h2>
        <c:choose>
            <c:when test="${empty hours}">
                <p class="empty-state">You have not set any working hours yet. Add your first block above.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="table">
                        <caption class="visually-hidden">Weekly working hours</caption>
                        <thead>
                            <tr><th scope="col">Day</th><th scope="col">From</th><th scope="col">To</th><th scope="col">Action</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${hours}">
                                <tr>
                                    <td><c:out value="${h.dayName}" /></td>
                                    <td><c:out value="${h.startTime}" /></td>
                                    <td><c:out value="${h.endTime}" /></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/pro/schedule" method="post" class="inline-form">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="availabilityId" value="${h.availabilityId}">
                                            <button type="submit" class="btn-danger">Remove</button>
                                        </form>
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
