package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.project.vo.NewsVo;

@Mapper
public interface NewsDao {
	int insert(NewsVo vo);
	List<NewsVo> selectPageList(Map<String,Integer> map);
	int selectRowTotal();
	NewsVo selectOne(int n_idx);
	int update(NewsVo vo);
	int read_update(int n_idx);
	int delete(int n_idx);
}
