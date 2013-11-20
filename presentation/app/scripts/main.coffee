window.presentation =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'

    $('#query').spelling({states : true})
    
$ ->
  'use strict'
  presentation.init();


query_results = (ret)->