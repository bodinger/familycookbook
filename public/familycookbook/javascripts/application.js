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

$(document).ready(
  function () {
    $('#tag_name').typeahead({
      name:   'tag_name',
      source: function (query, process) {
        return $.get('/familycookbook/tag/as_array', { q: query }, function (data) {
          return process(data);
        });
      }
      //updater: function(item) {
      //  $(this).value = item;
      //  console.log(this);
      //  console.log('Fired with: '+$(this).attr);
      //  //$('#recipe-add-tag-submit').click();
      //  return item;
      //}
    });
    $('.remove-tag').bind('click', function(){
      alert('Posting to '+$(this).data('url'));
      $.post($(this).data('url'), $(this).data);
    });
  }
);