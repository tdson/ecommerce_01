$(document).ready(function() {
  $('.status').on('click', '.rating-stars', function() {
    console.log('click');
    rating_val = $(this).val();
    product_id = $(this).parent().parent().next("input#product_id").val();

    $.ajax({
      type: 'POST',
      url: '/products/' + product_id + '/ratings',
      data: {
        rating: rating_val
      },
      dataType: 'script',
      success: function(data) {},
      error: function(data) {
        alert(data.responseText);
      }
    });
  });
});
