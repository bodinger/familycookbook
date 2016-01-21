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
    $('button.recipe-link').bind('click', function(){
      if ($(this).data('action') != 'show') {
        return;
      }
      $(location).attr('href', "/familycookbook/recipe/show/"+$(this).data('recipe-id'));
    });


    $('.menu-planner-anchorsubmit').bind('click', function(){
      if ($(this).data('domid') == '') {
        return;
      }
      $('#mtmd_family_cook_book_menu_anchor').val($(this).data('domid'));
    });

    if (typeof $('#mtmd_family_cook_book_shopping_list_focus') != 'undefined') {
      $('#mtmd_family_cook_book_shopping_list_focus').focus();
    }
  }
);

function AutoCompleter() {}
AutoCompleter.prototype = {
  inputSelector:      '',
  postButtonSelector: '',
  dataSourceUrl:      '',

  setInputSelector: function(inputSelector) {
    this.inputSelector = inputSelector;
  },

  getInput: function() {
    return $(this.inputSelector);
  },

  setPostButtonSelector: function(postButtonSelector) {
    this.postButtonSelector = postButtonSelector;
  },

  getPostButton: function() {
    return $(this.postButtonSelector);
  },

  setDataSourceUrl: function(dataSourceUrl) {
    this.dataSourceUrl = dataSourceUrl;
  },

  getDataSourceUrl: function() {
    return this.dataSourceUrl;
  },

  initialize: function(inputSelector, postButtonSelector, dataSourceUrl) {
    this.setInputSelector(inputSelector);
    this.setPostButtonSelector(postButtonSelector);
    this.setDataSourceUrl(dataSourceUrl);

    currentInstance = this;
    this.getInput().typeahead({
      name:   this.inputSelector,
      source: function (query, process) {
        return $.get(currentInstance.getDataSourceUrl(), { q: query }, function (data) {
          return process(data);
        })
      }
    });
    this.getPostButton().bind('click', function(){
      $.post($(this).data('url'), $(this).data);
    });
  }
}

function DatePicker() {}
DatePicker.prototype = {
  pickerDomId: '',
  defaultDate: '',
  pickerOptions: {
    locale: 'de',
    //daysOfWeekDisabled: [0,1,2,3,4],
    calendarWeeks: true,
    allowInputToggle: true,
    format: 'DD.MM.YYYY'
  },

  setDefaultDate: function(defaultDate) {
    this.defaultDate = defaultDate;
  },

  getDefaultDate: function() {
    return this.defaultDate;
  },

  setPicker: function(pickerDomId) {
    this.pickerDomId = pickerDomId;
  },

  getPicker: function() {
    return $('#' + this.pickerDomId);
  },

  initialize: function(pickerDomId, defaultDate) {
    this.setPicker(pickerDomId);
    this.setDefaultDate(defaultDate);
    this.getPicker().datetimepicker(this.pickerOptions);
    this.getPicker().data("DateTimePicker").defaultDate(this.getDefaultDate());
    this.getPicker().data("DateTimePicker").minDate(this.getDefaultDate());
    self = this;
  },

  linkPickers: function(pickerLeftDomId, pickerRightDomId) {
    $('#' + pickerLeftDomId).on("dp.change", function (e) {
      $('#' + pickerRightDomId).data("DateTimePicker").minDate(e.date);
    });
    $('#' + pickerLeftDomId).data("DateTimePicker").maxDate($('#' + pickerRightDomId).data("DateTimePicker").defaultDate());
    $('#' + pickerRightDomId).on("dp.change", function (e) {
      $('#' + pickerLeftDomId).data("DateTimePicker").maxDate(e.date);
    });
    $('#' + pickerRightDomId).data("DateTimePicker").minDate($('#' + pickerLeftDomId).data("DateTimePicker").defaultDate());
  }
}


function WysiwygEditor() {}
WysiwygEditor.prototype = {
  targetDomId: '',
  formDomId:   '',
  editorDomId: '',

  editorOptions: {
    height: 300,                 // set editor height

    minHeight: null,             // set minimum height of editor
    maxHeight: null,             // set maximum height of editor

    focus: false,                 // set focus to editable area after initializing summernote

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
    $.summernote.pluginEvents['tab'] = function(event, editor, layoutInfo){
      console.log('Find a solution to prevent tab input and instead go to next tabindex element');
      $.tabNext();
    };
    $.summernote.pluginEvents['untab'] = function(event, editor, layoutInfo){
      console.log('Find a solution to prevent tab input and instead go to previous tabindex element');
      $.tabPrev();
    };
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

function FancySelector() {}
FancySelector.prototype = {
  targetSelector: '',
  dataUrl: '',
  placeholderText: '',

  options: {
    theme: 'classic',
    tags: true,
    placeholder: '',
    language: 'de',
    ajax: {
      url: '',
        dataType: 'json',
        delay: 250,
        data: function (params) {
        return {
          q: params.term, // search term
          page: params.page
        };
      },
      processResults: function (data, page) {
        return {
          results: data
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; }
  },

  initialize: function(targetSelector, url, placeholder) {
    this.setSelect(targetSelector);
    this.setDataUrl(url);
    this.setPlaceholderText(placeholder);

    this.options.placeholder = this.placeholderText;
    this.options.ajax.url = this.dataUrl;

    return this.setUpSelect();
  },

  setUpSelect: function() {
    return this.getSelect().select2(this.options);
  },

  setDataUrl: function(url) {
    this.dataUrl = url;
  },

  setPlaceholderText: function(placeholderText) {
    this.placeholderText = placeholderText;
  },

  setSelect: function(targetSelector) {
    this.targetSelector = targetSelector;
  },

  getSelect: function() {
    return $(this.targetSelector);
  }
}
