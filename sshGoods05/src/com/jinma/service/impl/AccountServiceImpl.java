package com.jinma.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.jinma.bean.Account;
import com.jinma.dao.IAccountDao;
import com.jinma.service.IAccountService;
@Service
public class AccountServiceImpl implements IAccountService{

	@Resource
	private IAccountDao dao;
	
	@Override
	public void add(Account account) {
		dao.add(account);
	}
	//查询用户账号密码
	@Override
	public Account queryUser() {
		Account account = dao.queryUser();
		return account;
	}

}
