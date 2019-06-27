<!-- 회원가입 처리 함수-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정 스크립트 구문 출력할 떄 사용 -->
<%
	request.setCharacterEncoding("UTF-8"); //사용자로부터 입력 받은 요청 정보를 UTF-8으로 처리한다
	String userID = null;    
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); // session에 저장된 userID 있으면 불러옴
	}
	if(userID != null) { // 이미 로그인 한 상태, session 에 저장된 userID값이 있는 상태,
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인 되어 있습니다.')");
		script.println("location.href = 'index.jsp';");
		script.println("</script");
		script.close();
		return;
	}
	
	String userPassword = null;
	String userEmail = null;
	
	if(request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	if(request.getParameter("userEmail") != null) {
		userEmail = request.getParameter("userEmail");
	}
	
	if(userID == null | userID.equals("") | userID.equals("null") | 
			userPassword == null | userPassword.equals("") | userPassword.equals("null") |
			userEmail == null | userEmail.equals("") | userEmail.equals("null")) { //  하나라도 공란이 있는 경우, "null" 로 들어가는 것까지 체크하기 - 중요!
		
		PrintWriter script = response.getWriter(); // 메세지 출력
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');"); // 메세지 출력
		script.println("history.back();"); // 뒤로가기
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 오류 발생 시, 현재 JSP 페이지 종료

	} else { // 회원가입 빈칸 제대로 입력 했을 때,
		
		UserDAO userDAO = new UserDAO(); // 객체 선언
		int result = userDAO.join(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false)); // 한 명의 사용자 객체 넣어줌
		if (result == -1) { // 회원가입 되지 않았을 떄,
			PrintWriter script = response.getWriter();
		
			//스크립트 구문 시작
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다.');"); // 메세지 출력
			script.println("history.back();"); // 뒤로가기
			script.println("</script>");
			script.close();
			//스크립트 구문 닫기
			return; // 오류 발생 시, 현재 JSP 페이지 종료
			
		} else { // 회원가입 성공 시,
			session.setAttribute("userID", userID); // 세션 값으로 userID라는 값으로 userID를 넣어서 서버에서 관리하게 함
			PrintWriter script = response.getWriter();
			
			//스크립트 구문 시작
			script.println("<script>");
			script.println("location.href = 'emailSendAction.jsp'"); // 사용자가 회원가입 하자마자 이메일 인증 받을 수 있도록 emailSendAciton.jsp 페이지로 링크 걸어줌
			script.println("</script>");
			script.close();
			//스크립트 구문 닫기
			return; // 현재 JSP 페이지 종료
		}
	}	
%>