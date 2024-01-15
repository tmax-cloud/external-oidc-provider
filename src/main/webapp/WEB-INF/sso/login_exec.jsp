<%@ include file="./config.jsp" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.tmax.externaloidcprovider.global.NXUserRepository" %>
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%!
	private Logger logger = LogManager.getLogger();
%>
<%

	//1.SSO ID 수신
	String sso_id = getSsoId(request);
	logger.info("*================== [login_exec.jsp]  sso_id : {}", sso_id);

//	getEamSessionCheckAndAgentVaild(request, response);
	if (sso_id == null || sso_id.equals("")) {
		logger.info("initialize new login process");
		CookieManager.addCookie("hyperauth_state", (String)request.getAttribute("state"), SSO_DOMAIN, response);
		CookieManager.addCookie("hyperauth_redirect_uri", (String)request.getAttribute("redirect_uri"), SSO_DOMAIN, response);
		goLoginPage(response); //
		return;
	} else {
		//4.쿠키 유효성 확인 :0(정상)
		logger.info("SsoId verified");
		String retCode = getEamSessionCheck( request,  response);
		logger.info("*================== [retCode]  retCode : {}", retCode);

		if(!retCode.equals("0")){
			logger.info("invalid cookie with retCode : {}" + retCode);
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}

		//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
		logger.info("trying to get SSO EAM ID.....");
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		System.out.println("SSO 인증 성공!!");
		//6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
//		boolean ssoCheck = CheckExistUser(sso_id);
//		System.out.println("*================== ["+sso_id +"exist ] : " + ssoCheck );
//		String email = getUserEmail(sso_id);

		try{
			NXUserInfo userInfo = getUserInfo(sso_id);
			logger.info("Receive userInfo from demon server.");
			logger.info("userInfo : {}", userInfo.toString());
			NXUserRepository.getInstance().addUserInfo(sso_id, userInfo);
		}catch(Exception e){
			e.printStackTrace();
			logger.error("Failed to get user info from demon server. Skip userinfo setting.");
		}

		String state = (request.getAttribute("state")!= null)?  (String)request.getAttribute("state") : CookieManager.getCookieValue("hyperauth_state",request);
		String hyperauth_redirect_uri = (request.getAttribute("redirect_uri")!= null)?  (String)request.getAttribute("redirect_uri") : CookieManager.getCookieValue("hyperauth_redirect_uri",request);

		String code = sso_id;

		String redirectUri = hyperauth_redirect_uri + "?state=" + state + "&code=" + code;
		response.sendRedirect(redirectUri);
	}
%>