<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 모든 페이지에 똑같이 들어갈 내용 partial jsp 페이지 사용할 코드-->
<a href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
<a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
<a href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
<a href="<%=request.getContextPath()%>/salary/salaryList.jsp">연봉관리</a>
<a href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
