<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
		
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter FROM board WHERE board_no =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = new Board();
	if(rs.next()){
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
	}
	
	// 3. 결과 출력
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardOne</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		td {
			width: 100%; 
			box-sizing : border-box;
		}
		th{
			white-space: nowrap;
			width: 10%;
		}
	
	</style>
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 메뉴 partial jsp 구성 -->
		</div>
		<h1 style="text-align:center">자유 게시판</h1>
		<div style="float: left">
			<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=board.boardNo%>" class="btn btn-outline-primary">수정</a>
			<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=board.boardNo%>" class="btn btn-outline-danger">삭제</a>	
		</div>
		<br>
		<br>
		<div id="div-table">
			<table class="table">
				<tr class="table-success">
					<th style="font-weight: 400; padding:20px 20px 0px 20px">no. <%=board.boardNo%></th>
					<td style="font-size:30px; padding: 20px 20px 0px 20px"><%=board.boardTitle%></td>
				</tr>
				<tr class="table-success">
					<th style="padding:0px 20px; border-top: hidden;">&nbsp;</th>
					<td style="padding:0px 20px; border-top: hidden;"><%=board.boardWriter%></td>
				</tr>
				<tr>
					<th>&nbsp;</th>
					<td style="padding: 20px"><%=board.boardContent%></td>
				</tr>
				
			</table>
		</div>
		
	</div>
</body>
</html>