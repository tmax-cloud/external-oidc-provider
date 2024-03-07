<%@ include file="./config.jsp" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.tmax.externaloidcprovider.global.OIDCUserRepository" %>
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%!
	private Logger logger = LogManager.getLogger();
%>
<%

	//1.SSO ID ����
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
		//4.��Ű ��ȿ�� Ȯ�� :0(����)
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

		//5.�����ý��ۿ� ���� ����� ���̵� �������� ����
		logger.info("trying to get SSO EAM ID.....");
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		logger.info("SSO Authentication verified!!");

		//6.SSOID�� ����� ���� ��ȸ
		boolean ssoCheck = checkExistUser(sso_id);
		logger.info("*================== ["+sso_id +"exist ] : " + ssoCheck );
//		if(ssoCheck){
			try{
//				NXUserInfo userInfo = getUserInfo(sso_id);
				logger.info("Receive userInfo from daemon server.");

				List<String> dummyUserInfo = new ArrayList<String>();
				dummyUserInfo.set(1,sso_id);
				dummyUserInfo.set(2,"T");
				dummyUserInfo.set(3,"������");
				dummyUserInfo.set(4,"test@initech.com");
				dummyUserInfo.set(5,"abcdefg");
				dummyUserInfo.set(6,"2019-0101");
				dummyUserInfo.set(7,"2025-01-01");
				NXUserInfo userInfo = new NXUserInfo(dummyUserInfo);

				logger.info("userInfo [ userId : {}, username : {}, userEmail : {} enabled : {}", userInfo.getUserId(), userInfo.getName(), userInfo.getEmail(), userInfo.getEnable());
				//�ӽ÷� user ������ �޸𸮿� ����, OIDC user profile ���� ��ȸ�� ��� �� �ٷ� ����
				OIDCUserRepository.getInstance().addUserInfo(sso_id, userInfo);
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Failed to get user info from daemon server. Skip userinfo setting.");
			}
//		}else{
//			logger.info("Cannot check user exist, or user is not exist. Skip userinfo setting.");
//		}

		//7.�����ý��� ������ ȣ��(���� ������ �Ǵ� ���������� ����)  --> �����ý��ۿ� �°� URL ����!
		String state = (request.getAttribute("state")!= null)?  (String)request.getAttribute("state") : CookieManager.getCookieValue("hyperauth_state",request);
		String hyperauth_redirect_uri = (request.getAttribute("redirect_uri")!= null)?  (String)request.getAttribute("redirect_uri") : CookieManager.getCookieValue("hyperauth_redirect_uri",request);

		String code = sso_id;

		String redirectUri = hyperauth_redirect_uri + "?state=" + state + "&code=" + code;
		response.sendRedirect(redirectUri);
	}
%>