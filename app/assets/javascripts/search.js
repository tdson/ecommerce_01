$(document).on('keyup', 'input#q', function() {
  $.get($('#admin_search').attr('action'),
    $('#admin_search').serialize(), null, 'script');
  return false;
});
