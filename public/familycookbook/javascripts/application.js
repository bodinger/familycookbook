// Put your application scripts here
var isMobile = {
  Android: function() {
    return navigator.userAgent.match(/Android/i);
  },
  BlackBerry: function() {
    return navigator.userAgent.match(/BlackBerry/i);
  },
  iOS: function() {
    return navigator.userAgent.match(/iPhone|iPad|iPod/i);
  },
  Opera: function() {
    return navigator.userAgent.match(/Opera Mini/i);
  },
  Windows: function() {
    return navigator.userAgent.match(/IEMobile/i);
  },
  any: function() {
    return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
  }
};
if(isMobile.any()) {
  $(document).ready(
      function () {
        $("a[data-toggle]").each(function () {
          console.log($(this).data("target"));

          $(this).bind("click", function () {
            $($(this).data("target") + " table pre.pre-max-width").css("width", "45em");
            $($(this).data("target")).toggle();
          });
        });
      }
  );
}