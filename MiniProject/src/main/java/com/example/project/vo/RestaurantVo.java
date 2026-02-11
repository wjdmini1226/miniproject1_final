package com.example.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("restaurant")
public class RestaurantVo {
	int		r_idx;
	int		r_member;
	String	r_name;
	String	r_category;
	String	r_menu;
	double	r_avgscore;
	String	r_addr;
	int		r_v_count;
	int 	calc_avgscore;
}
