package com.example.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("member")
public class MemberVo {
	int		m_idx;
	String	m_id;
	String	m_pwd;
	String	m_nickname;
	int		m_admin;
}
