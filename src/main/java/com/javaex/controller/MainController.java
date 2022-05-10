package com.javaex.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaex.service.MainService;
import com.javaex.service.MypageService;
import com.javaex.service.UserService;
import com.javaex.vo.AddressVo;
import com.javaex.vo.MainVo;
import com.javaex.vo.UserVo;

@Controller
public class MainController {
	@Autowired
	MainService mainService;

	@Autowired
	UserService userService;

	@Autowired
	private MypageService mypageService;

	@RequestMapping("/main")
	public String main(Model model, HttpSession session) {
		System.out.println("MainController.main()");

		// 서비스에서 스토어리스트를 가져온다
		List<MainVo> storeList = mainService.getStoreList();

		// 모델이 담아 jsp에 포워딩 한다
		model.addAttribute("storeList", storeList);
		System.out.println(storeList);

		// 로그인시 기본배송지쪽 좌표출력을 위해 정보뿌리기
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		if (authUser != null) {
			int no = authUser.getNo();
			model.addAttribute("no", no);
			
			AddressVo addressVo = mainService.getAddrList(no);
			model.addAttribute("addressVo", addressVo);
			System.out.println(addressVo);
		} else {
			System.out.println("비회원상태 ㅇ");
			model.addAttribute("no", -1);
			
			AddressVo addressVo = new AddressVo();
			model.addAttribute("addressVo", addressVo);
			System.out.println(addressVo);
			
		}
		return "user/main";
	}

	@ResponseBody
	@RequestMapping("/getStore")
	public MainVo getStore(@RequestParam("orderNo") int orderNo) {
		System.out.println("MainController.getStore()");
		System.out.println(orderNo);

		MainVo storeVo = mainService.getStore(orderNo);
		System.out.println("Controller.getStore: " + storeVo);

		return storeVo;
	}

	@ResponseBody
	@RequestMapping("/getStoreList")
	public List<MainVo> storeList() {
		List<MainVo> storeList = mainService.getStoreList();
		System.out.println("Controller.storeList: " + storeList);
		return storeList;
	}

}