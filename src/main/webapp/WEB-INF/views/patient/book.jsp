<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Book consultation" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <h1>Book a consultation</h1>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <section class="card section-gap" aria-labelledby="choose-title">
        <h2 id="choose-title">1. Choose a healthcare professional</h2>
        <form action="${pageContext.request.contextPath}/patient/book" method="get" class="form-row">
            <div class="form-group">
                <label for="professionalId">Professional</label>
                <select id="professionalId" name="professionalId" required>
                    <option value="" disabled <c:if test="${empty selectedProfessionalId}">selected</c:if>>Choose a professional</option>
                    <c:forEach var="p" items="${professionals}">
                        <option value="${p.id}" <c:if test="${p.id == selectedProfessionalId}">selected</c:if>>
                            <c:out value="${p.name}" /> (<c:out value="${p.specialization}" />)
                        </option>
                    </c:forEach>
                </select>
                <c:if test="${not empty errors.professionalId}">
                    <span class="field-error" role="alert"><c:out value="${errors.professionalId}" /></span>
                </c:if>
            </div>
            <div class="form-group form-action">
                <button type="submit" class="btn-primary">Show free slots</button>
            </div>
        </form>
    </section>

    <c:if test="${not empty selectedProfessionalId}">
        <section class="card" aria-labelledby="slots-title">
            <h2 id="slots-title">2. Pick a slot (next <c:out value="${daysShown}" /> days)</h2>
            <c:choose>
                <c:when test="${empty slots}">
                    <p class="empty-state">No free slots in the next <c:out value="${daysShown}" /> days. Try another professional.</p>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/patient/book" method="post">
                        <input type="hidden" name="professionalId" value="${selectedProfessionalId}">

                        <c:forEach var="entry" items="${slots}">
                            <fieldset class="slot-group">
                                <legend><c:out value="${entry.key}" /></legend>
                                <div class="slot-grid">
                                    <c:forEach var="slot" items="${entry.value}">
                                        <c:set var="slotValue" value="${entry.key}|${slot.start}" />
                                        <label class="slot-option">
                                            <input type="radio" name="slot" value="${slotValue}" required
                                                   <c:if test="${form.slot == slotValue}">checked</c:if>>
                                            <span><c:out value="${slot.start}" /> - <c:out value="${slot.end}" /></span>
                                        </label>
                                    </c:forEach>
                                </div>
                            </fieldset>
                        </c:forEach>
                        <c:if test="${not empty errors.slot}">
                            <span class="field-error" role="alert"><c:out value="${errors.slot}" /></span>
                        </c:if>

                        <div class="form-group">
                            <label for="reason">Reason for the visit</label>
                            <textarea id="reason" name="reason" rows="3" minlength="5" maxlength="255" required
                                      class="${not empty errors.reason ? 'input-error' : ''}"
                                      <c:if test="${not empty errors.reason}">aria-invalid="true" aria-describedby="reason-error"</c:if>><c:out value="${form.reason}" /></textarea>
                            <c:if test="${not empty errors.reason}">
                                <span id="reason-error" class="field-error" role="alert"><c:out value="${errors.reason}" /></span>
                            </c:if>
                        </div>

                        <button type="submit" class="btn-primary">Book appointment</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </c:if>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
