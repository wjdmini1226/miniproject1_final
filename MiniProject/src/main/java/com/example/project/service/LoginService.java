package com.example.project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.project.dao.MemberDao;
import com.example.project.dao.RestaurantDao;
import com.example.project.vo.MemberVo;
import com.example.project.vo.RestaurantVo;

@Service
public class LoginService {
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	RestaurantDao restaurantDao;
	
	@Transactional
	public int insertMember(MemberVo mVo, RestaurantVo rVo) {
		int result = memberDao.insert(mVo);
		
		if (mVo.getM_admin() == 1) {
			rVo.setR_member(mVo.getM_idx());
			
			restaurantDao.insert(rVo);
		}
		
		return result;
	}
}
