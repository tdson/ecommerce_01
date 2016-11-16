$(document).ready(function() {
  var pname = ((document.title != '') ? document.title : document.querySelector('h1').innerHTML);
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.src = '//live.vnpgroup.net/js/web_client_box.php?hash=9d6d7ecff9978858bef94f1358c13d32&data=eyJzc29faWQiOjM5MDAyNiwiaGFzaCI6ImRmYzMyMTQ2YTFmZTNiNTZmZjA3NzFkM2IyZjA0ZmNkIn0-&pname=' + pname;
  var s = document.getElementsByTagName('script');
  s[0].parentNode.insertBefore(ga, s[0]);
});
