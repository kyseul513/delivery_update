package com.javaex.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaex.service.OrderService;
import com.javaex.service.StoreDetailService;
import com.javaex.vo.CoOrderInfoVo;
import com.javaex.vo.OrderVo;
import com.javaex.vo.POrderVo;
import com.javaex.vo.UserVo;

@Controller
@RequestMapping("/store/{storeNo}/")
public class StoreDetailController {

	@Autowired
	private StoreDetailService storeDetailService;

	@Autowired
	OrderService orderService;

	// 예약리스트
	@RequestMapping("reserv")
	public String reserv(@PathVariable("storeNo") int storeNo, Model model) {
		// System.out.println("reservation");

		Map<String, Object> reservList = storeDetailService.reservList(storeNo);
		model.addAttribute("map", reservList);
		System.out.println("reserv: " + reservList);

		return "store-detail/store-reserv";
	}

	// 예약리스트에서 대기중 클릭
	@RequestMapping("attend")
	public String attend(@RequestParam(value = "orderNo", required = false, defaultValue = "0") int orderNo,
						@RequestParam(value = "no", required = false, defaultValue = "0") int no,
						@PathVariable("storeNo") int storeNo, Model model) {

		// 로그인 안되어 있는 경우 loginForm으로 이동
		if (no == 0) {

			return "user/loginForm";

			// 로그인 되어있는 경우 p_order_no 존재하는지 확인.
		} else {

			OrderVo orderVo = new OrderVo();
			orderVo.setOrderNo(orderNo);
			orderVo.setNo(no);
			orderVo.setStoreNo(storeNo);

			int pOrderNo = storeDetailService.attend(orderVo);
			System.out.println("Controller.resultNo: " + pOrderNo);

			// p_order_no가 없는 경우 해당 오더 참여페이지로 이동.
			if (pOrderNo == 0) {

				model.addAttribute("orderVo", orderVo);
				return "redirect:orderJoin?orderNo=" + orderNo;

				// p_order_no가 있는 경우 host인지 attendee인지 확인.
			} else {

				int attendVfy = storeDetailService.attendVfy(orderVo);
				System.out.println("controller.attendVfy: " + attendVfy);

				// attendVfy가 0, 즉 호스트인 경우 호스트의 오더 수정 페이지로 이동.
				if (attendVfy == 0) {

					Map<String, Object> orderInfoMap = storeDetailService.menuList(orderVo);
					model.addAttribute("map", orderInfoMap);

					// System.out.println("controller.host: " + orderInfoMap);

					return "store-detail/order-change-host";

					// attendVfy가 1, 즉 참가자인 경우 참가자의 오더 수정 페이지로 이동.
				} else {

					Map<String, Object> orderInfoMap = storeDetailService.menuList(orderVo);
					model.addAttribute("map", orderInfoMap);

					//System.out.println("controller.attendee: " + orderInfoMap);

					return "store-detail/order-change-attendee";

				}
			}
		}
	}

	// 예약변경페이지에서 기존메뉴의 x버튼 클릭.
	@ResponseBody
	@RequestMapping("delete")
	public String delete(@RequestBody POrderVo pOrderVo) {
		System.out.println("controller: " + pOrderVo);

		String result = storeDetailService.delete(pOrderVo);

		return result;
	}

	// host, attendee 예약 수정
	@ResponseBody
	@RequestMapping("hOrderRevise")
	public String hOrderRevise(@RequestBody CoOrderInfoVo hrVo) {
		System.out.println("[OrderController.orderInfo]");
		System.out.println(hrVo);

		storeDetailService.hOrderRevise(hrVo);

		return "true";

	}

	// attendee 예약 취소
	@ResponseBody
	@RequestMapping("orderCancel")
	public String orderCancel(@RequestBody POrderVo vo) {
		System.out.println(vo);

		String result = storeDetailService.orderCancel(vo);
		System.out.println(result);

		return result;
	}

	// 결제
	@RequestMapping("/payOrderChange")
	public String pay(HttpSession session, Model model) {
		System.out.println("[OrderController.pay]");

		UserVo authUser = (UserVo) session.getAttribute("authUser");
		int no = authUser.getNo();

		Integer myPoint = orderService.getPoint(no);
		model.addAttribute("myPoint", myPoint);
		return "store-detail/payOrderChange";

	}

	// 결제페이지 기존 오더건 불러오기
	@ResponseBody
	@RequestMapping("existingInfo")
	public Map<String, Object> existingInfo(int pOrderNo) {

		Map<String, Object> eList = storeDetailService.existingInfo(pOrderNo);

		return eList;
	}

	// 가게상세정보
	@RequestMapping("description")
	public String description(@PathVariable("storeNo") int storeNo, Model model) {
		System.out.println(storeNo);

		Map<String, Object> map = storeDetailService.description(storeNo);
		model.addAttribute("map", map);

		return "store-detail/store-description";
	}

	// 리뷰
	@RequestMapping("review")
	public String storeReview(@PathVariable("storeNo") int storeNo, Model model) {

		Map<String, Object> reviewInfo = storeDetailService.review(storeNo);
		model.addAttribute("map", reviewInfo);
		System.out.println(reviewInfo);

		return "store-detail/store-review";
	}

}