package com.jinma.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jinma.bean.Goods;
import com.jinma.dao.GoodsDao;

@Repository
public class GoodsDaoImpl implements GoodsDao{
	
	@Autowired
	private SessionFactory sessionFactory;
	public Session getSession() {
		return this.sessionFactory.getCurrentSession();
	}
	
    /**
  * 分页查询
  * @param hql 查询的条件
  * @param hqlCount 查询记录数的条件
  * @param offset 开始记录
  * @param length 一次查询几条记录
  * @return 返回查询记录集合
  */
	@SuppressWarnings("all")
	@Override	
	public List<Goods> queryForPage(StringBuffer hql,int offset, int length) {
		//查询所有的商品
		Query hqlQuery = (Query)this.getSession().createQuery(hql.toString());
		hqlQuery.setFirstResult(offset);
		hqlQuery.setMaxResults(length);  
		return hqlQuery.list();
	}
	//查询记录总数
    public int getRowCount(StringBuffer hqlCount){
        int count=((Long)this.getSession().createQuery(hqlCount.toString()).iterate().next()).intValue();
        return count;
    }

	@Override   //根据Id查询商品
	public Goods findItemsById(Integer id) {
		return (Goods) this.getSession().get(Goods.class, id);
		
	}

	@Override  //增加商品
	public void save(Goods goods) {
		this.getSession().save(goods);
	}

	@Override   //修改商品信息
	public void update(Goods goods) {
		//System.out.println(goods);
		this.getSession().update(goods);
	}

	/** 
     * 批量删除
     * @param String[] ids转Int[] ids
     */
	public void deleteGoodsList(String[] ids) {
		
		for (int i = 0; i < ids.length; i++) {
			
			Goods goods = (Goods) sessionFactory.getCurrentSession().get(Goods.class, Integer.parseInt(ids[i]));
			
			sessionFactory.getCurrentSession().delete(goods);
		}
	}
}
