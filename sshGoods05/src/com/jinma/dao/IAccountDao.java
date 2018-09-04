package com.jinma.dao;

import com.jinma.bean.Account;

public interface IAccountDao {
	void add(Account account);
	//查询用户账号密码
	Account queryUser();
}
