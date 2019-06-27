package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator { // 인증 수행 도움
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("wjsdudwns319@gmail.com", "940319dw"); // 사용자들에게 이메일을 보낼 관리자 계정 이메일
	}
}
