$(document).ready(function() {
  $('span.otwtranslation_mark_untranslated, span.otwtranslation_mark_translated, span.otwtranslation_mark_approved').rightClick(function(event) {
      var phrase_key = $(this).attr('id').replace("phrase_", "");
      var ypos = $(this).offset().top + $(this).height() 
	  - $('#main').offset().top + 10
      var xpos = $(window).width() / 4


      $.ajax({url: '/translation/phrases/' + phrase_key,
	      type: 'get',
	      dataType: 'script',
	      async: 'false',
	      data: { '_method': 'show' },
	      success: function(html) {
		  $('#main').append(html)
		  $('div.otwtranslation_show_inline').css({top: ypos, left: xpos});
		  
		  $('span.otwtranslation_hide_inline').click(function() {
		      $('div.otwtranslation_show_inline').remove();
		  }); 

	      }
	     });
  });
})


    
