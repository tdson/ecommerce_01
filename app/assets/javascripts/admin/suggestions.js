$(document).ready(function() {
  $(".is_read").bootstrapSwitch({
    size: 'mini',
    onText: 'Read',
    offText: 'Unread'
  });

  $('.table-suggestion').on('click', '.bootstrap-switch', function() {
    var suggestion_id = $(this).prev().val();

    $.ajax({
      type: 'POST',
      url: '/admin/suggestions/' + suggestion_id,
      data: {
        _method: 'patch'
      },
      dataType: 'json',
      success: function(data) {},
      error: function(data) {
        alert(data.responseText);
      }
    });
  });
});
