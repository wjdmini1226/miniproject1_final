package com.example.project.util;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.project.dao.NewsImagesDao;
import com.example.project.vo.NewsImageVo;

import jakarta.servlet.ServletContext;

public class NewsImagesUtil {
	public static void insert(NewsImagesDao newsImagesDao,String image,int n_idx) {
		List<NewsImageVo> orphans = newsImagesDao.selectOrphanName(image);
		NewsImageVo niv;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("n_idx", n_idx);
		map.put("n_i_name",image);
		NewsImageVo exist = newsImagesDao.selectRelation(map);
		if(exist!=null) {
			orphans.forEach(orphan->newsImagesDao.delete(orphan.getN_i_idx()));
			return;
		}
		if(orphans.isEmpty()) {
			niv = new NewsImageVo();
			niv.setN_i_name(image);
			niv.setN_idx(n_idx);
			newsImagesDao.insert(niv);
		}else {
			niv = orphans.remove(0);
			niv.setN_idx(n_idx);
			newsImagesDao.update(niv);
			orphans.forEach(orphan->newsImagesDao.delete(orphan.getN_i_idx()));
		}
	}
	public static boolean delete(NewsImagesDao newsImagesDao,ServletContext application,String filename) {
		boolean bResult = false;
		// 사용되지 않는 이미지가 아니라면 삭제되지 않게
		boolean using = !newsImagesDao.selectName(filename).isEmpty();
		System.out.println(filename);
		if(!using) {
			String webPath = "/news_images/";
			String absPath = application.getRealPath(webPath);
			File f = new File(absPath, filename);
			bResult = f.delete();
			for(NewsImageVo vo:newsImagesDao.selectOrphanName(filename))
				newsImagesDao.delete(vo.getN_i_idx());
		}
		return bResult;
	}
}
