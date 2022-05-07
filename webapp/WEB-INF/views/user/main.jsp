
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가게예약</title>
<link href="${pageContext.request.contextPath}/assets/css/total.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main-map.css" rel="stylesheet">


<script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/jquery/jquery-1.12.4.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/bootstrap/js/bootstrap.js"></script>

</head>

<body>
	<!-- wrap -->
	<div id="wrap" class="clearfix">

		<!-- 가게상세 해더 -->
		<c:import url="/WEB-INF/views/includes/customer-header.jsp"></c:import>
		<div id=wrap2 class="cleafix">

			<!-- 가게정보 -->
			<div id="listtitle">
				<h1>주변 예약 현황</h1>
			</div>

			<div id="map-area" class="clearfix">
				<div id="map" class="clearfix"></div>
			</div>
			<div id="store-info-area">
				<table id="store-info">

					<colgroup>
						<col width="20%">
						<col width="18%">
						<col width="">
					</colgroup>

					<tr>
						<c:choose>
							<c:when test="${empty storeList[0].logoImg }">
								<td id="logoimg" rowspan="5"><img id="storeLogo" src="${pageContext.request.contextPath}/assets/images/store_default.JPG"></td>
							</c:when>
							<c:otherwise>
								<td id="logoimg" rowspan="5"><img id="storeLogo" src="${pageContext.request.contextPath}/upload/${storeList[0].logoImg}"></td>
							</c:otherwise>
						</c:choose>
						<th id="name" colspan="2">${storeList[0].storeName }</th>
					</tr>
					<tr>
						<th>예약 인원</th>
						<td id="delivery-num">${storeList[0].countPeople }명/${storeList[0].people }명</td>
					</tr>
					<tr>
						<th>개인 배달료</th>
						<td id="pFee"><fmt:formatNumber value="${storeList[0].pFee }" pattern="#,###" />원</td>
					</tr>
					<tr>
						<th>배달지 주소</th>
						<td id="delivery-address">${storeList[0].deliveryMAdr }</td>
					</tr>
					<tr>
						<th>가게 전화번호</th>
						<td id="delivery-hp">${storeList[0].storePhone}</td>
					</tr>
					<tr>
						<td colspan="3"><a href="${pageContext.request.contextPath}/store/${storeList[0].storeNo}/attend" id="reserve-btn">예약하러 가기</a></td>
					</tr>

				</table>
			</div>

			<!-- /가게정보 -->
		</div>
		<!-- 가게리스트 -->
		<!-- container -->
		<div id="container" class="clearfix">
			<c:forEach items="${storeList}" var="storeVo" varStatus="status">

				<div id="storelist" class="clearfix">
					<c:choose>
							<c:when test="${empty storeVo.logoImg }">
								<img id="storelistLogo" src="${pageContext.request.contextPath}/assets/images/store_default.JPG">
							</c:when>
							<c:otherwise>
								<img id="storelistLogo" src="${pageContext.request.contextPath}/upload/${storeVo.logoImg}">
							</c:otherwise>
						</c:choose>
					 ${storeVo.storeName} <br> ${storeVo.countPeople }명/${storeVo.people } 명<br>
					<button type="button" class="click" data-orderno="${storeVo.orderNo}">상세정보보기</button>
				</div>
			</c:forEach>
		</div>
	</div>
	<br>
	<!-- footer -->
	<c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>
	<!-- //footer -->

	<!-- //wrap -->
</body>


<script>
console.log(${no})
console.log("//////////////////")

	
//가게 상세정보 버튼 클릭할때
$('.click').on("click", function() {
	console.log("상세정보보기 버튼 클릭"); 
	
	
	//가게번호 알기
	var orderNo = $(this).data("orderno");
	console.log(orderNo);
	
	
	$.ajax({
		
		url : "${pageContext.request.contextPath }/getStore",		
		type : "post",
		/* contentType : "application/json", */
		data : {orderNo: orderNo}, 
 
		dataType : "json",
		success : function(storeVo){
			/*성공시 코드*/
			console.log(storeVo);
				
				//로고
				if(storeVo.logoImg == null){
					$("#storeLogo").attr("src", "${pageContext.request.contextPath}/assets/images/store_default.JPG");
				} else {
					$("#storeLogo").attr("src", "${pageContext.request.contextPath}/upload/"+storeVo.logoImg);	
				}
				$("#name").text(storeVo.storeName);
				$("#delivery-num").text(storeVo.countPeople + "명/" + storeVo.people+"명");
				$("#pFee").text(storeVo.pFee.toLocaleString() + "원")
				$("#delivery-address").text(storeVo.deliveryMAdr);
				$("#delivery-hp").text(storeVo.storePhone);
				
				if(storeVo.countPeople>=storeVo.people){
					$("#reserve-btn").text("예약이 꽉찼습니다")	;	
					$("#reserve-btn").attr("id","reserv-full");
					$("#reserv-full").removeAttr("href");
				}else{

					$("#reserve-btn").attr("href", "${pageContext.request.contextPath}/store/"+ storeVo.storeNo +"/attend");
				}
		},
		error : function(XHR, status, error) {
			console.error(status + " : " + error);
		}
	});
	
});
	 
	if(${no}<0){
		console.log("비회원")
	}else{
		console.log("회원")
		}
//로딩될때 지도에 마커표시
function initMap() {
	if(${no}<0) {///////////////////비회원상태 지도
		// 지도 초기값
		const map = new google.maps.Map(document.getElementById("map"), {
			zoom : 15,
			center : {
				lat : 37.48140579914052,
				lng : 126.95269053971082
			},
		});

	
	
		//마케위에 표시됨
		var infowindow = new google.maps.InfoWindow();
	
		//마커 출력
		var locations = getStoreList();  //
		//마커
		for (var i = 0; i < locations.length; i++) {
			var marker = new google.maps.Marker({
				map: map,
				
				position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
			});
	    
			
			//클릭한 스토어 정보
			var storeVo;
			
			//지도가 로딩될때
			google.maps.event.addListener(marker, 'click', (function(marker, i) {
					return function() {
					
					storeVo = locations[i];
					
					infowindow.setContent(storeVo.place);
					//인포윈도우가 표시될 위치
					infowindow.open(map, marker);
					
					
				}
			})(marker, i));
	         
			//마커를 클릭했을때
	        if (marker) {
				marker.addListener("click", function(getStoreList) {   
					//중심 위치를 클릭된 마커의 위치로 변경
					map.setCenter(this.getPosition());
					//마커 클릭 시의 줌 변화
					map.setZoom(17);
					/*	window.open('http://https://www.google.com/');*/
					console.log("지도마커클릭")
				
					var orderNo = storeVo.orderno;
					console.log(orderNo);
					
					
					$.ajax({
						
						url : "${pageContext.request.contextPath }/getStore",		
						type : "post",
						/* contentType : "application/json", */
						data : {orderNo: orderNo},
				 
						dataType : "json",
						success : function(storeVo){
							/*성공시 처리해야될 코드 작성*/
							
							console.log(storeVo);
							//로고
							if(storeVo.logoImg == null){
								$("#storeLogo").attr("src", "${pageContext.request.contextPath}/assets/images/store_default.JPG");
							} else {
								$("#storeLogo").attr("src", "${pageContext.request.contextPath}/upload/"+storeVo.logoImg);	
							}
							$("#name").text(storeVo.storeName);
							$("#delivery-num").text(storeVo.countPeople + "명/" + storeVo.people+"명");
							$("#pFee").text(storeVo.pFee.toLocaleString() + "원")
							$("#delivery-address").text(storeVo.deliveryMAdr);
							$("#delivery-hp").text(storeVo.storePhone);
							
							if(storeVo.countPeople>=storeVo.people){
								$("#reserve-btn").removeAttr("href");
								$("#reserve-btn").attr("id", "reserv-full")	;			
								$("#reserve-btn").text("예약꽉참")	;			
	
								}else{
									
								$("#reserve-btn").attr("href", "${pageContext.request.contextPath}/store/"+ storeVo.storeNo +"/reserv");
							
							}	
							
						},
						error : function(XHR, status, error) {
							console.error(status + " : " + error);
						}
					});
					/* ajax */
					
				}); 
				/* marker.addListener */
				
			}/* if */
		
		}/*for */
//////////////////////////////////////////////
////로그인상태 지도
	}else{
		
		const map = new google.maps.Map(document.getElementById("map"), {
			zoom : 15,
			center : {
				lat : ${addressVo.lat},
				lng : ${addressVo.lng}
			},
		});
		
		var addrVo
		
		
		//마케위에 표시됨
		var infowindow = new google.maps.InfoWindow();

		//마커 출력
		var locations = getStoreList();  //
		//마커
		for (var i = 0; i < locations.length; i++) {
			var marker = new google.maps.Marker({
				map: map,
				
				position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
			});
	    
			
			//클릭한 스토어 정보
			var storeVo;
			
			//지도가 로딩될때
			google.maps.event.addListener(marker, 'click', (function(marker, i) {
					return function() {
					
					storeVo = locations[i];
					
					infowindow.setContent(storeVo.place);
					//인포윈도우가 표시될 위치
					infowindow.open(map, marker);
					
					
				}
			})(marker, i));
	         
			//마커를 클릭했을때
	        if (marker) {
				marker.addListener("click", function(getStoreList) {   
					//중심 위치를 클릭된 마커의 위치로 변경
					map.setCenter(this.getPosition());
					//마커 클릭 시의 줌 변화
					map.setZoom(17);
					/*	window.open('http://https://www.google.com/');*/
					console.log("지도마커클릭")
				
					var orderNo = storeVo.orderno;
					console.log(orderNo);
					
					
					$.ajax({
						
						url : "${pageContext.request.contextPath }/getStore",		
						type : "post",
						/* contentType : "application/json", */
						data : {orderNo: orderNo},
				 
						dataType : "json",
						success : function(storeVo){
							/*성공시 처리해야될 코드 작성*/
							
							console.log(storeVo);
							//로고
							if(storeVo.logoImg == null){
								$("#storeLogo").attr("src", "${pageContext.request.contextPath}/assets/images/store_default.JPG");
							} else {
								$("#storeLogo").attr("src", "${pageContext.request.contextPath}/upload/"+storeVo.logoImg);	
							}
							$("#name").text(storeVo.storeName);
							$("#delivery-num").text(storeVo.countPeople + "명/" + storeVo.people+"명");
							$("#pFee").text(storeVo.pFee.toLocaleString() + "원")
							$("#delivery-address").text(storeVo.deliveryMAdr);
							$("#delivery-hp").text(storeVo.storePhone);
							
							if(storeVo.countPeople>=storeVo.people){
								$("#reserve-btn").removeAttr("href");
								$("#reserve-btn").attr("id", "reserv-full")	;			
								$("#reserve-btn").text("예약꽉참")	;			

								}else{
									
								$("#reserve-btn").attr("href", "${pageContext.request.contextPath}/store/"+ storeVo.storeNo +"/reserv");
							
							}	
							
						},
						error : function(XHR, status, error) {
							console.error(status + " : " + error);
						}
					});
					/* ajax */
					
				}); 
				/* marker.addListener */
				
			}/* if */
			
		}/*for */

		
	}	
}



//마커용 가게 리스트 가져오기
function getStoreList(){
	
	var locations = [] ;
	
	$.ajax({
		
		url : "${pageContext.request.contextPath }/getStoreList",		
		type : "post",
		/* data : {storeList: storeList},  */
		/* contentType : "application/json", */
		async: false,
		dataType : "json",
		success : function(storeList){
			/*성공시 처리해야될 코드 작성*/
			console.log(storeList);
			
			for(var i=0; i<storeList.length; i++){
				
				var markerVo = {
					place: storeList[i].storeName,
					lat: storeList[i].deliveryLat,
					lng: storeList[i].deliveryLng,
					orderno: storeList[i].orderNo,
					logoImg: storeList[i].logoImg,
					countPeople: storeList[i].countPeople,
					people: storeList[i].people,
					deliveryMAdr:storeList[i].deliveryMAdr,
					deliverySAdr:storeList[i].deliverySAdr,
					storePhone: storeList[i].storePhone,
					storeNo: storeList[i].storeNo,
					storeName: storeList[i].storeName,
					pFee: storeList[i].pFee
				};
				
				locations.push(markerVo);
				
			}
			console.log("-----------------------------------")
			
			console.log(storeList)
			
		}
	});	
	
	
	return locations

}
</script>
<!-- 맨 아래에 둘것 -->
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDl9EqQnWPqoxn5ZOEOAde3auL9VBp4NYU&callback=initMap&region=kr"></script>
</html>