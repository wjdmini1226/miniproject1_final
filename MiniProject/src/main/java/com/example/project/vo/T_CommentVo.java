package com.example.project.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("t_comment")
public class T_CommentVo {

    // 댓글 고유번호 
    int c_idx;

    // 작성자 회원번호 (FK)
    int c_member;

    // 게시글 번호 (FK)
    int c_board;

    // 작성일
    Date c_regdate;

    // 댓글 내용
    String c_content;

    // 계층형 댓글용 컬럼
    int c_ref;
    int c_step;
    int c_depth;
    
	
}

