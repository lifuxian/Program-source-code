package com.jinma.dao.impl;

import javax.annotation.Resource;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.jinma.bean.Account;
import com.jinma.dao.IAccountDao;

@Repository
public class AccountDaoImpl implements IAccountDao {

	@Resource
	private SessionFactory sessionFactory;

	@Override
	public void add(Account account) {
		Session session = sessionFactory.openSession();
		System.out.println("---------------------------------");
		session.save(account);
	}
	//查询用户账号密码
	@Override
	public Account queryUser() {
		Session session = sessionFactory.openSession();
		Account account = (Account)session.get(Account.class, 1);
		return  account;
	}

}
