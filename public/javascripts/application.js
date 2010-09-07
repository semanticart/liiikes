$(document).ready(function(){
  $(".top-draftees").css("display","none");
  $(".draftees").hover(function(){
    $(this).find('.top-draftees').toggle();
  });
});
