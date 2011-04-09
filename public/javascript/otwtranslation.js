/*
Show the inline translator popup
*/
function otwtranslation_inline_translator(doc)
{
    var phrase_key = $(doc).attr('id').replace("otwtranslation_phrase_", "");
    var ypos = $(doc).offset().top + $(doc).height() 
	- $('#main').offset().top + 10
    var xpos = $(window).width() / 4
    
    
    $.ajax({url: '/translation/phrases/' + phrase_key,
	    type: 'get',
	    dataType: 'script',
	    async: 'false',
	    data: { '_method': 'show' },
	    success: function(html) {
		$('#main').append(html)
		$('div.show.inline').css({top: ypos, left: xpos});
		
		$('p.hide.inline').click(function() {
		    $('div.show.inline').remove();
		}); 
		
	    }
	   });   
}


$(document).ready(function() {
  $('span.otwtranslation_mark_untranslated, span.otwtranslation_mark_translated, span.otwtranslation_mark_approved').rightClick(function(event) {
      otwtranslation_inline_translator(this)
  });
})


    
