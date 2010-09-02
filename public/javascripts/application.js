$(document).ready(function(){
  $(".top-draftees").css("display","none");
  $(".draftees").hover(function(){
    $(".top-draftees").toggle();
  });
});
