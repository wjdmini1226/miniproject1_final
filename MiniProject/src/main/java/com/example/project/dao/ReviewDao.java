package com.example.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.project.vo.ReviewVo;

@Mapper
public interface ReviewDao {
	
	// 전체조회
	List<ReviewVo>		selectList();
	
	// 개별리뷰조회(식당번호)
	ReviewVo			selectOneRestaurantList(@Param("r_idx") int r_idx);
	
	// 개별리뷰조회(회원번호 즉 사장)
	ReviewVo			selectOneMemberList(@Param("m_idx") int m_idx);
	
	// 개별리뷰조회(리뷰번호)
	ReviewVo			selectOneReview(@Param("v_idx") int v_idx);
	
	// 입력
	int				insert(ReviewVo vo);
	
	// 수정
	int				update(ReviewVo vo);
	
	// 삭제
	int				delete(int v_idx);
	
	/* 삭제대안
	int 			updateNoUse(int v_idx);
	*/
	
}	// Interface ReviewDao
