<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/assets/css/store-detail/store-detail-header.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/store-detail/store-reserv.css" rel="stylesheet">

<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery-1.12.4.js"></script>

</head>

<body>
	<!-- wrap -->
	<div id="wrap" class="box-gray clearfix">

		<!-- 가게상세 해더 -->
		<c:import url="/WEB-INF/views/includes/store-detail-header.jsp"></c:import>

		<div class="store-menu">
			<ul class="clearfix">
				<li id="sel-menu"><a href="${pageContext.request.contextPath}/store/${storeNo}/orderFirst">메뉴</a></li>
				<li id="resv-list"><a href="${pageContext.request.contextPath}/store/${storeNo}/reserv">예약리스트</a></li>
				<li id="description"><a href="${pageContext.request.contextPath}/store/${storeNo}/description">가게상세정보</a></li>
				<li id="review"><a href="${pageContext.request.contextPath}/store/${storeNo}/review">리뷰</a></li>
			</ul>
		</div>
		<!-- //store menu -->


		<!-- container -->
		<div id="container" class="clearfix">
			<div id="table-description">
				* 현재 진행중인 예약건들입니다<br> * 상태란의 '대기중' 버튼을 누르면 해당 예약건에 참여하실 수 있습니다.
			</div>
			<table class="reserve-table">
				<colgroup>
					<col style="width:150px">
					<col style="width:100px">
					<col style="width:150px">
					<col style="width:170px">
					<col style="width:280px">
					<col style="width:150px">
				</colgroup>
				
				<thead>
					<tr>
						<th>예약마감</th>
						<th>참여인원</th>
						<th>인당 배달료</th>
						<th>현재 주문 금액</th>
						<th>배달지 주소</th>
						<th>상태</th>
					</tr>
				</thead>

				<c:forEach items="${map.rList}" var="rList">
				<tbody>
					<tr>
						<td>${rList.orderDate}</td>
						<td>${rList.countPeople}명 / <strong>${rList.people}</strong>명</td>
						<td><fmt:formatNumber value="${rList.pFee}" pattern="#,###" />원</td>
						<td><fmt:formatNumber value="${rList.finalPay}" pattern="#,###" />원 / <strong><fmt:formatNumber value="${rList.minPrice}" pattern="#,###" /></strong>원</td>
						<td>${rList.deliveryMAdr} ${rList.deliverySAdr}</td>
						
						<c:choose>
						<c:when test="${rList.no == authUser.no}">
							<td><a class="revise" href="${pageContext.request.contextPath}/store/${storeNo}/attend?orderNo=${rList.orderNo}&no=${authUser.no}">예약수정</a></td>
						</c:when>
						<c:otherwise>
							<td><a class="join" href="${pageContext.request.contextPath}/store/${storeNo}/attend?orderNo=${rList.orderNo}&no=${authUser.no}">대기중</a></td>
						</c:otherwise>
						</c:choose>
					</tr>
				</tbody>
				</c:forEach>
			</table>


		</div>
		<!-- //container -->

		<!-- footer -->
		<c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>
		<!-- //footer -->

	</div>
	<!-- //wrap -->

</body>

</html>