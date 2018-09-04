package com.jinma.bean;

import java.util.Date;

import javax.persistence.Column;

public class Goods {
	//商品id
	private Integer id;
	//商品名称
	private String name;
	//商品类型
	private String type;
	//商品单价
	@Column(name = "price",precision = 10,scale = 2)
	private Float price;
	//商品数量
	private Integer num;
	//创建日期
	private Date createDate;
	//总价
	@Column(name = "total",precision = 10,scale = 2)
	private Float total;
	//商品描述
	private String description;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Float getPrice() {
		return price;
	}
	public void setPrice(Float price) {
		this.price = price;
	}
	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Float  getTotal() {
		return total;
	}
	public void setTotal(Float total) {
		this.total = total;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	@Override
	public String toString() {
		return "Goods [id=" + id + ", name=" + name + ", type=" + type + ", price=" + price + ", num=" + num
				+ ", createDate=" + createDate + ", total=" + total + ", description=" + description + "]";
	}

}
