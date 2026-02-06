package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.jspecify.annotations.Nullable;

import com.example.project.vo.RestaurantVo;
import com.example.project.vo.TestRestVo;

public interface TestRestDao {
	List<TestRestVo>	selectList(Map<String, Object> map);
	List<TestRestVo>	selectList_admin();
	
	TestRestVo		selectOne(int m_idx);
	
	int					insert(TestRestVo vo);
	int					update(TestRestVo vo);
	int					delete(int r_idx);
}
