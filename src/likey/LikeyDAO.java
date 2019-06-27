package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class LikeyDAO {
	
	public int like(String userID, String evaluationID, String userIP) {
		
		/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
		String SQL = "INSERT INTO LIKEY VALUES (?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - databaseutil이라는 함수로 모듈화
			pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
			
			pstmt.setString(1, userID); //사용자로부터 받은 값들 ?에 각각 저장
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			
			return pstmt.executeUpdate(); //INSERT, UPDATE, DELETE등을 executeUpdate함수로 처리 . 실제로 영향을 받은 데이터의 개수 반환
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return -1; // 추천 오류 (중복추천)
	}
}
	

