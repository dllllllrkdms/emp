<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		#div-table{			
			border-radius:16px;
			box-shadow: 0 0 8px;
			overflow: hidden;
		}
		.cellBtn{
			width:60px;
			text-align:center;
		}
		th, td{
			vertical-align: middle;
		}
	</style>
</head>
<body>
	<div class="container">
		<div><h1 style="text-align:center">DEPT ADD</h1></div>
		<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
			<div id="div-table">
				<table class="table">
					<thead class="table-danger">
						<tr>
							<th>부서번호</th>
							<th>부서명</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" name="deptNo" placeholder="d001"></td>
							<td><input type="text" name="deptName"></td>
							<td><button type="submit" class="btn btn-outline-success cellBtn">ADD</button>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>