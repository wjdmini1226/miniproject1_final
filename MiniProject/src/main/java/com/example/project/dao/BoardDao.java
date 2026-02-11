package com.example.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.project.vo.BoardVo;

@Mapper
public interface BoardDao {

    

    // 게시글 목록조회 
    List<BoardVo> selectList();


    // 게시글 1건 조회
    BoardVo selectOne(int b_idx);

    //검색해서 조회
    List<BoardVo> selectConditionList(Map<String, Object>map);
    
    // 게시글 등록
    int insert(BoardVo vo);


    // 게시글 수정
    int update(BoardVo vo);

    // 조회수 증가
    int updateReadHit(int b_idx);


    // 게시글 삭제
    int delete(int b_idx);
    
    //전체 게시물수 구하기
  	int selectRowTotal(Map<String, Object> map);
    
}
