<%@taglib prefix="itrust" uri="/WEB-INF/tags.tld"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Ethnicity"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.BloodType"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Gender"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.DiagnosisBean"%>

<%@include file="/global.jsp"%>

<%
	pageTitle = "iTrust - Deactivate Patient";
%>

<%@include file="/header.jsp"%>
<itrust:patientNav thisTitle="Deactivate" />
<%
	/* Require a Patient ID first */
	String pidString = (String) session.getAttribute("pid");
	if (pidString == null || pidString.equals("") || 1 > pidString.length()) {
		out.println("pidstring is null");
		response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=admin/activatePatient.jsp");
		return;
	}
	
	/* If the patient id doesn't check out, then kick 'em out to the exception handler */
	EditPatientAction action = new EditPatientAction(prodDAO, loggedInMID.longValue(), pidString);

	/* Now take care of updating information */
	
	PatientBean p;
	if (request.getParameter("formIsFilled") != null && request.getParameter("formIsFilled").equals("true")) {
		//try {
			action.activate();
			loggingAction.logEvent(TransactionType.PATIENT_ACTIVATE, loggedInMID.longValue(), Long.valueOf((String)session.getAttribute("pid")).longValue(), "");
			session.removeAttribute("pid");
	
%>
	<br />
	<div align=center>
		<span class="iTrustMessage">Patient Successfully Activated</span>
	</div>
	<br />
<%
		/*} catch (Exception e) {
%>
	<br />
	<div align=center>
		<span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage()) %></span>
	</div>
	<br />
<%
		}*/
	} else {
		p = action.getPatient();
	
%>

<form id="activateForm" action="activatePatient.jsp" method="post">
<input type="hidden" name="formIsFilled" value="true"><br />
<table cellspacing=0 align=center cellpadding=0>
	<tr>
		<td valign=top>
		<table class="fTable" align=center style="width: 350px;">
			<tr>
				<th colspan="4">Activate Patient</th>
			</tr>		
			<tr>
			
				<td class="subHeaderVertical">First Name:</td>
				<td><%= StringEscapeUtils.escapeHtml("" + (p.getFirstName())) %></td>
				<td class="subHeaderVertical">Last Name:</td>
				<td><%= StringEscapeUtils.escapeHtml("" + (p.getLastName())) %></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<br />
<div align=center>
	<input type="submit" name="action"
		style="font-size: 16pt; font-weight: bold;" value="Activate Patient"><br /><br />
</div>
</form>
<% } %>
<br />
<br />
<itrust:patientNav thisTitle="Activate" />

<%@include file="/footer.jsp"%>
