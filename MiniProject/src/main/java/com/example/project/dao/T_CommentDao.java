package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.project.vo.T_CommentVo;

@Mapper
public interface T_CommentDao {

    

    // 게시글별 전체 댓글 목록
    List<T_CommentVo> selectListByBoard(int c_board);
    
    //댓글 페이지 목록 처리
    List<T_CommentVo> selectPageList(Map<String, Object>map);
    
    // 댓글 1건 조회
    T_CommentVo selectOne(int c_idx);

    
    // 원댓글 등록 후 c_ref = c_idx로 맞추기
    int updateRefToSelf(@Param("c_idx") int c_idx);

    
    // 대댓글 등록 전: 같은 그룹(c_ref)에서 특정 step 이상을 +1 밀기
    int updateStepForReply(@Param("c_ref") int c_ref,
                           @Param("c_step") int c_step);

    // 대댓글 등록
    int insertReply(T_CommentVo vo);


    // 댓글 내용 수정
    int updateContent(T_CommentVo vo);

    // 댓글 삭제
    int delete(@Param("c_idx") int c_idx);

    // 게시글 삭제 시 댓글 전체 삭제
    int deleteByBoard(@Param("c_board") int c_board);
    
    
}


