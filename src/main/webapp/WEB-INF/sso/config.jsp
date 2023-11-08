<%@page import="com.initech.eam.smartenforcer.SECode"%>
<%@page import="java.util.Vector"%>
<%@page import="com.initech.eam.nls.CookieManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page import="com.initech.eam.base.APIException" %>
<%@ page import="com.initech.eam.api.*" %>
<%!
	/**[INISAFE NEXESS JAVA AGENT]**********************************************************************
	/***[SERVICE CONFIGURATION]***********************************************************************/
	private String SERVICE_NAME = "tmax";
	private String SERVER_URL 	= "http://tmax.initech.com";
	private String SERVER_PORT = "8081";
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/externalauth";

	//Custom Login Url
	//private String custom_url = SERVER_URL + ":" + SERVER_PORT + "/agent/sso/loginFormPageCoustom.jsp";
	private String custom_url = "";
	/***[SSO CONFIGURATION]**]***********************************************************************/
	private String NLS_URL 		 = "https://demo.initech.com";
	private String NLS_PORT 	 = "13443";
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/cookieLogin.jsp";
	private String NLS_LOGOUT_URL= NLS_URL + ":" + NLS_PORT + "/nls3/NCLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	private static String ND_URL1 = "http://demo.initech.com:5480";
	//private static String ND_URL2 = "http://ndtest.initech.com:5481";
	private static Vector PROVIDER_LIST = new Vector();
	private static final int COOKIE_SESSTION_TIME_OUT = 3000000;
	// ?? ?? (ID/PW ?? : 1, ??? : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = ".initech.com";
	private static final int timeout = 3000000;
	private static NXContext context = null;
	static{

		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1);

		context = new NXContext(serverurlList,timeout);
		CookieManager.setEncStatus(true);
//		CookieManager.setSameSiteStatus(false);

		PROVIDER_LIST.add("demo.initech.com");

		SECode.setCookiePadding("_V42");
	}
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}

	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		if(custom_url.equals("")) {
			//CookieManager.addCookie("CLP", "", SSO_DOMAIN, response);
		}else{
			CookieManager.addCookie("CLP", custom_url , SSO_DOMAIN, response);
		}
		response.sendRedirect(NLS_LOGIN_URL);
	}

	public String getEamSessionCheckAndAgentVaild(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookieAndAgentVaild(request, response, 10, COOKIE_SESSTION_TIME_OUT, PROVIDER_LIST, SERVER_URL, context);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	//@deprecated
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT,PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	public String getEamSessionCheck2(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		try {
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

	public String getUserEmail (String userid) { //FIXME
		String userEmail = null;
		NXUserAPI userAPI = new NXUserAPI(context);
		NXUserInfo userInfo = null;
		try{
			userInfo = userAPI.getUserInfo(userid);

		}catch (APIException e){
			e.printStackTrace();
		}
		userEmail =  userInfo.getEmail();
		return userEmail;
	}
%>