package com.example.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.project.vo.ReviewVo;

@Mapper
public interface ReviewDao {
	
	// 전체조회
	List<ReviewVo>		selectList();
	
	// [수정] 한 식당에 여러 리뷰가 있을 수 있으므로 List로 반환해야 합니다.
    List<ReviewVo> selectOneRestaurantList(@Param("r_idx") int r_idx);
    
    // [수정] 사장이 쓴 리뷰나 관리자가 보는 리뷰도 목록일 가능성이 높으므로 List 권장
    List<ReviewVo> selectOneMemberList(@Param("m_idx") int m_idx);
	
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
	
	// 평균조회 (식당번호 r_idx를 받음)
	double selectAvgScore(@Param("r_idx") int r_idx);
	
	// 평균수정 (식당번호와 평균점수를 담은 Map을 받음)
	int updateRestaurantAvgScore(
			@Param("r_idx") int r_idx, 
			@Param("avg_score") double avg_score);
	
}	// Interface ReviewDao
