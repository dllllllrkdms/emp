<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("UTF-8");
	String word = request.getParameter("word");
	// 1) word==null 2) word -> '' or '단어'
	
	// 2. 요청 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	// 외부 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//System.out.println("드라이버 로딩 성공");
	// 데이터베이스 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); 
	// 쿼리 생성 
	String sql = null;
	PreparedStatement stmt = null;
	if(word==null){
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_No desc";
		stmt = conn.prepareStatement(sql); 
	} else{
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE deptName LIKE ? ORDER BY dept_No desc";
		stmt = conn.prepareStatement(sql); 
		stmt.setString(1, "%"+word+"%"); // %word% : word가 포함된 deptName 찾기
	}
	
	ResultSet rs = stmt.executeQuery(); // <-- 모델 데이터 ResultSet은 일반적,독립적인 타입이 아니다.
	
	// ResultSet rs라는 모델 자료구조를 좀더 일반적이고 독립적인 자료구조로 변경하기 
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()){ // ResultSet의 API(사용방법)을 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>DEPTLIST</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 모든 페이지에 똑같이 들어갈 내용 / 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- jsp액션태그include 같은 Context안에 있는 /inc/menu.jsp를 부르기 때문에 앞에 안써도됨-->
		</div>
		<!-- header -->
		<div><h1 style="text-align:center">DEPT LIST</h1></div>
		<div style="float: right">
			<form action="<%=request.getContextPath()%>/dept/deptList.jsp" method="post">
				<input type="text" name="word" placeholder="부서명 검색"><button type="submit">검색</button>
			</form>
		</div>
		<div style="float:left">
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-secondary">부서 추가</a>
		</div>
		<div id="div-table"> <!-- bootstrap css 오버라이딩 -->
			<!-- 부서 목록(부서번호 오름차순) -->
			<table class="table table-hover">
				<thead class="table-danger" >
					<tr>
						<th>부서번호</th>
						<th>부서명</th>
						<th class="cellBtn">수정</th>
						<th class="cellBtn">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Department d : list){
					%>
							<tr>
								<td><%=d.deptNo%></td>
								<td><%=d.deptName%></td>
								<td class="cellBtn"><a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>" class="btn btn-outline-primary">수정</a></td>
								<td class="cellBtn"><a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>" class="btn btn-outline-danger">삭제</a></td>
							</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>

