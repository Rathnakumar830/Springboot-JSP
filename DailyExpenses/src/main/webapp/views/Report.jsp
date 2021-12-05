<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Expenses Application</title>
<link type="text/css" rel="stylesheet"
	href="/webjars/bootstrap/5.1.3/css/bootstrap.css">
</head>
<style>
h1 {
	text-align: center;
}

table, th, td {
	border: 1px solid black;
}
</style>
<body>
	<div class="container">
		<div class="row">
			<div class="col-lg-4"></div>
			<div class="col-lg-4">
				<h1>Detailed Report</h1>
				<table class="form-control">
					<tr>
						<th>Name</th>
						<th>Amount</th>
						<th>Date</th>
						<c:forEach items="${ReportData}" var="data">
							<tr>
								<td><c:out value="${data.name}" /></td>
								<td><c:out value="${data.amount}" /></td>
								<td><c:out value="${data.sdate}" /></td>
							</tr>
						</c:forEach>
				</table>
			</div>
			<div class="col-lg-4"></div>
		</div>
	</div>
</body>
</html>