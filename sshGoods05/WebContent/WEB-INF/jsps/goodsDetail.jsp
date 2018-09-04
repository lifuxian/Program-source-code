<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>商品管理</title>
<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/bootstrapValidator.min.css">

<script type="text/javascript" src="static/js/jquery-2.2.3.min.js"></script>
<script type="text/javascript" src="static/js/jquery.form.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap.min.js"></script>
<script type="text/javascript" src="static/js/bootstrapValidator.min.js"></script>

<style type="text/css">
#detail_div {
	text-align: center;
	width: 35%;
	height: auto;
	position: absolute;
	left: 50%;
	top: 20%;
	transform: translate(-50%, -20%);
}
</style>
<script type="text/javascript">
	//打开网页时加载以下项 
	$(document).ready(
	function() {
		loadGoodsDetail();

		//点击“修改”按钮update_btn，进入修改界面update_div
		$("#update_btn").click(function() {
			//只显示修改div
			$("#detail_div").hide();
			$("#update_div").show();
		});

		//在修改界面，点击“日期”文本框时，若原文本框为空，则自动加入当天时间
/* 		$("#createDate").focus(
				function() {
					//alert($(this).val());   为空
					if ($(this).val() == "") {
						var mydate = new Date();
						var datefmt = mydate.getFullYear() + "-"
								+ (mydate.getMonth() + 1) + "-"
								+ mydate.getDate();
						$(this).val(datefmt);
					}
				}); */

		//在修改页面，自动根据单价、数量得到总价
		$("#price").blur(function() {
			var v1 = parseFloat($("#price").val());
			var v2 = parseFloat($("#num").val());
			if ($("#price").val() == "") {
				$("#total").val("");
			} else if (v1 && v2) {
				var v3 = (v1 * v2).toFixed(2);
				$("#total").val(v3);
			}
		});
		$("#num").blur(function() {
			var v1 = parseFloat($("#price").val());
			var v2 = parseFloat($("#num").val());

			if ($("#num").val() == "") {
				//alert("2");
				$("#total").val("");
			} else if (v1 && v2) {
				var v3 = (v1 * v2).toFixed(2);
				$("#total").val(v3);
			}
		});
		//返回商品列表界面
		$("#back_goodsManage").click(function() {
			window.location.href = "goodsManage";
		});

		//修改界面输入验证
		$("#update_from").bootstrapValidator({
			//live : 'disabled',//验证时机，enabled是内容有变化就验证（默认），disabled和submitted是提交再验证  
			//excluded: [':disabled', ':hidden', ':not(:visible)'],//排除无需验证的控件，比如被禁用的或者被隐藏的
			//message: 'This value is not valid',   		//默认验证消息
			feedbackIcons : { //根据验证结果显示的各种图标  
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {//验证栏目
				name : { /*键名username和input name值对应*/
					validators : {//验证规则
						notEmpty : {//检测非空,radio也可用  
							message : '商品名称必须填写'
						}
					}
				},
				price : {
					validators : {//验证规则
						regexp : {//正则验证  
							regexp : /^[0-9_\.]+$/,
							message : '商品价格只能输入数字'
						}
					}
				},
				num : {
					validators : {//验证规则
						regexp : {//正则验证  
							regexp : /^[0-9_\.]+$/,
							message : '商品数量只能输入数字'
						}
					}
				}
			}
		});

		//在修改界面点击“确认修改”按钮，进行ajax提交数据并进行修改
		$("#update_submit").click(
			function() {
				//alert("点击了");
				var bootstrapValidator = $("#update_from").data('bootstrapValidator'); //获取表单对象
				bootstrapValidator.validate();//手动触发验证
				if (bootstrapValidator.isValid()) {//获取验证结果，如果成功，执行下面代码  

					//alert("验证了");//验证成功后的操作，如ajax
					var id = ${goods.id};
					var name = $("#name").val();
					var type = $("#type").val();
					var price = $("#price").val();
					var num = $("#num").val();
					var createDate = $("#createDate").val();
					var total = $("#total").val();
					var description = $("#description").val();
					//alert(id);
					//alert(createDate);	//显示日期格式为    yyyy-MM-dd
					

					$.ajax({
						url : "updateGoods",
						type : "POST",
						data :JSON.stringify({
							id : id,
							name : name,
							type : type,
							price : price,
							num : num,
							createDate : createDate,
							total : total,
							description : description,
						}),
						contentType : "application/json;charset=UTF-8",
						dataType : "text",
 						success : function(data) {
							alert("修改成功");
							window.location.href = "goodsDetail?id=${goods.id}";
						}
					});
//  					alert("修改成功");
//  					window.location.href = "goodsDetail?id=${goods.id}";
				}
			});//点击“确认修改”按钮按钮结束
		
		
	});   //页面初始化结束
		function loadGoodsDetail() {
			//进入页面显示商品详情列表且加载商品详细信息
			$("#detail_div").show();
			$("#update_div").hide();
		}
</script>
</head>
<body>
	<!-- 这是商品详细信息DIV -->
	<div id="detail_div">
		<h2>商品详细信息</h2>
		<br>
		<table class="table table-striped table-bordered table-hover">
			<tr>
				<td>商品Id</td>
				<td>${goods.id }</td>
			</tr>
			<tr>
				<td>名称</td>
				<td>${goods.name }</td>
			</tr>
			<tr>
				<td>类型</td>
				<td>${goods.type }</td>
			</tr>
			<tr>
				<td>单价</td>
				<td>${goods.price }</td>
			</tr>
			<tr>
				<td>数量</td>
				<td>${goods.num }</td>
			</tr>
			<tr>
				<td>创建日期</td>
				<td>${goods.createDate}</td>
			</tr>
			<tr>
				<td>总价</td>
				<td><fmt:formatNumber value="${goods.total }"
						type="currency" /></td>
			</tr>
			<tr>
				<td>描述</td>
				<td>${goods.description }</td>
			</tr>
			<tr>
				<td>操作</td>
				<td><input type="button" id="update_btn" value="修改" />&nbsp; 
					<input type="button" id="back_goodsManage" value="返回" /></td>
			</tr>
		</table>
	</div>

	<!-- 这是修改界面DIV -->
	<div id="update_div" class="container">
		<div class="row">
			<section>
			<div class="col-lg-8 col-lg-offset-2">
				<div class="page-header">
					<h2>商品修改</h2>
				</div>

				<form action="updateGoods" class="form-horizontal" id="update_from">
					<div class="form-group">
						<label class="col-lg-3 control-label">名 称：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="name" name="name"
								value="${goods.name }" placeholder="请输入商品名称" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">类 型：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="type" name="type"
								value="${goods.type }" placeholder="请输入商品类型" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">单 价：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="price" name="price"
								value="${goods.price }" placeholder="仅填写价格数字" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">数 量：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="num" name="num"
								value="${goods.num }" placeholder="仅填写数量数字" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">创建日期：</label>
						<div class="col-lg-5">
							<input type="date" class="form-control" id="createDate"
								name="createDate" value="${goods.createDate }"/>		<!-- 这里日期显示格式为yyyy-MM-dd -->
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">总 价：</label>
						<div class="col-lg-5">
							
							<input type="text" readonly="readonly" class="form-control"
								id="total" name="total"
								value="${goods.total }" placeholder="自动计算" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">描 述：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="description"
								name="description" value="${goods.description }"
								placeholder="请输入商品描述" />
						</div>
					</div>
					<div class="form-group">
						<div class="col-lg-9 col-lg-offset-3">
							<input type="button" class="btn btn-success btn-sm" id="update_submit" value="确定修改" />
							&nbsp;&nbsp;&nbsp;
							<input type="button" class="btn btn-info btn-sm" value="返回" onclick="loadGoodsDetail()"/>
						</div>
					</div>
				</form>

			</div>
			</section>
		</div>
	</div>
	</div>
</body>
</html>
