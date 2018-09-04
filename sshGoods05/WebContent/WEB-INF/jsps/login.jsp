<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品管理登入界面</title>
<style type="text/css">
	.middle{
      text-align: center;
      width: 370px;
      height: 180px;
      position: absolute;
      left: 50%;
      top: 40%;
      transform: translate(-50%,-40%);
	}
</style>
<script type="text/javascript" src="static/js/jquery-2.2.3.min.js"></script>
<script type="text/javascript" src="static/js/md5.js"></script>
<script type="text/javascript">
	$(document).ready(function (){
		//md5加密
		$("#psword").blur(function(){
			var password =$(this).val()
			var md5word = hex_md5(password)
			$(this).val(md5word);
		});
		//禁用enter提交表单
		$("#form1").keypress(function(e) {
			  if (e.which == 13) {
			    return false;
			  }
		});
	});
</script>
</head>
<body>
    <div class="middle">
		<h1 align="center">欢迎登入商品管理系统</h1>
		<form id="form1" name="login_form" action="login" method="post">
			  用户名：<input type="text" name="username"/><br><br>
			  密&nbsp;&nbsp;&nbsp;码：<input type="password" id="psword" name="password"/>
			  <br>
			  <span style="color: red">${loginfailed}</span>
			  <br>
			 <input type="submit" id="login_btn" value="登入"/>
			 &nbsp;&nbsp;&nbsp;&nbsp;
			 <input type="reset" id="reset_btn" value="重置"/>
			 <c:if test="${sessionScope.username == 'admin'}">
			 	<jsp:forward page="success.jsp"/>
			 </c:if>
		</form>
    </div>
</body>
</html>