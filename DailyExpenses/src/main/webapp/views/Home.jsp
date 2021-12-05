<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Expenses Application</title>
<link type="text/css" rel="stylesheet" href="/webjars/bootstrap/5.1.3/css/bootstrap.css">
</head>
<style>
h1{
text-align:center;
}
</style>
<body>
	<div class="container">
	<div class="row">
	<div class="col-lg-4"></div>
	<div class="col-lg-4">
	<h1>Expenses Application</h1>
	<form action="/redirect/saveData" method="POST">
	<label>Name</label>
		<select class="form-control" id="name" name="name">
		<option value="Rathna">Rathna</option>
		<option value="Suresh">Suresh</option>
		<option value="Papa">Papa</option>
		<option value="Amma">Amma</option>
		</select><br/>
		<!-- <input id="name" name="name" type="text" /> --> 
		<label>Date</label><input class="form-control" id="sdate" name="sdate" type="date" /> <br/>
		<label>Amount</label><input class="form-control" id="amount" name="amount" type="text" /><br/>
		<button>Submit</button>	
		<br/>
		
	</form>
	<form action="/getDataAll" method="GET">
	<br/><button>Detailed Report</button>
	</form>
	</div>
	<div class="col-lg-4">
	
	</div>
	</div>
	</div>
</body>
</html>