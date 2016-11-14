$(document).on('click', '.glyphicon-remove', function() {
  $(this).closest('tr').fadeOut(500);
  setTimeout(function() {
    $('.alert').fadeOut(500);
  }, 3000);
});
