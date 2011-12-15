/*
Show the inline translator popup
*/
function otwtranslation_inline_translator(doc)
{
    var phrase_key = $j(doc).attr('id').replace("otwtranslation_phrase_", "");
    var ypos = $j(doc).offset().top + $j(doc).height() 
	- $j('#main').offset().top + 10;
    var xpos = $j(window).width() / 4;
    
    $j.ajax({url: '/translation/phrases/' + phrase_key + '.js', 
	    type: 'get',
	    dataType: 'html',
	    async: 'false',
	    success: function(response) {
		$j('#main').append(response);
		$j('div.show.inline').css({top: ypos, left: xpos});
		
		$j('div#inline-close').click(function() {
		    $j('div.show.inline').remove();
		}); 
		
	    },
	    error: function(XMLHttpRequest, textStatus, errorThrown){
                alert(textStatus + ": " + errorThrown);
            } 
	   });
}


$j(document).ready(function() {
  $j('span.untranslated, span.translated, span.approved').rightClick(function(event) {
      otwtranslation_inline_translator(this);
  });
})


    
