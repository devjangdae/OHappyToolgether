<%@page import="kr.or.kosa.post.Post"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<title>OHappyToolgether</title>
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
	<link href="/css/styles.css" rel="stylesheet" />
	<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"	crossorigin="anonymous"></script>
	<style>
        .note-editor .note-editing-area { height: 500px; }
    </style>
</head>
<body class="sb-nav-fixed">
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<div id="layoutSidenav">
	
	<%@ include file="/WEB-INF/views/common/sidenav.jsp"%>
	<div id="layoutSidenav_content">
<main class="container mt-4">
    <!-- <h1 class="mt-4" id='qwerqwer'>게시판 수정</h1> -->
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="/kanvan.do">칸반보드</a></li>
        <li class="breadcrumb-item"><a href="/board.do">게시판</a></li>
        <li class="breadcrumb-item"><a href="/project.do">프로젝트</a></li>
        <li class="breadcrumb-item"><a href="/loginForm.do">로그아웃</a></li>
    </ol>
    <form method="post" id="postForm" name="postForm" action="">
    	<input type="hidden" name="projectId" value="${post.projectId}">
    	<input type="hidden" name="boardId" value="${post.boardId}">
        <div class="form-group">
            <label for="Input">제목</label>
            <input type="input" class="form-control" id="title" name="title" value="${post.title}">
        </div>
        
        <div class="form-group">
            <input class="form-control" type="file" id="fileInput" name="fileInput" multiple onchange="addFile()">
            <div class="selected-files">
		        <ul id="selectedFiles"></ul>
		    </div>
          </div>
        
        <textarea id="summernote" name="content"></textarea>

        <div class="text-right">
            <!-- <input type="submit" value="글쓰기" class="btn btn-info"> -->
            <input type="button" onclick="updatePost()" value="수정하기" class="btn btn-info">
            <input type="button" onclick="window.location.href='<%=request.getContextPath()%>/postDetail/${post.boardId}/${post.postId}'" value="취소" class="btn btn-info">
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    
    <!-- include summernote css/js -->
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
	<script type="text/javascript">
	
	//삭제 파일 인덱스
	let fileRemoveIndex = [];
	
	$(document).ready(function() {
		//content값 가져오기
		let content = '${post.content}';
		$('#summernote').summernote('code', content);
	});

	//게시글 쓰기 
	function updatePost() {
		let data = {
			postId : '${post.postId}',
			boardId: '${post.boardId}',
			projectId: '${post.projectId}',
			title: $("#title").val(),
			content:$("#summernote").val()
		}
		
		//게시글 저장
		fetch("/post/update", {
			method: "POST",
			headers: {
			  "Content-Type": "application/json",
			},
			body: JSON.stringify(data),
			})
		   .then((response) => {
			    if (response.ok){ 
			    	return response.json();
			    }else{ 
			    	 throw new Error("게시글 수정에 실패했습니다."); 
			    }
		   })
		   .then((postId) => {
			   if (fileInput.files.length > 0) {
				   fileupload(postId);
				} 
		   })
		   .then((response) => {
			  	alert("게시글 수정완료");
				window.location.href="<%=request.getContextPath()%>/postDetail/${post.boardId}/${post.postId}";
			})
		   .catch((error) => {
		     console.error(error);
		   }); 
	}
	
	// 파일 리스트 표시
	$("#fileInput").on("change",function() {
		let fileNames = "";
		for (let i = 0; i < this.files.length; i++) {
			fileNames += "<li style='list-style-type: none;'><span style='color: gray;'>" + this.files[i].name + "</span>&nbsp;&nbsp;&nbsp;<i class='fa-solid fa-xmark' style='color: #b53930;' onclick='deleteFile(" + i + ")'></i></li>";
		}
		$("#selectedFiles").append(fileNames);
	});
	
 	//파일 추가
	function addFile() {
		$("#selectedFiles").empty();//화면 비우기
	}

	//파일 삭제
	function deleteFile(i){
		//화면에서 지우기
		$("#selectedFiles").children().eq(i).remove();
		//삭제 파일리스트 index 저장해두기
		fileRemoveIndex.push(i);
	}
	 
	//파일저장
	function fileupload(postId){
		var data = new FormData();
		let files = postForm.fileInput.files;
		
		for (var i = 0; i < files.length; i++) {
			if (!fileRemoveIndex.includes(i)) { 
				data.append('uploadFiles', files[i]);
			}
		}
		data.append('postId', postId);
		data.append('boardId', '${boardId}');

		fetch('<%=request.getContextPath()%>/post/upload', {
			  method: 'POST',
			  body: data
		})
		.then(function(response) {
		  if (response == 0) { //파일업로드 실패시
			  throw new Error('File upload failed');
		  } 
		})
		.catch(function(error) {
			console.error('ERROR:', error);
			alert('파일 업로드 실패');
		});
	}
	
</script>

</main>
			<%@ include file="/WEB-INF/views/common/footer.jsp"%>
		</div>
	</div>
	<script src="/js/scripts.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>


