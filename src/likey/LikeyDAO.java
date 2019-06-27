package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class LikeyDAO {
	
	public int like(String userID, String evaluationID, String userIP) {
		
		/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
		String SQL = "INSERT INTO LIKEY VALUES (?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - databaseutil�̶�� �Լ��� ���ȭ
			pstmt = conn.prepareStatement(SQL); // conn��ü���� SQL���� �����Ű�� ���� �غ�
			
			pstmt.setString(1, userID); //����ڷκ��� ���� ���� ?�� ���� ����
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			
			return pstmt.executeUpdate(); //INSERT, UPDATE, DELETE���� executeUpdate�Լ��� ó�� . ������ ������ ���� �������� ���� ��ȯ
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return -1; // ��õ ���� (�ߺ���õ)
	}
}
	

