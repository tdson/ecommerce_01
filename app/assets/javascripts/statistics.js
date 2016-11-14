$(document).ready(function (){
  var line = new Morris.Line({
    element: 'line-chart',
    resize: true,
    data: orders_data,
    xkey: 'date',
    ykeys: ['quantity'],
    labels: [line_chart_x_label],
    xLabelAngle: 35,
    lineColors: ['#3c8dbc'],
    hideHover: 'auto',
    parseTime: false
  });

  Morris.Bar({
    element: 'graph_bar',
    data: top_products_data,
    xkey: 'product',
    ykeys: ['quantity'],
    labels: [bar_chart_x_label],
    barRatio: 0.4,
    barColors: ['#26B99A', '#34495E', '#ACADAC', '#3498DB'],
    xLabelAngle: 35,
    hideHover: 'auto',
    padding: 80,
    resize: true
  });
});
