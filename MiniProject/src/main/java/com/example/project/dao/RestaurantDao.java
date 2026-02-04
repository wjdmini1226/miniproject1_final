package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.jspecify.annotations.Nullable;

import com.example.project.vo.RestaurantVo;

public interface RestaurantDao {
	List<RestaurantVo>	selectList(Map<String, Object> map);
	List<RestaurantVo>	selectList_admin();
	
	RestaurantVo		selectOne(int m_idx);
	
	int					insert(RestaurantVo vo);
	int					update(RestaurantVo vo);
	int					delete(int r_idx);
}
