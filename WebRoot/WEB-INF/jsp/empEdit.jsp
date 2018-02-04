<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'empEdit.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
	<script type="text/javascript">
		/*1.调用onclick事件调用报错：
		Uncaught SyntaxError: Unexpected token ,
		Uncaught ReferenceError: updateEmp is not defined。
		我花了好长时间排查原因，结果发现是javascript方法中出现了中文的逗号，导致方法无法被识别
		
		2.chrome控制台警告：Synchronous XMLHttpRequest on the main thread
		解决：将ajax的方法改为异步提交
		http://blog.csdn.net/sky786905664/article/details/53079487
		
		3.http是请求响应，因此任何ajax提交一定都要有返回。就算是简单的发出insert、update请求，也一定要给响应值。
		Ajax请求通过XMLHttpRequest对象发送请求,
		当XMLHttpRequest.status为200的时候，表示响应成功，此时触发success().其他状态码则触发error().
		除了根据响应状态码外，ajax还会在下列情况下走error方法
		a.返回数据类型不是datatype指定的类型
		b.网络中断
		c.后台响应中断
		
		4.再次巩固了json知识
		对象{"res":xxx}   	在ajax中解析data.res
		数组[,,]				在ajax中解析data[0]
		
		5.spring mvc控制器正常都会返回view name,我们就该怎么返回json之类的呢
		方法一：在方法中通过参数获取response，然后直接response输出
		public void insert(HttpServletResponse res) throws Exception{
			String result = "{\"res\": 2}";
			res.getWriter().print(result);
		}
		
		如果不想每次都要在方法中写response，那么可以将它作为一个成员变量，并按如下方法
		public class BaseAction{
		   protected HttpServletRequest request;
		   protected HttpServletResponse response;
		   protected HttpSession session;
		  
		   //@ModelAttribute放在类方法上面则表示该Action类中的每个请求调用之前都会执行该方法，
		   //因此在此方法里面可以做一些请求预处理，利用此特性就可以抽象出一个基本Action类，然后所有的Action类都继承自这个基本Aciton类，在基本Action类里面获取相应的request、response、session对象：
		   @ModelAttribute 
		   public void setReqAndRes(HttpServletRequest request, HttpServletResponse response){
		       this.request = request;
		       this.response = response;
		       this.session = request.getSession();
		   }
		 
		   ......
		}
		
		方法二：只需要在方法的前面加上 @ResponseBody即可。一般返回 String(可以是JSON, XML,普通的 Text),也可以是 Object。
		 @ResponseBody 的作用是把 返回的对象直接写到 HTTP  response body 里
		
		6.html head中的base href：表示每次请求都加上此代码
		
		7.HTTP Status 400 - The request sent by the client was syntactically incorrect.
		从字面上理解是：客户端发送的请求语法错误。实际就是springmvc无法实现数据绑定。 
		网上查找解决方案：
		有的说是因为form表单的栏位名与entity属性名不一致；
		有的说是因为entity的属性只能多于form表单，不能少于form表单；
		有的说是因为
		
		但检查发现我的程序里不存在上述问题，
		最终发现原因是：Emp的hiredate为日期 类型，而input时hiredate是String，无法匹配。
		处理方法是写转换器，如下
		//转换器类
		public class CustomDateConverter implements Converter<String, Date> {  
			  
		    private String dateFormatPattern;  //转换的格式  
		  
		    public CustomDateConverter(String dateFormatPattern) {  
		            this.dateFormatPattern = dateFormatPattern;  
		    }  
		      
		    @Override  
		    public Date convert(String source) {  
		         if(!StringUtils.hasLength(source)) {  
		             return null;  
		         }  
		         DateFormat df = new SimpleDateFormat(dateFormatPattern);  
		         try {  
		             return df.parse(source);  
		         } catch (ParseException e) {  
		             throw new IllegalArgumentException(String.format("类型转换失败，需要格式%s，但格式是[%s]", dateFormatPattern, source));   
		         }  
		    }  
		}  
		
		//配置转换器
		<mvc:annotation-driven conversion-service="conversionService"/>  
		<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">  
			<property name="converters">  
			    <list>  
					<bean class="packagename.CustomDateConverter">  
					    <constructor-arg value="yyyy-MM-dd"></constructor-arg>  
					</bean>  
				</list>  
			</property>  
		</bean>
		
		
		参考：http://aokunsang.iteye.com/blog/1409505
		
		8.关于spring MVC获取ajax传来的值
		前端和服务器数据的传输方式常用的有两种：
		一种是以表单的形式提交，此时可以利用jquery的serialize()方法将表单内容转为a=1&b=2&c=3&d=4&e=5这样的格式传输过去，接收端则可以用javabean直接接收。
		还有一种方式是以json格式传输，接收时若直接用bean接收则接收不到，此时应该用@RequestBody方式，需要注意的是接收的需要是json串，而不是json对象，可以在发送前使用JSON.stringify函数进行处理
		
		例子如下
		客户端：
		 var url=path+'testConverter.html';
		    $.ajax( {
		    url : url,
		    type : "POST", 
		    dataType:"json",
		    contentType:'application/json;charset=UTF-8',
		    data:JSON.stringify({userId:'1',userName:'hello',password:'test',credits:'2',lastIp:'',lastVisit:'1986-05-27'}),
		    success : function(data) {
		        alert(data.userName);   
		   
		    },
		error:function(e){
		    alert("err");   
		    }   

		服务端：
		@RequestMapping(value="/testConverter.html")
		    @ResponseBody
		    public User testConverter(@RequestBody User  user)
		    {
		        System.out.println(user.getUserName());
		        user.setUserName("testname");       
		        return user;       
		    }

		上面例子中服务端返回的是个对象，@ResponseBody函数会自动将其转换为客户端要求的‘ dataType:"json",’格式。

		最后需要注意的是
		a,在xxx-serverlet配置文件中应该写上，以便可以使用 @ResponseBody和@RequestBody
		b,发送时要写上 contentType:'application/json'
		c,数组内容要用[]而不是list，用list会接收到一个map对象，而不是bean
		*/
		
		function insertEmp(){
			$.ajax({
				url:"emp/insert",
				type:"POST",
				data:$('#emp').serialize(),//也可以这样写"id="+uid
				dataType:"text",
				success:function(data){
					//alert(data[0].res);
					//alert(data.res);
					//alert(data.res);
					//console.log(data);
					alert("插入数据成功");
					console.log("insert success");
					//$("#aaa").parent().html(data);
				},
				error:function(request){
					alert("插入数据失败");
					console.log("insert error");
				}
			});
		}
		
		updateEmp=function(){
			$.ajax({
				url:"emp/update",
				type:"POST",
				data:$('#emp').serialize(),//也可以这样写"id="+uid
				dataType:"text",
				success:function(data){
					alert("更新数据成功");
					console.log("update success");
					//$("#aaa").parent().html(data);
				},
				error:function(request){
					alert("更新数据失败");
					console.log("update error");
				}
			});
		}
		
		function test(){
			alert($('#emp').serialize());
		}
	</script>
  </head>
  
  <body>
    <!-- 插入、更新多个动作，怎么写action；如果统一改为保存，又怎么知道调用哪个API -->
    <!-- 在form提交下，只能写一个action; 所以我们用ajax提交。 -->
    <form id="emp" action="emp/insert" method="post">
    	编号：<input type="text" name="empno" value=${emp.empno} /><br/>
    	人员：<input type="text" name="ename" value=${emp.ename} /><br/>
    	工作：<input type="text" name="job" value=${emp.job} /><br/>
    	管理员：<input type="text" name="mgr" value=${emp.mgr} /><br/>
    	生日：<input type="text" name="hiredate" value=${emp.hiredate} /><br/>
    	薪水：<input type="text" name="sal" value=${emp.sal} /><br/>
    	福利：<input type="text" name="comm" value=${emp.comm} /><br/>
    	部门编号：<input type="text" name="deptno" value=${emp.deptno} /><br/>
    	部门：<input type="text" name="dname" value=${emp.dname} /><br/>
    	地点：<input type="text" name="loc" value=${emp.loc} /><br/>
    	
    	<input type="button" value="插入" onclick="insertEmp();" />
    	<input type="button" value="更新" onclick="updateEmp();" />
    	<input type="button"  value="测试" onclick="test();" />
    	<input type="submit" value="submit" />
    </form>
  </body>
</html>
