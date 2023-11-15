<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>java util</title>
</head>
<body>

<!-- java에서의 util을 마찬가지로 import할 수 있다. -->
<%
    String key1 = request.getAttribute("key1").toString();
    String key2 = request.getAttribute("key2").toString();

    out.println(key1);
    out.println(key2);
%>
<div>
    key1 : <%=key1 %>
</div>

<div>
    key2 : <%=key2 %>
</div>

</body>
</html>