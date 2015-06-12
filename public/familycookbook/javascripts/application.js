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
    });
    $('.remove-tag').bind('click', function(){
      alert('Posting to '+$(this).data('url'));
      $.post($(this).data('url'), $(this).data);
    });

    //WysiwygEditor.prototype.initialize('ingredient', 'mtmd_family_cook_book_ingredient_description', 'ingredient-description');
  }
);

function WysiwygEditor() {

}

WysiwygEditor.prototype = {
  targetDomId: '',
  formDomId:   '',
  editorDomId: '',

  editorOptions: {
    height: 300,                 // set editor height

    minHeight: null,             // set minimum height of editor
    maxHeight: null,             // set maximum height of editor

    focus: true,                 // set focus to editable area after initializing summernote

    toolbar: [
      //[groupname, [button list]]

      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['font', ['strikethrough', 'superscript', 'subscript']],
      ['fontsize', ['fontsize']],
      ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['height', ['height']],
    ]
  },

  setForm: function(formDomId) {
    this.formDomId = formDomId;
  },

  getForm: function() {
    return $('#'+this.formDomId)
  },

  setTarget: function(targetDomId) {
    this.targetDomId = targetDomId;
  },

  getTarget: function() {
    return $('#'+this.targetDomId)
  },

  setEditor: function(editorDomId) {
    this.editorDomId = editorDomId;
  },

  getEditor: function() {
    return $('#'+this.editorDomId)
  },

  initialize: function(formDomId, targetDomId, editorDomId) {
    this.setForm(formDomId);
    this.setTarget(targetDomId);
    this.setEditor(editorDomId);

    this.setUpEditor();
    this.setInitialValue();
    this.setUpFormBinding();
    self = this;
  },

  setUpEditor: function() {
    this.getEditor().summernote(this.editorOptions);
  },

  setInitialValue: function() {
    this.getEditor().code(this.getTarget().text());
  },

  setUpFormBinding: function() {
    this.getForm().bind('submit', function( event ){
      self.getTarget().val(self.getEditor().code());
    });
  }
}