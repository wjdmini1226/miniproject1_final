package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.project.vo.NewsImageVo;

@Mapper
public interface NewsImagesDao {
	int insertNull(String n_i_name);
	int insert(NewsImageVo vo);
	NewsImageVo select(int n_i_idx);
	NewsImageVo selectRelation(Map<String, Object> map);
	List<NewsImageVo> selectNews(int n_idx);
	List<NewsImageVo> selectName(String n_i_name);
	List<NewsImageVo> selectOrphanName(String n_i_name);
	List<NewsImageVo> selectOrphans();
	List<String> getNames();
	int update(NewsImageVo vo);
	int delete(int n_i_idx);
	int deleteNews(int n_idx);
}
