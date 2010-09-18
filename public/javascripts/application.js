$(document).ready(function(){
  $(".top-draftees").css("display","none");
  $(".draftees").hover(function(){
    $(this).find('.top-draftees').toggle();
  });

  $("#minimum-shots input[type=radio]").click(function(){
    window.location = '/' + $('#view').val() + "/sample/" + $(this).val() + "/page/1";
  });
});
