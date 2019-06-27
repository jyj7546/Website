/*daabaseUtil���� ���ٿ� ������ �����ͺ��̽� ��ü�� �̿��ؼ� �����ͺ��̽� ���� ���(ȸ������,�α��� ��) �������� �Լ� ����*/

package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DatabaseUtil;

public class UserDAO {
	
	/*�α���*/
	public int login(String userID, String userPassword) {
		
		/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - daabaseutil�̶�� �Լ��� ���ȭ
			pstmt = conn.prepareStatement(SQL); // conn��ü���� SQL���� �����Ű�� ���� �غ�
			
			pstmt.setString(1, userID); //����ڷκ��� ���� ID���� ù��° ?�� �־���
			
			rs = pstmt.executeQuery(); // �����ͺ��̽� ��ȸ SQL���� ������Ѽ� rs�� �����
			
			if(rs.next()) { //sql ���� ������ ���(ID���� ����)�� �����Ѵٸ�,
				if(rs.getString(1).contentEquals(userPassword)) {
					return 1; // �α��� ����
				}
				else {
					return 0; // ��й�ȣ Ʋ��
				}
			}
			return -1; // sql �� ������ ���(ID��)�� ���� = ���̵� ���� ��,
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return -2; // �����ͺ��̽� ����
	}
	
	/*ȸ������*/
	public int join(UserDTO user) {
			
			/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
			String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, false)";
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - databaseutil�̶�� �Լ��� ���ȭ
				pstmt = conn.prepareStatement(SQL); // conn��ü���� SQL���� �����Ű�� ���� �غ�
				
				pstmt.setString(1, user.getUserID()); //����ڷκ��� ���� ���� ?�� ���� ����
				pstmt.setString(2, user.getUserPassword());
				pstmt.setString(3, user.getUserEmail());
				pstmt.setString(4, user.getUserEmailHash());
				
				return pstmt.executeUpdate(); //INSERT, UPDATE, DELETE���� executeUpdate�Լ��� ó�� . ������ ������ ���� �������� ���� ��ȯ
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return -1; // ȸ������ ���� (�̹� �����ϴ� ID)
		}
	
	/*ȸ�� ���� ��, �ش� ȸ���� �̸����� ������ �Լ�*/
	public String getUserEmail(String userID) {

		/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
		String SQL = "SELECT userEmail FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - databaseutil�̶�� �Լ��� ���ȭ
			pstmt = conn.prepareStatement(SQL); // conn��ü���� SQL���� �����Ű�� ���� �غ�
			
			pstmt.setString(1, userID); //����ڷκ��� ���� userID�� ?�� ����
			rs = pstmt.executeQuery();
			if(rs.next()) //��� �����ϴ� ���, 
				{
					return rs.getString(1); //ù��° �Ӽ�, userEmailChecked�Ӽ��� �� ��ȯ
				}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return null; // �����ͺ��̽� ����
	}
	
	/*�̸��� ���� Ȯ��*/
	public boolean getUserEmailChecked(String userID) {
		
		/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?"; // sql ����
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - databaseutil�̶�� �Լ��� ���ȭ
			pstmt = conn.prepareStatement(SQL); // prepareStatement���� �ش� sql�� �̸� ������
			
			pstmt.setString(1, userID); //����ڷκ��� ���� ���� ?�� ���� ����
			rs = pstmt.executeQuery(); // sql ���� ���� ��, ����� ResultSet��ü�� ����
			if(rs.next()) // ��� �����ϴ� ���, 
				{
					return rs.getBoolean(1); //ù��° �Ӽ�, userEmailChecked�Ӽ��� �� (true���� false����) ��ȯ
				}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return false; // �����ͺ��̽� ����
	}

	/*�̸��� ���� ����*/
	public boolean setUserEmailChecked(String userID) { //�̸��� ���� �� �̸��� ������ �Ϸᰡ �ǵ��� ���ִ� �Լ�
			
			/*����ڷκ��� �Է¹��� ? userID�� ������ userPassword�� �ҷ���*/
			String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?"; // ?���̵� ���� ����ڷ� �Ͽ��� �̸��� ������ �ǵ��� ó��
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //Ư���� SQL���� ������ ���� ���� ��� �� ó���ϰ��� �� �� ���� Ŭ����. try �ȿ��� ����
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword ��ü ��ȯ - daabaseutil�̶�� �Լ��� ���ȭ
				pstmt = conn.prepareStatement(SQL); // conn��ü���� SQL���� �����Ű�� ���� �غ�
				
				pstmt.setString(1, userID); //����ڷκ��� ���� ���� ?�� ���� ����
				
				pstmt.executeUpdate();
				
				return true; //Ư�� �̸��� Ȯ�� ��ũ ���� ��, �ش� ����ڿ� ���� ������ �� ����. �� ������ �ٽ� ���� �� ���·� �ϰ� ��
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // �����ͺ��̽� �������Ŀ��� �����ߴ� �ڿ����� ���� �����ؼ� ������ ������ �ּ�ȭ
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return false; // �����ͺ��̽� ����
		}
}
