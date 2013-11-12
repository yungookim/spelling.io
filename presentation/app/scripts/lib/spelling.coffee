(($) ->

  $.fn.spelling = (params)-> 

    console.log params


    # Make the wrappers
    $wrapper = $('<div/>').addClass('spell-search')
    $wrapper.insertAfter @

    # Configure the input box
    @detach().appendTo $wrapper

    # Append <ul> where the results will seat in
    $result = $ '<ul class="results"/>'
    $wrapper.append $result


    $('#query').keydown (e) ->
      if e.keyCode is 13
        $('.results').empty()
        url = "http://localhost:8080/api/query/en/" + val = $("#query").val()
        $.getJSON url + "?callback=query_results", null, (rets) ->
          console.log rets
          _.each rets, (word) ->
            li = $("<li/>").html($("<a/>").html word.word + ' - ' + word.similarity)
            $('.results').append li

) jQuery 