package com.jinma.service;

import java.util.List;

import com.jinma.bean.Goods;
import com.jinma.bean.Page;

public interface GoodsService {
      
	//分页查询全部商品 
	public Page queryAllForPage(int currentPage,int pageSize);
	//分页查询所有商品的总记录数
	public int getAllRowCount();

	public Goods findgoodsByID(Integer id);

	public void save(Goods goods);

	public void updateGoods(Goods goods);

	public void delGoodsByIds(String[] ids);
	//按条件分页查询商品
	Page queryForPage(String nameContain, Integer priceMin, Integer priceMax, int currentPage, int pageSize);

}
