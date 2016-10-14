// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function main () {
  "use strict";

  $(document).on('change', '.js-kind-selector', function (event) {
    var $select = $(event.currentTarget);
    var feat = $select.val();

    if( feat == 'injury' ){
      $('.js-injury-selector').prop('disabled', false);
    }else{
      $('.js-injury-selector').value = "";
      $('.js-injury-selector').prop('disabled', true);
    };

  });

})();
