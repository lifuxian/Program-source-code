package com.jinma.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.jinma.bean.Account;
import com.jinma.service.IAccountService;
import com.jinma.util.Md5Util;

@Controller
public class AccountController {
	
	@Resource
	private IAccountService service;
	//添加用户（url传值?username=&password=）
	@RequestMapping(path = "add")
	public String add(Account account) {
		System.out.println(account.getPassword());
		account.setPassword(Md5Util.getMD5(account.getPassword()));
		service.add(account);
		return "msg";
	}
	//仅进行页面跳转到login
	@RequestMapping("loginView")
	public ModelAndView inLoginView(){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("login");
		return mav;
	}
	//仅进行页面跳转到success
	@RequestMapping("success")
	public ModelAndView inSuccess(){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("success");
		return mav;
	}
	//验证登入账号密码
	@RequestMapping(path = "login" )
	public String login(HttpSession session,String username, String password,Model model) {
		//测试输出前端输入的信息
		System.out.println(username);
		System.out.println(password);
		//从数据库查出用户名密码并打印
		Account account = service.queryUser();
		System.out.println(account.getUsername());
		System.out.println(account.getPassword());

		if (account.getUsername().equals(username) && account.getPassword().equals(password)) {
			System.out.println("验证成功");
			session.setAttribute("username", username);
			session.setAttribute("password", password);

			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
			session.setAttribute("date", df.format(new Date()));// new Date()为获取当前系统时间
			return "redirect:success";
		} else {
			System.out.println("失败");
			String failedMsg = "用户或密码错误，请重新登入";
			model.addAttribute("loginfailed",failedMsg);
			return "login";
		}
	}
	@RequestMapping(value="logout") 
	 public String logout(HttpSession session) throws Exception{ 
	  //清除Session 
	  session.invalidate(); 
	  //重定向回登录界面
	  return "redirect:loginView"; 
	 } 

}
