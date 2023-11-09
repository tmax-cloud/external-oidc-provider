<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ include file="./config.jsp" %>

<%
	//1.SSO ID 수신
	String sso_id = getSsoId(request);
	System.out.println("*================== [login_exec.jsp]  sso_id = "+sso_id);

//	getEamSessionCheckAndAgentVaild(request, response);
	if (sso_id == null || sso_id.equals("")) {
		CookieManager.addCookie("hyperauth_state", (String)request.getAttribute("state"), SSO_DOMAIN, response);
		CookieManager.addCookie("hyperauth_redirect_uri", (String)request.getAttribute("redirect_uri"), SSO_DOMAIN, response);
		goLoginPage(response); // temp user : 1111 / admin
		return;
	} else {
		//4.쿠키 유효성 확인 :0(정상)
		String retCode = getEamSessionCheck( request,  response);
		System.out.println("*================== [retCode]  retCode = " + retCode);

		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		//
		//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
		System.out.println("SSO EAM ID 획득 전!!");

		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		System.out.println("SSO 인증 성공!!");
		//6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
//		boolean ssoCheck = CheckExistUser(sso_id);
//		System.out.println("*================== ["+sso_id +"exist ] : " + ssoCheck );
//		String email = getUserEmail(sso_id);
//		String email = "taegeon_woo@tmax.co.kr";
//		System.out.println("email : " + email);

		String state = (request.getAttribute("state")!= null)?  (String)request.getAttribute("state") : CookieManager.getCookieValue("hyperauth_state",request);
		String hyperauth_redirect_uri = (request.getAttribute("redirect_uri")!= null)?  (String)request.getAttribute("redirect_uri") : CookieManager.getCookieValue("hyperauth_redirect_uri",request);
		System.out.println("state  : " + state);
		System.out.println("hyperauth_redirect_uri  : " + hyperauth_redirect_uri);

		String code = sso_id; //FIXME

		String redirectUri = hyperauth_redirect_uri + "?state=" + state + "&code=" + code;
		response.sendRedirect(redirectUri);
	}
%>