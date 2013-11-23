(function() {
  (function($) {
    return $.fn.spelling = function(params) {
      var $result, $wrapper, QUERY_LIMIT, WITH_STATES,
        _this = this;
      params = params || {};
      QUERY_LIMIT = 3 || params.limit;
      WITH_STATES = false || params.states;
      window.spellingio = window.spellingio || {};
      window.spellingio.inputbox = this;
      $wrapper = $('<div/>').addClass('spell-search');
      $wrapper.insertAfter(this);
      this.detach().appendTo($wrapper);
      $result = $('<ul class="spelling-results"/>');
      $wrapper.append($result);
      return this.keydown(function(e) {
        var callback, input_arr, last_input, query_string, selected_word, uri, url, val, val_arr, _str;
        if (e.keyCode === 40) {
          if (!window.spellingio.selected) {
            window.spellingio.selected = $('.spelling-results').children(":first").find('a').addClass('selected');
          } else {
            window.spellingio.selected.removeClass('selected');
            if ($('.spelling-results').children(":last").find('a').is(window.spellingio.selected)) {
              window.spellingio.selected = $('.spelling-results').children(":first").find('a').addClass('selected');
            } else {
              window.spellingio.selected = window.spellingio.selected.parent().next().find('a').addClass('selected');
            }
          }
          return;
        } else if (e.keyCode === 38) {
          e.preventDefault();
          if (!window.spellingio.selected) {
            window.spellingio.selected = $('.spelling-results').children(":last").find('a').addClass('selected');
          } else {
            window.spellingio.selected.removeClass('selected');
            if ($('.spelling-results').children(":first").find('a').is(window.spellingio.selected)) {
              window.spellingio.selected = $('.spelling-results').children(":last").find('a').addClass('selected');
            } else {
              window.spellingio.selected = window.spellingio.selected.parent().prev().find('a').addClass('selected');
            }
          }
          return;
        }
        if (e.keyCode === 13) {
          selected_word = window.spellingio.selected.html().split(' ')[0];
          val = window.spellingio.inputbox.val();
          val_arr = val.split(' ');
          val_arr[val_arr.length - 1] = selected_word;
          _str = val_arr.join(' ');
          window.spellingio.inputbox.val(_str);
          window.spellingio.inputbox.focus();
          $('.spelling-results').empty();
          window.spellingio.inputbox.val(window.spellingio.inputbox.val() + ' ');
        }
        if (e.keyCode === 32) {
          return $('.spelling-results').empty();
        }
        if (window.spellingio.inputbox.val().slice(-1) === ' ') {
          return $('.spelling-results').empty();
        }
        input_arr = _this.val().split(' ');
        last_input = input_arr[input_arr.length - 1];
        if (last_input.length < 3) {
          $('.spelling-results').empty();
        }
        if (last_input.length > 2) {
          url = 'http://api.spelling.io/api/query/en/';
          query_string = '?limit=' + QUERY_LIMIT + '&states=' + WITH_STATES;
          callback = '&callback=query_results';
          uri = url + last_input + query_string + callback;
          return $.getJSON(uri, null, function(rets) {
            var _this = this;
            $('.spelling-results').empty();
            delete window.spellingio.selected;
            return _.each(rets, function(word) {
              var $li, result_presentation;
              if (WITH_STATES) {
                result_presentation = word.word + ' ' + word.occurrence + ' ' + word.similarity;
              } else {
                result_presentation = word.word;
              }
              $li = $("<li/>").html($("<a/>").html(result_presentation));
              $('.spelling-results').append($li);
              return $li.bind('click', function(event) {
                word = $(event.currentTarget).find('a').html().split(' ')[0];
                val = window.spellingio.inputbox.val();
                val_arr = val.split(' ');
                val_arr[val_arr.length - 1] = word;
                _str = val_arr.join(' ');
                window.spellingio.inputbox.val(_str);
                window.spellingio.inputbox.focus();
                return $('.spelling-results').empty();
              });
            });
          });
        }
      });
    };
  })(jQuery);

}).call(this);
