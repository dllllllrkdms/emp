<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Department" %>
<%
	// 1. 요청 분석
	if(request.getParameter("deptNo") == null || request.getParameter("deptNo").equals("")){ // updateDeptForm.jsp를 주소창에 직접 호출하면 deptNo는 null이 된다.
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); 
		return;
	}
	String deptNo = request.getParameter("deptNo");
	//msg 파라메타 값
	String msg = "";
	if(request.getParameter("msg")!=null){
		msg= "* " +request.getParameter("msg");
	}
	

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection connection = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = connection.prepareStatement(sql); // 쿼리 생성
	stmt.setString(1, deptNo); // 0행이거나 1행 출력
	ResultSet rs = stmt.executeQuery(); // 쿼리 실행
	
	Department dept = null; // 데이터 묶어두기 
	if(rs.next()){ 
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	// 3. 결과 출력
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		.read-only:focus{
			background-color: white;
			outline : none;
		}
		h1 {
			text-align:center;
		}
	</style>
</head>
<body>
<div class="container">
	<!-- 중복 영역 처리 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include> 
	</div>
	<div><h1>DEPT LIST</h1></div>
	<div id="warning"><%=msg%></div>
	<br>
	<div id="div-table">
		<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
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
						<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly=readonly class="read-only"></td>
						<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
						<td><button type="submit" class="btn btn-outline-primary cellBtn">등록</button></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
</body>
</html>