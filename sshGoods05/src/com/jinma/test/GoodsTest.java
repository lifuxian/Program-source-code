package com.jinma.test;

import java.util.Date;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.junit.Test;

import com.jinma.bean.Goods;

public class GoodsTest {

	@Test
	public void saveTest() {
		Configuration cfg = new Configuration();
		cfg.configure();
		SessionFactory sessionFactory = cfg.buildSessionFactory();
		Session session = sessionFactory.openSession();
		Transaction tx = session.beginTransaction();
		//编写数据
		Goods goods = new Goods();
		goods.setId(5);
		goods.setName("sixing");
		goods.setType("电子消费产品");
		goods.setPrice(4799.99f);
		goods.setNum(1);
		//这里是Date、要保证数据库字段类型也是date。
		Date date = new Date();
		goods.setCreateDate(date);
		goods.setTotal(4799.99f);
		goods.setDescription("产自韩国");
		//加入到库表中
		session.save(goods);
		//关闭session	
		tx.commit();
		session.close();
		sessionFactory.close();
		System.out.println("执行完毕");
		
		System.out.println(goods.getName());
	}
}
