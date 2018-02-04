<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'empQueryAll.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  <body>
    <table border="1">
    	<tr>
    		<th>编号</th>
    		<th>人员</th>
    		<th>工作</th>
    		<th>管理员</th>
    		<th>生日</th>
    		<th>薪水</th>
    		<th>福利</th>
    		<th>部门编号</th>
    		<th>部门</th>
    		<th>地点</th>
    		<th>操作</th>
    	</tr>
    	
    	<c:forEach var="emp" items="${list}" varStatus="idx">
    	<tr>
    		<td>${emp.empno}</td>
    		<td>${emp.ename}</td>
    		<td>${emp.job}</td>
    		<td>${emp.mgr}</td>
    		<td>${emp.hiredate}</td>
    		<td>${emp.sal}</td>
    		<td>${emp.comm}</td>
    		<td>${emp.deptno}</td>
    		<td>${emp.dname}</td>
    		<td>${emp.loc}</td>
    		<td>
    			<a href="./emp/edit?empno=${emp.empno}">编辑</a>
    			<a href="./emp/delete?empno=${emp.empno}">删除</a>
    		</td>
    	</tr>
    	</c:forEach>
    </table>
    <%System.out.println(request.getRequestURI());%>
    <%System.out.println(request.getServletPath());%>
    <a href="./emp/add">新增</a>
  </body>
</html>