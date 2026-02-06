package com.example.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("test_rest")
public class TestRestVo {
	int		t_r_idx;
	int		t_r_member;
	String	t_r_name;
	String	t_r_category;
	String	t_r_menu;
	double	t_r_avgscore;
	String	t_r_addr;
	int		t_r_v_count;
}
