<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ include file="./config.jsp" %>
<%!
	private static Logger logger = LogManager.getLogger();
%>
<%
	//1.SSO ID ����
	String sso_id = getSsoId(request);
	logger.info("*================== [login_exec.jsp]  sso_id : {}"+sso_id);

//	getEamSessionCheckAndAgentVaild(request, response);
	if (sso_id == null || sso_id.equals("")) {
		logger.info("initialize new login process");
		CookieManager.addCookie("hyperauth_state", (String)request.getAttribute("state"), SSO_DOMAIN, response);
		CookieManager.addCookie("hyperauth_redirect_uri", (String)request.getAttribute("redirect_uri"), SSO_DOMAIN, response);
		goLoginPage(response); //
		return;
	} else {
		//4.��Ű ��ȿ�� Ȯ�� :0(����)
		logger.info("SsoId verified");
		String retCode = getEamSessionCheck( request,  response);
		System.out.println("*================== [retCode]  retCode : {}" + retCode);

		if(!retCode.equals("0")){
			logger.info("invalid cookie with retCode : {}" + retCode);
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}

		//5.�����ý��ۿ� ���� ����� ���̵� �������� ����
		logger.info("trying to get SSO EAM ID.....");
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		System.out.println("SSO ���� ����!!");
		//6.�����ý��� ������ ȣ��(���� ������ �Ǵ� ���������� ����)  --> �����ý��ۿ� �°� URL ����!
//		boolean ssoCheck = CheckExistUser(sso_id);
//		System.out.println("*================== ["+sso_id +"exist ] : " + ssoCheck );
		String email = getUserEmail(sso_id);


		String state = (request.getAttribute("state")!= null)?  (String)request.getAttribute("state") : CookieManager.getCookieValue("hyperauth_state",request);
		String hyperauth_redirect_uri = (request.getAttribute("redirect_uri")!= null)?  (String)request.getAttribute("redirect_uri") : CookieManager.getCookieValue("hyperauth_redirect_uri",request);

		String code = sso_id; //FIXME

		String redirectUri = hyperauth_redirect_uri + "?state=" + state + "&code=" + code;
		response.sendRedirect(redirectUri);
	}
%>