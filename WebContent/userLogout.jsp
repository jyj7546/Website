<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>

<%
	session.invalidate(); // 클라이언트의 모든 세션 정보 파기
%>
<%
	PrintWriter script = response.getWriter();
	
	//스크립트 구문 시작
	script.println("<script>");
	script.println("alert('로그아웃 되었습니다.');");
	script.println("location.href = 'index.jsp';");
	script.println("</script>");
	script.close();
	//스크립트 구문 닫기
	return;

%>