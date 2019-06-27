/*daabaseUtil에서 접근에 성공한 데이터베이스 객체를 이용해서 데이터베이스 관련 기능(회원가입,로그인 등) 전반적인 함수 정의*/

package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DatabaseUtil;

public class UserDAO {
	
	/*로그인*/
	public int login(String userID, String userPassword) {
		
		/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - daabaseutil이라는 함수로 모듈화
			pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
			
			pstmt.setString(1, userID); //사용자로부터 받은 ID깂을 첫번째 ?에 넣어줌
			
			rs = pstmt.executeQuery(); // 데이터베이스 조회 SQL문을 실행시켜서 rs에 담아줌
			
			if(rs.next()) { //sql 문을 실행한 결과(ID값이 존재)가 존재한다면,
				if(rs.getString(1).contentEquals(userPassword)) {
					return 1; // 로그인 성공
				}
				else {
					return 0; // 비밀번호 틀림
				}
			}
			return -1; // sql 문 실행한 결과(ID값)가 없음 = 아이디 없을 때,
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return -2; // 데이터베이스 오류
	}
	
	/*회원가입*/
	public int join(UserDTO user) {
			
			/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
			String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, false)";
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - databaseutil이라는 함수로 모듈화
				pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
				
				pstmt.setString(1, user.getUserID()); //사용자로부터 받은 값들 ?에 각각 저장
				pstmt.setString(2, user.getUserPassword());
				pstmt.setString(3, user.getUserEmail());
				pstmt.setString(4, user.getUserEmailHash());
				
				return pstmt.executeUpdate(); //INSERT, UPDATE, DELETE등을 executeUpdate함수로 처리 . 실제로 영향을 받은 데이터의 개수 반환
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return -1; // 회원가입 실패 (이미 존재하는 ID)
		}
	
	/*회원 가입 시, 해당 회원의 이메일을 얻어오는 함수*/
	public String getUserEmail(String userID) {

		/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
		String SQL = "SELECT userEmail FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - databaseutil이라는 함수로 모듈화
			pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
			
			pstmt.setString(1, userID); //사용자로부터 받은 userID를 ?에 저장
			rs = pstmt.executeQuery();
			if(rs.next()) //결과 존재하는 경우, 
				{
					return rs.getString(1); //첫번째 속성, userEmailChecked속성의 값 반환
				}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return null; // 데이터베이스 오류
	}
	
	/*이메일 검증 확인*/
	public boolean getUserEmailChecked(String userID) {
		
		/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?"; // sql 쿼리
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - databaseutil이라는 함수로 모듈화
			pstmt = conn.prepareStatement(SQL); // prepareStatement에서 해당 sql문 미리 컴파일
			
			pstmt.setString(1, userID); //사용자로부터 받은 값들 ?에 각각 저장
			rs = pstmt.executeQuery(); // sql 쿼리 실행 후, 결과를 ResultSet객체에 담음
			if(rs.next()) // 결과 존재하는 경우, 
				{
					return rs.getBoolean(1); //첫번째 속성, userEmailChecked속성의 값 (true인지 false인지) 반환
				}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return false; // 데이터베이스 오류
	}

	/*이메일 인증 수행*/
	public boolean setUserEmailChecked(String userID) { //이메일 검증 후 이메일 인증이 완료가 되도록 해주는 함수
			
			/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
			String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?"; // ?아이디를 가진 사용자로 하여금 이메일 인증이 되도록 처리
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - daabaseutil이라는 함수로 모듈화
				pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
				
				pstmt.setString(1, userID); //사용자로부터 받은 값들 ?에 각각 저장
				
				pstmt.executeUpdate();
				
				return true; //특정 이메일 확인 링크 누를 시, 해당 사용자에 관한 인증이 된 상태. 또 눌러도 다시 인증 된 상태로 하게 함
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return false; // 데이터베이스 오류
		}
}
