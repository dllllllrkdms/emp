<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	String msg="";
	if(request.getParameter("msg")!=null){
		msg = "* "+request.getParameter("msg");
	}
	//System.out.println(msg+"<-- updateBoardForm msg");
	String boardNoStr = request.getParameter("boardNo");
	int boardNo = Integer.parseInt(boardNoStr);
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db 연결
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = new Board();
	if(rs.next()){
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	// 3. 결과 출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateBoardForm</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
	input,textarea {
		width: 100%; 
		box-sizing : border-box;
		padding: 13px;
	}
	input:focus,textarea:focus{
		background-color: white;
	}
	</style>
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>자유 게시판</h1>
		<div style="float:left">
			 <jsp:include page="/inc/boardMenu.jsp"></jsp:include>
			 <span id="warning"><%=msg%></span>
		</div>
		<div id="div-table">
			<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<table class="table">
					<thead>
						<tr>
							<th colspan="2" style="padding: 20px" class="table-success">
								<span style="float:left; font-size:30px;">글쓰기</span>
								<span style="float:right">
									<button type="submit" class="btn btn-primary">등록</button>
									<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">취소</a>
								</span>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2"><input type="text" name="boardTitle" value="<%=board.boardTitle%>" maxlength="500"></td>
						</tr>
						<tr>
							<td colspan="2"><textarea cols="100" rows="10" name="boardContent" style="resize: none"><%=board.boardContent%></textarea></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">작성자</td>
							<td><input type="text" name="boardWriter" value="<%=board.boardWriter%>" readonly="readonly" class="read-only"></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">비밀번호 확인</td>
							<td><input type="password" name="boardPw" maxlength="50"></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</body>
</html>