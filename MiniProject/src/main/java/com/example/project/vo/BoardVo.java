package com.example.project.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("board")
public class BoardVo {

    // 게시글 고유번호 
    int b_idx;

    // 작성자 회원번호 (FK)
    int m_idx;

    // 제목
    String b_title;

    // 내용 
    String b_content;

    // 조회수
    int b_readhit;

    // 작성일
    Date b_regdate;

    // 수정일
    Date b_modifydate;
    
    // 공지사항 여부
    String b_is_notice; // 'Y' or 'N'
    
    // 홍보글 여부
    String b_is_ad;     // 'Y' or 'N'
    
    // 게시판에 달린 댓글 개수
    int		c_count;
}

