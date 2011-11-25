/*
Show the inline translator popup
*/
function otwtranslation_inline_translator(doc)
{
    var phrase_key = $(doc).attr('id').replace("otwtranslation_phrase_", "");
    var ypos = $(doc).offset().top + $(doc).height() 
	- $('#main').offset().top + 10;
    var xpos = $(window).width() / 4;
    
    $.ajax({url: '/translation/phrases/' + phrase_key + '.js', 
	    type: 'get',
	    dataType: 'html',
	    async: 'false',
	    success: function(response) {
		$('#main').append(response);
		$('div.show.inline').css({top: ypos, left: xpos});
		
		$('p.hide.inline').click(function() {
		    $('div.show.inline').remove();
		}); 
		
	    },
	    error: function(XMLHttpRequest, textStatus, errorThrown){
                alert(textStatus + ": " + errorThrown);
            } 
	   });
}


$(document).ready(function() {
  $('span.untranslated, span.translated, span.approved').rightClick(function(event) {
      otwtranslation_inline_translator(this);
  });
})


    
