package com.example.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("news")
public class NewsVo {
	int		n_idx;
	String	n_title;
	String	n_company;
	String	n_regdate;
	int		n_readhit;
	String	n_content;
}
