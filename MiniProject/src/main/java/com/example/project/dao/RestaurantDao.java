package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.jspecify.annotations.Nullable;

import com.example.project.vo.RestaurantVo;

public interface RestaurantDao {
	List<RestaurantVo>	selectList(Map<String, Object> map);
	// selectList2도 아직 안 쓰는 건 아니니 지우지 않음
	List<RestaurantVo>	selectList2(Map map); // map용. AI:오버로딩 위험
	List<RestaurantVo>	selectList_admin();
	
	RestaurantVo		selectOne(int m_idx);
	
	public List<RestaurantVo> findSimilarRestaurant(Map map);
	
	List<RestaurantVo> searchByName(@Param("keyword") String keyword);
	
	List<RestaurantVo> selectListByPlaceId(String r_place_id);
	
	int					insert(RestaurantVo vo);
	int					update(RestaurantVo vo);
	int					delete(int r_idx);	
	
}
