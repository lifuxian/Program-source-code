package com.jinma.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinma.bean.Goods;
import com.jinma.bean.Page;
import com.jinma.service.GoodsService;

import javafx.scene.control.Alert;

@Controller
public class GoodsController {
	// 注入Service对象
	@Autowired
	private GoodsService goodsService;

	/**
	 * 跳转到goodsManage查询所有商品（包含所有信息） 
	 * @param model
	 * @return
	 */
	@RequestMapping("goodsManage")
	public String goodsManage(HttpServletRequest request,HttpServletResponse response,Model model) {
		String pageNo = request.getParameter("pageNo");
        if (pageNo == null) {
            pageNo = "1";
        }
        Page page = goodsService.queryAllForPage(Integer.valueOf(pageNo), 5);//5表示每页多少条数据
        request.setAttribute("page", page);
		List<Goods> goodsList = page.getList();
		// 页面回显
		model.addAttribute("goodsList", goodsList);
		return "goodsManage";
	}

	/**
	 * 需求:根据Id查询商品 返回值：String(返回到只有指定Id的列表页面)
	 */
	@RequestMapping("goodsById")
	public String goodsById(HttpServletRequest request,HttpServletResponse response,Model model, Integer id) {
		//System.out.println(id);
		if (id != null) {// 接受的ID不为空 查询一个
			Goods goodsList = goodsService.findgoodsByID(id);
			if (goodsList == null) { // 如果所查数据为空，直接把所查放在model
				model.addAttribute("goodsList", goodsList);
				return "goodsManage";
			} else {// 不为空则把所查放在List<Goods>里,再放进model中
				List<Goods> list = new ArrayList<>();
				list.add(goodsList);
				model.addAttribute("goodsList", list);
				return "goodsManage";
			}
		} else {// 接收的ID为空 查询全部
			String pageNo = request.getParameter("pageNo");
	        if (pageNo == null) {
	            pageNo = "1";
	        }
	        Page page = goodsService.queryAllForPage(Integer.valueOf(pageNo), 5);//5表示每页多少条数据
	        request.setAttribute("page", page);
			List<Goods> goodsList = page.getList();
			// 页面回显
			model.addAttribute("goodsList", goodsList);
			return "goodsManage";
		}
	}
	/**
	 * 需求:根据商品名称模糊查询，并可以根据价格范围查询，所查数据按商品价格排序
	 * @param nameContain	填写的商品名称
	 * @param priceMin		价格最低价
	 * @param priceMax		价格最高价
	 */
	@RequestMapping("queryIt")
	public String queryIt(HttpServletRequest request,HttpServletResponse response,HttpSession session,
										Model model,String nameContain, Integer priceMin,Integer priceMax) {
		System.err.println("进入查询"+ nameContain+"1" + priceMin +"2"+ priceMax);
		if (nameContain != "" || priceMin != null || priceMax != null) {//接收的查询条件不为空，开始查询
			String pageNo = request.getParameter("pageNo");
	        if (pageNo == null) {
	            pageNo = "1";
	        }
	        Page page = goodsService.queryForPage(nameContain,priceMin,priceMax,Integer.valueOf(pageNo), 5);//5表示每页多少条数据
	        request.setAttribute("page", page);
	        session.setAttribute("nameContain", nameContain);
	        session.setAttribute("priceMin", priceMin);
	        session.setAttribute("priceMax", priceMax);
			List<Goods> goodsList = page.getList();
			
			System.err.println(goodsList);
			model.addAttribute("goodsList", goodsList);
			return "queryIt";
//			if (goodsList == null) { // 如果所查数据为空，直接把所查放在model
//				model.addAttribute("goodsList", goodsList);
//				return "goodsManage";
//			} else {// 不为空则把所查放在List<Goods>里,再放进model中
//				List<Goods> list = new ArrayList<>();
//				list.add((Goods) goodsList);
//				model.addAttribute("goodsList", list);
//				return "goodsManage";
//			}
		}else {// 接收的查询条件为空  则查询全部
			String pageNo = request.getParameter("pageNo");
	        if (pageNo == null) {
	            pageNo = "1";
	        }
	        Page page = goodsService.queryAllForPage(Integer.valueOf(pageNo), 5);//5表示每页多少条数据
	        request.setAttribute("page", page);
			List<Goods> goodsList = page.getList();
			// 页面回显
			model.addAttribute("goodsList", goodsList);
			return "goodsManage";
			}
		}

	@RequestMapping("saveGoods") 	// 新增
	@ResponseBody					//在此用了ResponseBody和@RequestBody则return不再被解析成页面，而是返回json数据写入HTTP响应正文中
	public String saveOrUpdateGood(@RequestBody Goods goods) {
		//System.out.println(goods);   //显示的日期格式：英文标准格式
		System.err.println("进入新增Controller");
		goodsService.save(goods);
		// 重定向到goodsManage
//		return "redirect:goodsManage";
		//返回success是string类型（text）
		return "success";
	}

	@RequestMapping("updateGoods") // 修改更新
	@ResponseBody
	public String updateGood(@RequestBody Goods goods) {
		//System.err.println("进入更新Controller");
		//System.out.println(goods);		//显示日期格式为   英文标准格式

		goodsService.updateGoods(goods);
		// 重定向到goodsDetail、不用RequestBoty
		//return "redirect:goodsDetail";
		//返回success是string类型（text）
		return "success";
	}

	/**
	 * 从goodsManage点击商品名称进行页面跳转到goodsDetail界面并显示商品详细信息
	 * @method get
	 * @param 根据ID查询商品，传回一种商品，
	 * @return goodsDetail
	 */
	@RequestMapping(value = "goodsDetail", method = RequestMethod.GET)
	public String goodsDetail(Model model, Integer id) {
		//System.out.println(id);
		Goods goods = goodsService.findgoodsByID(id);
		//System.out.println(goods);   //显示的日期格式为yyyy-MM-dd

		// 页面转到所查商品的goodsDetail商品详情界面
		model.addAttribute("goods", goods);
		return "goodsDetail";
	}

	/**
	 * 需求：删除所选
	 * 
	 * @param 根据ID查询商品，并批量删除商品
	 * @return goodsManage
	 */
	@RequestMapping("delGoods")
	public @ResponseBody String delGoods(@RequestBody String[] ids) {

		for (String str : ids) {
			System.out.println(str);
		}

		goodsService.delGoodsByIds(ids);

		return "success";
	}
}
