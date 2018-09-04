package com.jinma.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinma.bean.Goods;
import com.jinma.bean.Page;
import com.jinma.dao.GoodsDao;
import com.jinma.service.GoodsService;
@Transactional
@Service("GoodsService")
public class GoodsServiceImpl implements GoodsService {

	@Autowired
	private GoodsDao goodsDao;
	
    /**
     * 分页查询 
     * @param currentPage 当前页号：现在显示的页数
     * @param pageSize 每页显示的记录条数
     * @return 封闭了分页信息(包括记录集list)的Bean
     * */
	@Override  //查询所有商品
	public Page queryAllForPage(int currentPage,int pageSize) {
		Page page = new Page(); 
        //总记录数
		StringBuffer hqlCount = new StringBuffer();
		hqlCount.append("select count(*) from Goods");
        int allRow = goodsDao.getRowCount(hqlCount);
        //当前页开始记录
        int offset = page.countOffset(currentPage,pageSize);  
        //分页查询结果集
		StringBuffer hql = new StringBuffer();
		hql.append("from Goods");   //在这写hql语句，按照ID或者按照名称等模糊查找，调用同一个Dao方法
		List<Goods> goodsList = goodsDao.queryForPage(hql,offset, pageSize);
		page.setPageNo(currentPage);
        page.setPageSize(pageSize);
        page.setTotalRecords(allRow);
        page.setList(goodsList);    
		return page;
	}
	
	@Override	//根据条件查询商品
	public Page queryForPage(String nameContain, Integer priceMin, Integer priceMax, int currentPage, int pageSize) {
		Page page = new Page(); 
        //拼接hql语句查询符合条件商品的记录数
		StringBuffer hqlCount = new StringBuffer();
		hqlCount.append("select count(*) from Goods where 1=1");
		if(nameContain !=null && !"".equals(nameContain)){
			hqlCount.append(" AND name like '%"+nameContain+"%'");
		}
		if(priceMin != null && priceMax != null) {
			hqlCount.append(" AND price between '"+priceMin+"' and '"+priceMax+"'");
		}else if(priceMin != null && priceMax == null) {
			hqlCount.append(" AND price >= '"+priceMin+"'");
		}else if(priceMin == null && priceMax != null){
			hqlCount.append(" AND price <= '"+priceMax+"'");
		}
        int allRow = goodsDao.getRowCount(hqlCount);
        //当前页开始记录
        int offset = page.countOffset(currentPage,pageSize);  
        //分页查询结果集
		StringBuffer hql = new StringBuffer();
		hql.append("from Goods where 1=1");   //在这写hql语句，按照ID或者按照名称等模糊查找，调用同一个Dao方法
		if(priceMin == null && priceMax == null) {
			if(nameContain !=null && !"".equals(nameContain)){
				hql.append(" AND name like '%"+nameContain+"%' order by price asc");
			}
		}else {
			hql.append(" AND name like '%"+nameContain+"%'");
		}
		
		if(priceMin != null && priceMax != null) {
			hql.append(" AND price between '"+priceMin+"' and '"+priceMax+"' order by price asc");
		}else if(priceMin != null && priceMax == null) {
			hql.append(" AND price >= '"+priceMin+"' order by price asc");
		}else if(priceMin == null && priceMax != null){
			hql.append(" AND price <= '"+priceMax+"' order by price asc");
		}
		List<Goods> goodsList = goodsDao.queryForPage(hql,offset, pageSize);
		page.setPageNo(currentPage);
        page.setPageSize(pageSize);
        page.setTotalRecords(allRow);
        page.setList(goodsList);    
		return page;
	}
	
	//查询所有商品总记录数
	@Override
	public int getAllRowCount(){
		StringBuffer hqlCount = new StringBuffer();
		hqlCount.append("select count(*) from Goods");
        return goodsDao.getRowCount(hqlCount);
    }
	
	@Override	//根据Id查询商品
	public Goods findgoodsByID(Integer id) {
		return goodsDao.findItemsById(id);
		
	}

	@Override  //增加商品
	public void save(Goods goods) {
		goodsDao.save(goods);
	}

	@Override   //修改商品信息
	public void updateGoods(Goods goods) {
		goodsDao.update(goods);
	}

	@Override   //删除商品
	public void delGoodsByIds(String[] ids) {
		goodsDao.deleteGoodsList(ids);
	}
}
