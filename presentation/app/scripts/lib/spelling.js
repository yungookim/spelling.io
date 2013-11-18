// Generated by CoffeeScript 1.6.3
(function($) {
  return $.fn.spelling = function(params) {
    var $result, $wrapper;
    console.log(params);
    $wrapper = $('<div/>').addClass('spell-search');
    $wrapper.insertAfter(this);
    this.detach().appendTo($wrapper);
    $result = $('<ul class="results"/>');
    $wrapper.append($result);
    return $('#query').keydown(function(e) {
      var url, val;
      if (e.keyCode === 13) {
        $('.results').empty();
        url = "http://localhost:8080/api/query/en/" + (val = $("#query").val());
        return $.getJSON(url + "?callback=query_results", null, function(rets) {
          console.log(rets);
          return _.each(rets, function(word) {
            var li;
            li = $("<li/>").html($("<a/>").html(word.word + ' - ' + word.similarity));
            return $('.results').append(li);
          });
        });
      }
    });
  };
})(jQuery);