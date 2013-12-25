(function() {
  var query_results;

  window.presentation = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    init: function() {
      'use strict';
      return $('#query').spelling();
    }
  };

  $(function() {
    'use strict';
    return presentation.init();
  });

  query_results = function(ret) {};

}).call(this);
