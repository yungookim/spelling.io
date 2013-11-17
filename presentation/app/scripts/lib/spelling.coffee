(($) ->

  $.fn.spelling = (params)-> 
    window.spellingio = window.spellingio or {}
    window.spellingio.inputbox = @

    # Make the wrappers
    $wrapper = $('<div/>').addClass('spell-search')
    $wrapper.insertAfter @

    # Configure the input box
    @detach().appendTo $wrapper

    # Append <ul> where the results will seat in
    $result = $ '<ul class="spelling-results"/>'
    $wrapper.append $result

    @keydown (e) =>

      # If there is a space after the last word, assume the user is done with the previous word
      return $('.spelling-results').empty() if e.keyCode is 32

      # We are only concerned with the last word. i.e. after the last space
      input_arr  = @val().split(' ')
      last_input = input_arr[input_arr.length-1]

      $('.spelling-results').empty() if last_input.length < 3
      if last_input.length > 3
        url = "http://localhost:8080/api/query/en/" + last_input
        $.getJSON url + "?callback=query_results", null, (rets) ->
          $('.spelling-results').empty()
          _.each rets, (word) =>

            $li = $("<li/>").html($("<a/>").html word.word)
            $('.spelling-results').append $li

            # Switch the selected word with the word in the input box (Word that has the cursor)
            $li.bind 'click', (e)=>
              word = $(e.currentTarget).find('a').html()
              val = window.spellingio.inputbox.val()
              val_arr = val.split ' '
              # Replace
              val_arr[val_arr.length-1] = word
              _str = val_arr.join(' ')
              window.spellingio.inputbox.val(_str)
              # return the focus back to the input box
              window.spellingio.inputbox.focus()
              # Then empty the result box
              $('.spelling-results').empty()



) jQuery