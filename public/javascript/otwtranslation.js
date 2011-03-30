$(document).ready(function() {
  $('span.otwtranslation_mark_untranslated, span.otwtranslation_mark_translated, span.otwtranslation_mark_approved').rightClick(function() {
      var phrase_key = $(this).attr('id').replace("phrase_", "");
      alert('TODO ... ' + phrase_key);
  });
})
