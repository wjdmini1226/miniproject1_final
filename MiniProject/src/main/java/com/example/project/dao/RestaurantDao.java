package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.jspecify.annotations.Nullable;

import com.example.project.vo.RestaurantVo;

public interface RestaurantDao {
	List<RestaurantVo>	selectList(Map<String, Object> map);
	List<RestaurantVo>	selectList2(Map map); // map용. AI:오버로딩 위험
	List<RestaurantVo>	selectList_admin();
	
	RestaurantVo		selectOne(int m_idx);
	
	public List<RestaurantVo> findSimilarRestaurant(Map map);
	
	List<RestaurantVo> searchByName(@Param("keyword") String keyword);
	
	int					insert(RestaurantVo vo);
	int					update(RestaurantVo vo);
	int					delete(int r_idx);
}
