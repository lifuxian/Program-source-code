package com.jinma.dao;

import java.util.List;

import com.jinma.bean.Goods;
import com.jinma.bean.Page;

public interface GoodsDao {
	//分页查询所有商品
	public List<Goods> queryForPage(StringBuffer hql, int offset, int pageSize);
	//查询所有记录数
	public int getRowCount(StringBuffer hqlCount);
	//根据商品ID查询商品
	public Goods findItemsById(Integer id);
	
	//增加商品
	public void save(Goods goods);
	 //修改商品信息
	public void update(Goods goods);
	//删除商品
	public void deleteGoodsList(String[] ids);

}
