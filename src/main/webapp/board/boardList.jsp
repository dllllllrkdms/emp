<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	int currentPage = 1; // 넘어오지 않았다면 1페이지를 보여줌
	if(request.getParameter("currentPage")!=null){	// 넘어온 값이 있다면
		currentPage = Integer.parseInt(request.getParameter("currentPage"));		
	}
	
	// 2. 요청처리 후 필요하다면 모델데이터 생성
	final int ROW_PER_PAGE = 10; // final : 상수 (변경 불가한 변수, 변수이름 전부 대문자로 작성)
	int beginRow = ROW_PER_PAGE*(currentPage-1);
	//System.out.println(beginRow);
	
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	
	// 2-1 total row를 이용하여 lastPage 구하기
	String cntSql = "SELECT COUNT(*) cnt FROM board"; // COUNT(*) -> cnt 컬럼명 변경하여 출력
	PreparedStatement cntStmt = conn.prepareStatement(cntSql); 
	ResultSet cntRs = cntStmt.executeQuery(); // 총 row 개수 출력쿼리 실행
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)(Math.ceil((double)cnt/ROW_PER_PAGE)); // 올림
	
	// 2-2 모델데이터(ArrayList<Board>) 생성
	String listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board ORDER BY board_no ASC LIMIT ?,?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data -> 일반적으로 사용하는 데이터타입으로 변경저장
	while(listRs.next()){
		Board b = new Board(); 
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardWriter = listRs.getString("boardWriter");
		b.createdate = listRs.getString("createdate");
		boardList.add(b);
	}
	
	// 3. 결과출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		.title:link, .title:visited{ /* 상세보기a태그 css */
			color: black;
		}
		.title:hover{
			text-decoration: underline;
		}
	</style>
</head>
<body>
	<div class="container">
		<!-- 중복 영역 메뉴partial jsp구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1 style="text-align:center">자유 게시판</h1> 
		<!-- 3-1 모델데이터(ArrayList<Board> 출력 -->
		<div style="float:left">
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp" class="btn btn-outline-secondary">글쓰기</a>
		</div>
		<br>
		<br>
		<div id="div-table">
			<table class="table table-hover">
				<thead class="table-success">
					<tr>
						<th>NO</th>
						<th>제목</th>
						<th>작성자</th>
						<th style="width: 150px">작성일</th>
					</tr>
				</thead>
				<tbody>
				<%
					for(Board b : boardList){
				%>
					
						<tr>
							<td><%=b.boardNo%></td>
							<!-- 제목 클릭시 상세보기 이동 -->
							<td><a class="title" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a></td> 
							<td><%=b.boardWriter%></td>
							<td><%=b.createdate%>
						</tr>					
				<%		
					}
				%>
				</tbody>
			</table>
		</div>
		<br>
		<!-- 3-2 페이징 처리 -->
		<nav aria-label="Page navigation">
			<ul class="pagination justify-content-center">
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a></li>
				<%
					if(currentPage>1){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item active"><a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage%>"><%=currentPage%></a></li>
				<%
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a></li>
			</ul>
		</nav>
	</div>
</body>
</html>