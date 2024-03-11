<%@page import="com.initech.eam.smartenforcer.SECode"%>
<%@page import="java.util.Vector"%>
<%@page import="com.initech.eam.nls.CookieManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page import="com.initech.eam.base.APIException" %>
<%@ page import="com.initech.eam.api.*" %>
<%@ page import="com.tmax.externaloidcprovider.constant.OidcPath" %>
<%!
	/**[INISAFE NEXESS JAVA AGENT]**********************************************************************
	/***[SERVICE CONFIGURATION]***********************************************************************/
	private String SERVER_URL 	= System.getenv("SERVER_URL"); //"https://tmax.initech.com";
	private String ASCP_URL = SERVER_URL + OidcPath.auth;

	//Custom Login Url
	//private String custom_url = SERVER_URL + ":" + SERVER_PORT + "/agent/sso/loginFormPageCoustom.jsp";
	private String custom_url = "";
	/***[SSO CONFIGURATION]**]***********************************************************************/
	private String NLS_URL 		 = System.getenv("NLS_URL"); //"https://demo.initech.com";
	private String NLS_PORT 	 = System.getenv("NLS_PORT"); //"13443";
	private String NLS_LOGIN_URN = System.getenv("NLS_LOGIN_URN"); //"/nls3/cookieLogin.jsp";
	private String NLS_LOGIN_URL =
			NLS_PORT.isEmpty() ? NLS_URL + NLS_LOGIN_URN
			: NLS_URL + ":" + NLS_PORT + NLS_LOGIN_URN;
	private String NLS_LOGOUT_URN = System.getenv("NLS_LOGOUT_URN"); //"/nls3/NCLogout.jsp";
	private String NLS_LOGOUT_URL =
			NLS_PORT.isEmpty() ? NLS_URL + NLS_LOGOUT_URN
			: NLS_URL + ":" + NLS_PORT + NLS_LOGOUT_URN;
	private String NLS_ERROR_URL =
			NLS_PORT.isEmpty() ? NLS_URL + "/nls3/error.jsp"
			: NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";

	private static String ND_URL1 = System.getenv("ND_URL1");//"https://demo.initech.com:13443/rpc2";
	private static String ND_URL2 =  System.getenv("ND_URL2"); //"http://ndtest.initech.com:5481";
	private static Vector PROVIDER_LIST = new Vector();
	private static final int COOKIE_SESSION_TIME_OUT = 30000;
	// ?? ?? (ID/PW ?? : 1, ??? : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = System.getenv("SSO_DOMAIN"); //".initech.com";
	private static final int timeout = 15000;
	private static NXContext context = null;

	private static boolean AUTO_EMAIL_COMPLETION = System.getenv("AUTO_EMAIL_COMPLETION").equalsIgnoreCase("true") ? true : false;
	private static String AUTO_EMAIL_FORMAT_PREFIX = System.getenv("AUTO_EMAIL_FORMAT_PREFIX");
	private static String AUTO_EMAIL_FORMAT_SUFFIX = System.getenv("AUTO_EMAIL_FORMAT_SUFFIX");

	static{

		List<String> serverUrlList = new ArrayList<String>();
		if(ND_URL1 != null && !ND_URL1.equals("")){
			System.out.println("ND_URL1 : " + ND_URL1 + " is added to serverUrlList");
			serverUrlList.add(ND_URL1);
		}
		if(ND_URL2 != null && !ND_URL2.equals("")){
			System.out.println("ND_URL2 : " + ND_URL2 + " is added to serverUrlList");
			serverUrlList.add(ND_URL2);
		}

		context = new NXContext(serverUrlList,timeout);
		CookieManager.setEncStatus(true);
//		CookieManager.setSameSiteStatus(false);

		PROVIDER_LIST.add(System.getenv("NLS_URL").substring(8)); //remove https prefix
//		SECode.setCookiePadding("_V42");
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
			retCode = CookieManager.verifyNexessCookieAndAgentVaild(request, response, 10, COOKIE_SESSION_TIME_OUT, PROVIDER_LIST, SERVER_URL, context);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	//@deprecated
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSION_TIME_OUT,PROVIDER_LIST);
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

	public NXUserInfo getUserInfo (String userid) throws Exception{
		NXUserAPI userAPI = new NXUserAPI(context);
		NXUserInfo userInfo =  userAPI.getUserInfo(userid);
		return userInfo;
	}

	public String getUserEmail (String userid) {

		String userEmail = null;

		NXUserAPI userAPI = new NXUserAPI(context);
		NXUserInfo userInfo = null;
		try{
			userInfo = userAPI.getUserInfo(userid);
		}catch (Exception e){
			e.printStackTrace();
		}

		userEmail =  userInfo.getEmail();

		return userEmail;
	}

	public boolean checkExistUser(String userid){
		NXUserAPI userAPI = new NXUserAPI(context);
		boolean flag = false;
		try {
			flag = userAPI.existUser(userid);
		} catch (APIException e) {
			logger.error("Unable to check User : {}", e.getMessage());
		}
		return flag;
	}
%>