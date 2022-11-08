<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청 분석
	String deptNo = request.getParameter("deptNo");

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection connection = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = connection.prepareStatement(sql); // 쿼리 생성
	stmt.setString(1, deptNo); // 0행이거나 1행 출력
	ResultSet rs = stmt.executeQuery(); // 쿼리 실행
	String deptName = null;
	if(rs.next()){
		deptName = rs.getString("deptName");
	}
	
%>
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
		th, td{
			vertical-align: middle;
		}
		.cellBtn{
			width:60px;
			text-align:center;
		}
		.read-only{
			border: 0;
			box-shadow:none;
			background-color:white;
		}
		input:focus{
			background-color: rgb(200,200,200);
			outline-color: rgb(200,200,200);
		}
	</style>
</head>
<body>
<div class="container">
		<div><h1 style="text-align:center">DEPT LIST</h1></div>
		<br>
		<div id="div-table">
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
				<table class="table">
					<thead class="table-danger" style="border-radius:16px">
						<tr>
							<th>부서번호</th>
							<th>부서명</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" name="deptNo" value="<%=deptNo%>" readonly=readonly class="read-only"></td>
							<td><input type="text" name="deptName" value="<%=deptName%>"></td>
							<td><button type="submit" class="btn btn-outline-primary cellBtn">EDIT</button></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</body>
</html>