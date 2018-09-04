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
#list_div {
	text-align: center;
	width: 70%;
	height: auto;
	position: absolute;
	left: 50%;
	top: 5%;
	transform: translate(-50%, 0%);
}
</style>
<script type="text/javascript">
	//打开网页时加载以下项 
	$(document).ready(function() {
		loadList();
	
		//点击新增按钮add_btn，进入新增界面add_div
		$("#add_btn").click(function() {
			$("#list_div").hide();
			$("#add_div").show();
		});
	
		//全选、全不选
		$("#selectAll").click(function() {
			if (this.checked) {
				$('input[name="idBox"]').prop('checked', true);
			} else {
				$('input[name="idBox"]').prop('checked', false);
			}
		});
	
		//点击查看全部商品按钮，显示全部商品
		$("#allGoods").click(function() {
			window.location.href = "goodsManage";
		});
		
		//点击输入ID后的查询，若输入为空则弹出"请输入商品ID"
		$("#queryId").click(function(){
			if($("input[name='id']").val() == ""){
				alert("请输入要查询的商品ID");
			}
		});
		//点击输入搜索条件后后的查找商品，若输入为空则弹出"请输入搜索条件"
		$("#queryIt").click(function(){
			if($("input[name='nameContain']").val() == "" && $("input[name='priceMin']").val() == "" && 
					$("input[name='priceMax']").val() == ""){
				alert("请输入搜索条件");
			}
		});
	
		//点击“请输入商品”文本框时，清空内容
		//$("input[name='id']").focus(function(){
		//    $(this).val("");
		//  });
	
		//在新增界面，点击“日期”文本框，自动加入当前时间
/*   		$("#createDate").focus(
				function() {
					var mydate = new Date();
					var datefmt = mydate.getFullYear() + "/"
							+ (mydate.getMonth() + 1) + "/"
							+ mydate.getDate();
					$(this).val(datefmt);
				}); */ 
	
		//点击“删除所选”按钮，删除商品
		$("#del_btn").click(
				function() {
					//var id = $("input[name='idBox']:checked").val();
					var ids = "[";
					var getSelectValueMenbers = $(
							"input[name='idBox']:checked").each(
							function() {
									ids += $(this).val() + ","
							});
					//sunstr,取字符串从下标0开始length-1长度的字符串。
					ids = ids.substr(0, ids.length - 1);
					ids += "]"
	
					//alert(ids);
					if(confirm("是否删除id为"+ids+"的商品")){
						$.ajax({
							url : "delGoods",
							type : "POST",
							data : ids,
							contentType : "application/json;charset=UTF-8",
							dataType : "text",
							success : function(data) {
								alert("删除成功");
								window.location.href = "goodsManage";
							}
						});
					}
				});
	
		//在增加页面，自动根据单价、数量得到总价
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
	
		//新增界面输入验证
		$("#add_from").bootstrapValidator({
			//live: 'disabled',//验证时机，enabled是内容有变化就验证（默认），disabled和submitted是提交再验证  
			//excluded: [':disabled', ':hidden', ':not(:visible)'],//排除无需验证的控件，比如被禁用的或者被隐藏的  
			feedbackIcons : {//根据验证结果显示的各种图标  
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {//校验配置
				name : { //input的name属性
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
	
		//在新增界面点击“确认新增”按钮，验证所填数据并ajax提交数据
		$("#add_submit").click(function() {
			var bootstrapValidator = $("#add_from").data('bootstrapValidator'); //获取表单对象
			bootstrapValidator.validate();//手动触发验证
			if (bootstrapValidator.isValid()) {//获取验证结果，如果成功，执行下面代码  

				var name = $("#name").val();
				var type = $("#type").val();
				var price = $("#price").val();
				var num = $("#num").val();
				var createDate = $("#createDate").val();
				var total = $("#total").val();
				var description = $("#description").val();
				//alert(createDate);  //显示的日期格式为yyyy-MM-dd

				$.ajax({
					url : "saveGoods",
					type : "POST",
					data : JSON.stringify({
						name : name,
						type : type,
						price : price,
						num : num,
						createDate : createDate,
						total : total,
						description : description,
					}),
					contentType : "application/json;charset=UTF-8",       //我要发什么类型的数据,后端用了@Request需要标明,
					dataType : "text",          //我要想什么类型的数据,可不写自动验证
 					success : function(data) {
						alert("添加成功");
						//alert(typeof data);
						window.location.href = "goodsManage";
					}
				});
//  				alert("添加成功");
// 				window.location.href = "goodsManage";
			}//验证成功结束
		});//点击“确认新增”按钮结束
		
		//点击reset清空数据并重置校验
		$("input[type='reset']").click(function(){
			$('#add_from').bootstrapValidator('resetForm');
		});//点击reset结束
	});//页面初始化结束

	function loadList() {
		//进入页面显示商品列表界面
		$("#list_div").show();
		$("#add_div").hide();
		
		//在列表页面，根据所有商品总价获得总计
		var sum = 0.00;
		$(".to").each(function() {
			sum = sum + Number($(this).val());
			//alert(parseFloat($(this).val()));
		});
		$("#tot").text("￥" + sum.toFixed(2));
	}
</script>
</head>
<body>
	<!-- 这是商品列表DIV -->
	<div id="list_div">
		<h2>商品列表</h2>
		<br />
		<form action="goodsById" method="post">
			<big>按照商品ID查询：</big><input style="border:#aaa 1.5px solid;" type="number" name="id" placeholder="请输入商品的数字ID" /> 
			<input type="submit" id="queryId" value="查询" />&nbsp;
			<input type="button" class="btn btn-success btn-sm" id="allGoods" value="查看所有商品" /> 
		 	<input type="button" id="del_btn" value="删除所选" />&nbsp; <input type="button" id="add_btn" value="新增" />
		 </form>
		<br />
	    <form action="queryIt" method="post">
			<big>商品名称：</big><input style="border:#aaa 1.5px solid;" type="text" 
								name="nameContain" value="${nameContain}"/> 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<big>价格范围：</big><input style="width:65px; border:#aaa 1.5px solid;" type="number" name="priceMin" value="${priceMin}"/> 
			--
			<input style="width:65px; border:#aaa 1.5px solid;" type="number" name="priceMax" value="${priceMax}"/> 
			<input type="submit" id="queryIt" value="查找商品" />&nbsp;
	    </form>
		<br />

		<table class="table table-striped table-bordered table-hover">
			<thead>
				<tr>
					<th><label><input type="checkbox" value="全选"
							id="selectAll" />&nbsp;全选</label></th>
					<th>商品ID</th>
					<th>名称</th>
					<th>单价</th>
					<th>数量</th>
					<th>总价</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty goodsList}">
						<tr>
							<td colspan="6">未查到该商品</td>
						</tr>
					</c:when>
					<c:otherwise>

						<c:forEach items="${goodsList}" var="goods">

							<tr>
								<td><input type="checkbox" name="idBox"
									value="${goods.id }"></td>
								<td>${goods.id }</td>
								<td><a href="goodsDetail?id=${goods.id }">${goods.name }</a></td>
								<td><fmt:formatNumber value="${goods.price }"
										type="currency" /></td>
								<td>${goods.num }</td>
								<td><fmt:formatNumber value="${goods.total}" type="currency" />
								<input type="hidden" class="to"	value="${goods.total}"/></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
			<tfoot>
				<tr>
					<td>总计</td>
					<td colspan="5"><span id="tot"></span></td>
				</tr>
		        <tr>
		       		<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共${page.totalRecords}条记录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		       						当前第${page.pageNo}页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		       						 共${page.totalPages}页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>            
		                <a href="queryIt?pageNo=${page.topPageNo}&nameContain=${nameContain}&priceMin=${priceMin}&priceMax=${priceMax}">
		                <input type="button" name="fristPage" value="首页" /></a>
		                <c:choose>
		                  <c:when test="${page.pageNo!=1}">             
		                      <a href="queryIt?pageNo=${page.previousPageNo }&nameContain=${nameContain}&priceMin=${priceMin}&priceMax=${priceMax}">
		                      <input type="button" name="previousPage" value="上一页" /></a>                
		                  </c:when>
		                  <c:otherwise>   
		                      <input type="button" disabled="disabled" name="previousPage" value="上一页" />
		                  </c:otherwise>
		                </c:choose>
					<%--中间页--%>  
				    <%--显示6页中间页[begin=起始页,end=最大页]--%>  
				    <%--总页数没有6页--%>  
		                <c:choose>  
							<c:when test="${page.totalPages <= 6}">  
					            <c:set var="begin" value="1"/>  
					            <c:set var="end" value="${page.totalPages}"/>  
					        </c:when>  
					        <%--页数超过了6页--%>  
					        <c:otherwise>  
					            <c:set var="begin" value="${page.pageNo - 1}"/>  
					            <c:set var="end" value="${page.pageNo + 3}"/>  
					            <%--如果begin减1后为0,设置起始页为1,最大页为6--%>  
					            <c:if test="${begin -1 <= 0}">  
					                <c:set var="begin" value="1"/>  
					                <c:set var="end" value="6"/>  
					            </c:if>  
					            <%--如果end超过最大页,设置起始页=最大页-5--%>  
					            <c:if test="${end > page.totalPages}">  
					                <c:set var="begin" value="${page.totalPages - 5}"/>  
					                <c:set var="end" value="${page.totalPages}"/>  
					            </c:if>  
					        </c:otherwise>  
					    </c:choose>  
					    <%--遍历--%>
					    <ul class="pagination pagination-sm">
					    <c:forEach var="i" begin="${begin}" end="${end}">  
					        <%--当前页,选中--%>  
					        <c:choose>  
					            <c:when test="${i == page.pageNo}">  
					                <li class="active"><a href="#">${i}</a></li>  
					            </c:when>  
					            <%--不是当前页--%>  
					            <c:otherwise>  
					                <li><a href="queryIt?pageNo=${i}&nameContain=${nameContain}&priceMin=${priceMin}&priceMax=${priceMax}">${i}</a></li>  
					            </c:otherwise>  
					        </c:choose>  
					    </c:forEach> 
					    </ul> 
		                <c:choose>
		                  <c:when test="${page.pageNo != page.totalPages}">
		                    <a href="queryIt?pageNo=${page.nextPageNo }&nameContain=${nameContain}&priceMin=${priceMin}&priceMax=${priceMax}">
		                    <input type="button" name="nextPage" value="下一页" /></a>
		                  </c:when>
		                  <c:otherwise>    
		                      <input type="button" disabled="disabled" name="nextPage" value="下一页" />
		                  </c:otherwise>
		                </c:choose>
		                <a href="queryIt?pageNo=${page.bottomPageNo}&nameContain=${nameContain}&priceMin=${priceMin}&priceMax=${priceMax}">
		                <input type="button" name="lastPage" value="尾页" /></a>
		            </td>
		        </tr>				
			</tfoot>
		</table>
	</div>

	<!-- 这是新增界面DIV -->
	<div id="add_div" class="container">
		<div class="row">
			<section>
			<div class="col-lg-8 col-lg-offset-2">
				<div class="page-header">
					<h2>商品新增</h2>
				</div>

				<form action="saveGoods" class="form-horizontal" id="add_from">
					<div class="form-group">
						<label class="col-lg-3 control-label">名 称：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="name" name="name"
								placeholder="请输入商品名称" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">类 型：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="type" name="type"
								placeholder="请输入商品类型" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">单 价：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="price" name="price"
								placeholder="仅填写价格数字" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">数 量：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="num" name="num"
								placeholder="仅填写数量数字" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">日 期：</label>
						<div class="col-lg-5">
							<input type="date" class="form-control" id="createDate"
								name="createDate" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">总 价：</label>
						<div class="col-lg-5">
							<input type="text" readonly="readonly" class="form-control"
								id="total" name="total" placeholder="输入单价、数量后自动计算" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-lg-3 control-label">描 述：</label>
						<div class="col-lg-5">
							<input type="text" class="form-control" id="description"
								name="description" placeholder="请输入商品描述" />
						</div>
					</div>
					<div class="form-group">
						<div class="col-lg-9 col-lg-offset-3">
							<input type="button" class="btn btn-success btn-sm"
								id="add_submit" value="确定新增" /> <input type="button"
								class="btn btn-info btn-sm" value="返回" onclick="loadList()" /> <input
								type="reset" class="btn btn-info btn-sm" value="清空" />
						</div>
					</div>
				</form>

			</div>
			</section>
		</div>
	</div>
</body>
</html>