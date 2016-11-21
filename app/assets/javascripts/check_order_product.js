$(document).ready(function() {
  $('.link-update').on('click', function() {
    var qty_input_field = $(this).prev();
    var icon_tag = $(this).next();
    var id = qty_input_field.prev().val();
    var qty = qty_input_field.val();
    icon_tag.removeClass();

    $.ajax({
      type:'POST',
      url: '/admin/order_products/' + id,
      data: {
        _method: 'patch',
        id: id,
        quantity: qty
      },
      dataType: 'json',
      success: function(data){
        icon_tag.addClass('fa fa-check-circle text-success');
        $("#total_cost").html(data[0]);
      },
      error: function(data){
        icon_tag.addClass('fa fa-times-circle text-danger');
        qty_input_field.val(data.responseJSON[1]);
        alert(data.responseJSON[0]);
      }
    });
  });
});
