/*
-- 식당(test_rest)
CREATE TABLE test_rest (
t_r_idx			NUMBER			PRIMARY KEY,
t_r_member		NUMBER 			REFERENCES member(m_idx) ON DELETE CASCADE,
t_r_name			VARCHAR2(100)	NOT NULL,
t_r_category		VARCHAR2(500),
t_r_menu			VARCHAR2(2000),
t_r_avgscore		NUMBER(2,1)		DEFAULT 0 CHECK (t_r_avgscore BETWEEN 0 AND 5),
t_r_addr			VARCHAR2(300)
); 
 
CREATE SEQUENCE seq_test_rest START WITH 1; 

select * from test_rest;

*/