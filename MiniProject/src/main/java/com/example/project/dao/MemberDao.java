package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.project.vo.MemberVo;

@Mapper
public interface MemberDao {
	List<MemberVo>	selectList();
	
	MemberVo		selectOne(int m_idx);
	MemberVo		selectById(String m_id);
	
	int				insert(MemberVo vo);
	int				checkDuplicate(Map<String, Object> map);
	int				checkNickname(String m_nickname);
	int				update(MemberVo vo);
	int				delete(int m_idx);
}
