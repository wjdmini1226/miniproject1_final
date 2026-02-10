package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.jspecify.annotations.Nullable;

import com.example.project.vo.RestaurantVo;
import com.example.project.vo.TestRestVo;

public interface TestRestDao {
	List<TestRestVo>	selectList(Map map);
	List<TestRestVo>	selectList_admin();
	
	TestRestVo		selectOne(int m_idx);
	
	public List<TestRestVo> findSimilarRestaurant(Map map);
	
	List<TestRestVo> searchByName(@Param("keyword") String keyword);
	
	int					insert(TestRestVo vo);
	int					update(TestRestVo vo);
	int					delete(int r_idx);
	
	
	
}
