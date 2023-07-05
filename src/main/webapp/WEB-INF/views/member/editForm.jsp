<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="name" var="userid" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

<title>OHappyToolgether</title>

<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<link href="css/styles.css" rel="stylesheet" />

<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<!-- swal2  -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="sb-nav-fixed">

    <%@ include file="/WEB-INF/views/common/header.jsp"%>
    <div id="layoutSidenav">
        <%@ include file="/WEB-INF/views/common/sidenav.jsp"%>
        <div id="layoutSidenav_content">
            <main>
                <div class="container px-4 mt-4" style="width: 200%">
                    <div class="col-md-4 offset-md-4">
                        <div class="card">
                            <div class="card-header">
                                <div class="text-center">
                                    <h2>정보수정</h2>                                    
                                </div>
                            </div>
                            <div class="card-body">
                                <form id="editForm">
                                    <div class="form-group">
                                        <label for="userid" class="form-label mt-4">아이디</label>
                                        <input type="text" class="form-control" id="userid" name="userid" value="${user.userid}" disabled>
                                    </div>
                                    <div class="form-group">
                                        <label for="password" class="form-label mt-4">비밀번호</label>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="name" class="form-label mt-4">이름</label>
                                        <input type="text" class="form-control" id="name" name="name" value="${user.name}"placeholder="Enter your name">
                                    </div>
                                    <div class="form-group">
                                        <label for="email" class="form-label mt-4">이메일</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" placeholder="Enter your email">
                                    </div>
                                    
                                    <!--프로필사진파일 업로드 -->
                                    <div class="form-group">
                                        <label for="image" class="form-label mt-4">프로필 사진</label>
                                        <input type="file" class="form-control" id="image" name="image" value="${user.image}">
                                    </div>
                                    
                                    <div class="form-group mt-4 text-center">
                                        <button type="submit" class="btn btn-primary">수정하기</button>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer small text-muted text-center">OHappyToolgether</div>
                        </div>
                    </div>
                </div>
            </main>
            <%@ include file="/WEB-INF/views/common/footer.jsp"%>
        </div>
    </div>
    <script src="js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script>
	  $(document).ready(function() {
		//set file
		const fileInput = document.getElementById('image');
		
		// 파일 입력 필드의 값 설정
		//const file = new File(['파일 내용'], '파일명.txt', { type: 'text/plain' });
		//fileInput.files = [file];
		  
	    $("#editForm").submit(function(event) {
	      event.preventDefault(); // 폼 기본 동작 방지
	      
	      var formData = {
	        "userid": $("#userid").val(),
	        "password": $("#password").val(),
	        "name": $("#name").val(),
	        "email": $("#email").val(),
	        "image": $("#userid").val() + editForm.image.files[0].name
	      };
	      
	
	      $.ajax({
	        url: "${pageContext.request.contextPath}/member",
	        type: "PUT",
	        contentType: "application/json",
	        data: JSON.stringify(formData),
	        success: function(response) {
	          uploadImg();
	          Swal.fire({
	                icon: 'success',
	                title: '수정 완료',
	                showConfirmButton: false,
	                timer: 1500
	            });
	          setTimeout(function() {
	            	window.location.href = "/projectList.do";
				}, 1500); 
	        },
	        error: function(xhr, status, error) {
	        	Swal.fire({
	                icon: 'error',
	                title: '수정 실패',
	                text: '오류 : ' + xhr.responseText,
	                showConfirmButton: false,
	                timer: 1500
	            })
	            setTimeout(function() {
	            	window.location.href = "/projectList.do";
				}, 1500); 
	        }
	      });
	    });
	  });
	  
	  function uploadImg() {
		  var data = new FormData();
		  let file = editForm.image.files[0];
		  data.append('uploadFile', file);

		  $.ajax({
		    url: "${pageContext.request.contextPath}/file/users/upload",
		    type: "POST",
		    contentType: false,
		    processData: false,
		    data: data,
		    success: function(response) {
		      // 업로드 성공 시 실행할 동작을 여기에 추가하세요.
		    },
		    error: function(xhr, status, error) {
		    	Swal.fire({
	                icon: 'error',
	                title: '수정 실패',
	                text: '오류 : ' + xhr.responseText,
	                showConfirmButton: false,
	                timer: 1500
	            })
		      return
		    }
		  });
		}
	 
	</script>  
