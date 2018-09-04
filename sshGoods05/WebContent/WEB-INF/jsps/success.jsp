<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="static/css/bootstrap.min.css">

<title>登入成功界面</title>
<style type="text/css">
	div{
      text-align: center;
      width: 370px;
      height: 180px;
      position: absolute;
      left: 50%;
      top: 40%;
      transform: translate(-50%,-40%);
	}
	a:hover{
            color:aqua;
			text-decoration:underline;
        }
        a{
        	text-decoration:none;
        }
</style>
<script type="text/javascript">
        function tiaozhuan(){
            setTimeout(function (){
                 window.location.href = "goodsManage";
             },3000)
        }
</script>
</head>
<body onload="tiaozhuan()">
<div>
	<h3>登录成功！！！</h3>
	<h3>${username}，欢迎登录商品管理系统</h3>
	登录时间：${date}
	<c:if test="${username!=null}">
		<a href="logout">退出登录</a><hr/>
		<p class="text-info">稍等片刻，自动跳转到商品管理界面。。。</p>
		<a href="goodsManage">
		<span class="text-danger">等不及了！！直接跳转</span>
		</a>
	</c:if>
	
</div>	
</body>
</html>