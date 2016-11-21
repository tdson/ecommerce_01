$(document).ready(function() {
  $('.date-range').on('change', '#range', function() {
    var range = $(this).val();

    $.ajax({
      type: 'GET',
      url: '/admin/statistics?range=' + range,
      data: {},
      dataType: 'script',
      success: function(data) {},
      error: function(data) {
        alert(data.responseText);
      }
    });
  });
});
