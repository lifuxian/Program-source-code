package com.jinma.service;

import com.jinma.bean.Account;

public interface IAccountService {
	//添加新用户
	void add(Account account);
	//查询用户账号密码
	Account queryUser();
}
