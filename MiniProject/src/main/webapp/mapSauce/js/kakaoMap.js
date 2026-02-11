// 마커를 담을 배열입니다
var markers = [];
var map;
var ps;
var infowindow;

window.onload = function() { // 온로드 할때만 켜져라

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
    };  

	// 지도를 생성합니다    
	map = new kakao.maps.Map(mapContainer, mapOption); 

	//장소 검색 객체를 생성합니다
	ps = new kakao.maps.services.Places(); 

	//키워드로 장소를 검색합니다
	searchPlaces();
	
	// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
	infowindow = new kakao.maps.InfoWindow({zIndex:1});

};	// windows.onload 

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {
	
	// 변수를 선언(var 또는 const)하고 HTML 요소를 가져옵니다.
	var keywordElement = document.getElementById('keyword');
	
	// 요소가 없으면 함수 종료 (에러 방지)
    if (!keywordElement) {
        console.error("에러: 'keyword' id를 가진 입력창을 찾을 수 없습니다.");
        return;
    }
	
    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNodes(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
	for (var i = 0; i < places.length; i++) {

	    var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
	        marker = addMarker(placePosition, i),
	        itemEl = getListItem(i, places[i]);

	    bounds.extend(placePosition);

	    // ★ place를 클로저로 확실히 고정
		(function(marker, place) {

		    // 마우스 오버
		    kakao.maps.event.addListener(marker, 'mouseover', function() {
		        displayInfowindow(marker, place.place_name);
		    });
		    kakao.maps.event.addListener(marker, 'mouseout', function() {
		        infowindow.close();
		    });

			// 마커 클릭 → DB 검색 및 화면 갱신
			kakao.maps.event.addListener(marker, 'click', function() {
			    fetch("/restaurant/search.do", {
			        method: "POST",
			        headers: { "Content-Type": "application/json" },
			        body: JSON.stringify({
			            name: place.place_name,
			            address: place.address_name
			        })
			    })
			    .then(res => res.text().then(text => text ? JSON.parse(text) : null))
			    .then(data => {
			        const restListDiv = document.getElementById("rest_list");
			        const reviewListDiv = document.getElementById("review_list");
					const restWrap = document.getElementById("rest_list_wrap");

			        // 1. DB에 식당이 있는 경우 (유사 데이터 포함)
			        if (data && data.length > 0) {
			            
			            // [3번 영역]: 기존 로직 유지 (식당 이름과 주소로 유사 식당 검색)
			            const restUrl = `/restaurant/rest_list.do?name=${encodeURIComponent(place.place_name)}&address=${encodeURIComponent(place.address_name)}`;
			            fetch(restUrl)
			                .then(res => res.text())
			                .then(html => {
			                    if(restListDiv) {
			                        restListDiv.innerHTML = html;
			                        restWrap.scrollTop = 0;
			                    }
			                });

			            // [4번 영역]: 수정 로직 (r_idx와 r_idx 비교)
			            // search.do 결과 데이터 중 첫 번째 항목의 r_idx를 사용합니다.
			            const db_r_idx = data[0].r_idx; 

						// 리뷰 컨트롤러에 식당 고유 번호(r_idx)를 전달
			            const reviewUrl = `/review/list.do?r_idx=${db_r_idx}`;
						fetch(reviewUrl)
				            .then(res => res.text())
				            .then(html => {
				                if (reviewListDiv) {
				                    // 서버에서 가져온 HTML이 비어있거나 특정 문구가 포함된 경우 처리
				                    if (!html.trim() || html.includes("데이터가 없습니다") || html.includes("리뷰가 없습니다")) {
				                        reviewListDiv.innerHTML = `
				                            <div style="text-align:center; padding:40px 20px; border:1px solid #eee; background:#fafafa; border-radius:8px;">
				                                <h4 style="color:#666;">아직 작성된 리뷰가 없습니다.</h4>
				                                <p style="margin:15px 0; color:#888;">이 식당의 고유번호(${db_r_idx})와 연결된 첫 리뷰를 남겨주세요!</p>
				                                <button onclick="location.href='/review/insert_form.do?r_idx=${db_r_idx}'" 
				                                        class="btn btn-info" style="font-weight:bold;">
				                                    ✍️ 리뷰 작성하러 가기
				                                </button>
				                            </div>
				                        `;
				                    } else {
				                        reviewListDiv.innerHTML = html;
				                    }
				                } 
				            });
			        }	// if : db에 데이터 있는경우 
			        // 2. DB에 검색 데이터가 아예 없는 경우
			        else {
			            // ... (기존과 동일하게 유지)
			            let noDataHtml = `
			                <div style="text-align:center; padding:30px; border:1px solid #ddd; background:#fff;">
			                    <h4 style="color:#d9534f; font-weight:bold;">등록되지 않은 식당입니다.</h4>
			                    <p style="margin:15px 0;">카카오 맵 정보: <strong>${place.place_name}</strong></p>
			                    <button onclick="location.href='/restaurant/test_insert_form.do?r_name=${encodeURIComponent(place.place_name)}'" 
			                            class="btn btn-primary">📝 직접 식당 정보 등록하기
			                    </button>
			                </div>
			            `;
			            if(restListDiv) restListDiv.innerHTML = noDataHtml;
			            if(reviewListDiv) reviewListDiv.innerHTML = "<h4>리뷰가 없습니다. 식당 등록을 먼저 진행해주세요.</h4>";
			        }
			    })
			    .catch(err => {
			        console.error("오류 발생:", err);
			    });
			});

		})(marker, places[i]);   // ← place 전달. function(marker...) ends

	    fragment.appendChild(itemEl);
	}	
	
    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
// 인포윈도우란 마커 위에 표시될 작은 사각형 텍스트박스를 의미함
function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNodes(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }	
	
}

// 카카오에서 클릭한 식당을 DB에 바로 등록
function insertRestaurantFromKakao(name, address) {
    if (!confirm(`"${name}" 식당을 DB에 등록하시겠습니까?`)) return;

    fetch("/restaurant/insert_from_kakao.do", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: name, address: address })
    })
    .then(res => {
        if (!res.ok) {
            return res.text().then(text => { throw new Error("서버 오류: " + text); });
        }
        return res.json();
    })
    .then(result => {
        if (result.success) {
            alert("✅ 식당이 성공적으로 등록되었습니다!");
            location.reload();   // 등록 후 바로 정보 표시
        } else {
            alert("등록 실패: " + result.message);
        }
    })
    .catch(err => {
        console.error("등록 실패:", err);
        alert("등록 중 오류가 발생했습니다.\n콘솔을 확인해주세요.");
    });
}

// [추가] 현재 지도 범위 내에서 '맛집' 키워드로 검색하는 함수
function searchAroundMe() {
    // 1. 현재 지도의 가시 영역(Bounds)을 가져옵니다.
    var bounds = map.getBounds(); 

    // 2. 검색 옵션 설정 (현재 영역으로 제한)
    var searchOptions = {
        bounds: bounds,               // 현재 화면 안에서만 검색
        location: map.getCenter(),    // 지도 중심점 기준 우선순위
        useMapBounds: true            // 영역 내 검색 활성화
    };

    // 3. '맛집'이라는 키워드로 고정 검색을 수행합니다.
    // 만약 입력창의 키워드를 쓰고 싶다면 document.getElementById('keyword').value 를 쓰면 됩니다.
    ps.keywordSearch("맛집", placesSearchCB, searchOptions); 
    
    // 선택 사항: 검색창의 텍스트도 '맛집'으로 변경해주면 사용자에게 직관적입니다.
    document.getElementById('keyword').value = "맛집";
}
