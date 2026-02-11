-- 회원
CREATE TABLE member (
m_idx			NUMBER			PRIMARY KEY,
m_id			VARCHAR2(100)	NOT NULL UNIQUE,
m_pwd			VARCHAR2(100)	NOT NULL,
m_nickname		VARCHAR2(100)	NOT NULL UNIQUE,
m_admin			NUMBER(1)		DEFAULT 0 CHECK (m_admin IN (0, 1, 2)) -- 0 : 일반, 1 : 사장 2 : 관리자
);

-- 식당
CREATE TABLE restaurant (
r_idx			NUMBER			PRIMARY KEY,
r_member		NUMBER 			REFERENCES member(m_idx) ON DELETE CASCADE,
r_name			VARCHAR2(100)	NOT NULL,
r_category		VARCHAR2(500),
r_menu			VARCHAR2(2000),
r_avgscore		NUMBER(2,1)		DEFAULT 0 CHECK (r_avgscore BETWEEN 0 AND 5),
r_addr			VARCHAR2(300)
);

-- 리뷰
CREATE TABLE review (
v_idx			NUMBER			PRIMARY KEY,
v_member		NUMBER			REFERENCES member(m_idx) ON DELETE SET NULL,
v_restaurant	NUMBER			REFERENCES restaurant(r_idx) ON DELETE CASCADE,
v_score			NUMBER(1)		NOT NULL CHECK (v_score BETWEEN 1 AND 5),
v_title			VARCHAR2(100)	NOT NULL,
v_content		CLOB,
v_regdate		DATE			DEFAULT SYSDATE NOT NULL
);

-- 게시판
CREATE TABLE board (
b_idx			NUMBER			PRIMARY KEY,
b_member		NUMBER			REFERENCES member(m_idx) ON DELETE SET NULL,
b_title			VARCHAR2(100)	NOT NULL,
b_content		CLOB			NOT NULL,
b_readhit		NUMBER			DEFAULT 0,
b_regdate		DATE			DEFAULT SYSDATE NOT NULL,
b_modifydate	DATE			DEFAULT SYSDATE NOT NULL
);

-- 댓글
CREATE TABLE comment (
c_idx			NUMBER			PRIMARY KEY,
c_member		NUMBER			REFERENCES member(m_idx) ON DELETE CASCADE,
c_board			NUMBER			REFERENCES board(b_idx) ON DELETE CASCADE,
c_regdate		DATE			DEFAULT SYSDATE NOT NULL,
c_content		VARCHAR2(2000)	NOT NULL,
c_ref           INT,
c_step          INT,
c_depth         INT
);

-- 뉴스
CREATE TABLE news (
n_idx			NUMBER			PRIMARY KEY,
n_title			VARCHAR2(100)	NOT NULL,
n_company		VARCHAR2(100)	NOT NULL,
n_regdate		DATE			DEFAULT SYSDATE NOT NULL,
n_readhit		NUMBER			DEFAULT 0,
n_content		CLOB			NOT NULL
);

-- 뉴스 이미지
CREATE TABLE news_images (
n_i_idx			NUMBER			PRIMARY KEY,
n_idx			NUMBER,
n_i_name		VARCHAR2(500)	NOT NULL,

CONSTRAINT fk_news_images FOREIGN KEY(n_idx)
REFERENCES news(n_idx) ON DELETE SET NULL
);

CREATE SEQUENCE seq_member START WITH 1;

CREATE SEQUENCE seq_rest START WITH 1;

CREATE SEQUENCE seq_review START WITH 1;

CREATE SEQUENCE seq_v_img START WITH 1;

CREATE SEQUENCE seq_board START WITH 1;

CREATE SEQUENCE seq_b_img START WITH 1;

CREATE SEQUENCE seq_comment START WITH 1;

CREATE SEQUENCE seq_news START WITH 1;

CREATE SEQUENCE seq_n_img START WITH 1;