
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정 스크립트 구문 출력할 떄 사용 -->
<%
	request.setCharacterEncoding("UTF-8"); //사용자로부터 입력 받은 요청 정보를 UTF-8으로 처리한다
	String userID = null;
	String userPassword = null;
	
	if(request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
		System.out.println("userID 값 제대로 입력됨");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
		System.out.println("password 값 제대로 입력됨");
	}
	if(userID == null || userPassword == null) { // 정상적으로 입력하지 않은 경우,
		PrintWriter script = response.getWriter(); // 메세지 출력
		System.out.println("ID, password 값 제대로 입력 안됨");
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');"); // 메세지 출력
		script.println("history.back();"); // 뒤로가기
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 오류 발생 시, 현재 JSP 페이지 종료
	}
	
	UserDAO userDAO = new UserDAO(); // 객체 선언
	int result = userDAO.login(userID, userPassword);
	if (result == 1) { // 로그인 성공 시,
		
		session.setAttribute("userID", userID); // 세션 값으로 userID라는 값으로 userID를 넣어서 서버에서 관리하게 함
		
		boolean emailChecked = userDAO.getUserEmailChecked(userID);
		if(emailChecked == false) { // 이메일 인증 안 된 회원
			PrintWriter script = response.getWriter();
			
			//스크립트 구문 시작
			script.println("<script>");
			script.println("location.href = 'emailSendConfirm.jsp';"); // 이메일 인증 다시 하겠냐고 묻는 페이지
			script.println("</script>");
			script.close();
			//스크립트 구문 닫기
			return; // 현재 JSP 페이지 종료
		}
		
		else { // boolean emailChecked 값이 true일 때, (이메일 인증 완료 한 상태)
		PrintWriter script = response.getWriter();
	
		//스크립트 구문 시작
		script.println("<script>");
		script.println("location.href = 'index.jsp'"); // 메인 페이지로 이동
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 오류 발생 시, 현재 JSP 페이지 종료
		}
	} else if (result == 0) { // 비밀번호 틀렸을 때,
		PrintWriter script = response.getWriter();
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('비밀번호가 틀렸습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	} else if (result == -1) { // 아이디가 없을 시,
		PrintWriter script = response.getWriter();
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('존재하지 않는 회원입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	} else if (result == -2){ // 데이터베이스 오류
		PrintWriter script = response.getWriter();
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('데이터베이스 오류 발생.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	} 
	
%>