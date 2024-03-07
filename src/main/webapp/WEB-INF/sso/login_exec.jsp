<%@ include file="./config.jsp" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.tmax.externaloidcprovider.global.OIDCUserRepository" %>
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%!
	private Logger logger = LogManager.getLogger();
%>
<%

	//1.SSO ID 수신
	String sso_id = getSsoId(request);
	logger.info("*================== [login_exec.jsp]  sso_id : {}", sso_id);

	if (sso_id == null || sso_id.equals("")) {
		logger.info("initialize new login process");

		String state;
		String hyperauth_redirect_uri;

		if(request.getAttribute("state") == null || request.getAttribute("redirect_uri") == null){
			state = CookieManager.getCookieValue("hyperauth_state",request);
			hyperauth_redirect_uri = CookieManager.getCookieValue("hyperauth_redirect_uri",request);
		}else{
			state = (String)request.getAttribute("state");
			hyperauth_redirect_uri = (String)request.getAttribute("redirect_uri");

			CookieManager.addCookie("hyperauth_state", state, SSO_DOMAIN, response);
			CookieManager.addCookie("hyperauth_redirect_uri", hyperauth_redirect_uri, SSO_DOMAIN, response);
		}

		if(state == null || hyperauth_redirect_uri == null){
			logger.info("state or redirect_uri is null");
			goErrorPage(response, 400);
			return;
		}

		goLoginPage(response); //
		return;
	} else {
		//4.쿠키 유효성 확인 :0(정상)
		logger.info("SsoId verified");
		String retCode = getEamSessionCheckAndAgentVaild(request,  response);
		if(retCode.equals("0")){
			logger.info("Complete agent verification with daemon server. [retCode : {}]", retCode);
		}else{
			logger.error("Unable to verify agent with daemon server. Skip agent verification and try to validate cookie only. [retCode : {}]", retCode);
			retCode = getEamSessionCheck(request,  response);
			if(retCode.equals("0")){
				logger.info("Valid cookie. [retCode : {}]", retCode);
			}else{
				logger.error("invalid cookie. retCode : {}" + retCode);
				goErrorPage(response, Integer.parseInt(retCode));
				return;
			}
		}

		//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
		logger.info("trying to get SSO EAM ID.....");
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		logger.info("SSO Authentication verified!!");

		//6.SSOID로 사용자 정보 조회
		boolean ssoCheck = checkExistUser(sso_id);
		logger.info("*================== ["+sso_id +"exist ] : " + ssoCheck );
//		if(ssoCheck){
			try{
//				NXUserInfo userInfo = getUserInfo(sso_id);
				logger.info("Receive userInfo from daemon server.");

				List<String> dummyUserInfo = new ArrayList<String>();
				dummyUserInfo.set(1,sso_id);
				dummyUserInfo.set(2,"T");
				dummyUserInfo.set(3,"김현우");
				dummyUserInfo.set(4,"test@initech.com");
				dummyUserInfo.set(5,"abcdefg");
				dummyUserInfo.set(6,"2019-0101");
				dummyUserInfo.set(7,"2025-01-01");
				NXUserInfo userInfo = new NXUserInfo(dummyUserInfo);

				logger.info("userInfo [ userId : {}, username : {}, userEmail : {} enabled : {}", userInfo.getUserId(), userInfo.getName(), userInfo.getEmail(), userInfo.getEnable());
				//임시로 user 정보를 메모리에 저장, OIDC user profile 정보 조회시 사용 후 바로 삭제
				OIDCUserRepository.getInstance().addUserInfo(sso_id, userInfo);
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Failed to get user info from daemon server. Skip userinfo setting.");
			}
//		}else{
//			logger.info("Cannot check user exist, or user is not exist. Skip userinfo setting.");
//		}

		//7.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
		String state = (request.getAttribute("state")!= null)?  (String)request.getAttribute("state") : CookieManager.getCookieValue("hyperauth_state",request);
		String hyperauth_redirect_uri = (request.getAttribute("redirect_uri")!= null)?  (String)request.getAttribute("redirect_uri") : CookieManager.getCookieValue("hyperauth_redirect_uri",request);

		String code = sso_id;

		String redirectUri = hyperauth_redirect_uri + "?state=" + state + "&code=" + code;
		response.sendRedirect(redirectUri);
	}
%>