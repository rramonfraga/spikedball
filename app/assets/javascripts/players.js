// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function main () {
  "use strict";

function disabled_maximun_hire_players() {
  var options = $('.js-hire-player-selector')[0].options

  var values = $.map(options ,function(option) {

    if(option.value != ""){
      var request = $.get('/api/templates/players/' + option.value);

      request.fail(function () {
        alert("Couldn’t find this player. Try later.")
      });

      request.done(function (player) {
        var count = 0;
        $('.js-player-selector').each( function () {
          if( this.value == option.value) { count++; }
        });

        var klass = option.value;

        if(count == player.quantity){
          $('.js-player-selector').each( function () {
            var self = this
            if( self.value != option.value){
              self.getElementsByClassName(klass)[0].setAttribute('disabled', true);
            }else{
              self.getElementsByClassName(klass)[0].removeAttribute('disabled', false);
            }
          });
        }else{
          $('.js-player-selector').each( function () {
            this.getElementsByClassName(klass)[0].removeAttribute('disabled', false);
          });
        };
      });
    };
  });
}

$(document).on('change', '.js-hire-player-selector', function (event) {
  var $select = $(event.currentTarget);
  var playerId = $select.val();
  if(playerId == "") {
    $select.closest('.js-player').find('.js-player-attributes').find('.field').empty();
    $select.closest('.js-player').find('.js-cost').attr('data-cost', 0);
    calculate_treasury();
  };
  var request = $.get('/api/templates/players/' + playerId);

  request.fail(function () {
    alert("Couldn’t find this player. Try later.")
  });

  request.done(function (player) {
    var htmlSkill = "";
    player.skills.forEach( function (skill) {
      htmlSkill = htmlSkill + '<a href="#" class="js-skill" data-skill-id="' + skill.id + '">' +skill.name + "</a>, "
    });
    htmlSkill = htmlSkill.slice(0, -2);

    $select.closest('.js-player').find('.js-player-attributes').find('.field').empty();
    $select.closest('.js-player').find('.js-ma').append(player.ma);
    $select.closest('.js-player').find('.js-st').append(player.st);
    $select.closest('.js-player').find('.js-ag').append(player.ag);
    $select.closest('.js-player').find('.js-av').append(player.av);
    $select.closest('.js-player').find('.js-cost').attr('data-cost', player.cost);
    $select.closest('.js-player').find('.js-cost').append(player.cost);
    $select.closest('.js-player').find('.js-skills').append(htmlSkill);

    calculate_treasury();
  });

  disabled_maximun_players();
});

})();
