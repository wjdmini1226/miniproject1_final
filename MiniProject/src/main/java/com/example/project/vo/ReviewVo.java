package com.example.project.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("review")
public class ReviewVo {

	int			v_idx;
	int			r_idx;		//	FK
	int			m_idx;		//	FK
	// m_name 또한 foreign key 로서 필요할 수 있음
	int			v_score;
	String		v_title;
	String		v_content;
	Date		v_regdate;	
	
}	// class ReviewVo
