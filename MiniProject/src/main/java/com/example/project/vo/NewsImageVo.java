package com.example.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("news_image")
public class NewsImageVo {
	int n_i_idx;
	int n_idx;
	String n_i_name;
}
