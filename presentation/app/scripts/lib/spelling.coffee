(($) ->

  $.fn.spelling = (params)-> 
    params = params or {}
    QUERY_LIMIT = 3 or params.limit
    WITH_STATES = false or params.states

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
      # window.spellingio.selected keeps track of which word is selected by keyboard input
      # Keyboard input hanlders

      # Down key
      if e.keyCode is 40
        unless window.spellingio.selected
          window.spellingio.selected = $('.spelling-results').children(":first").find('a').addClass 'selected'
        else
          window.spellingio.selected.removeClass 'selected'

          if $('.spelling-results').children(":last").find('a').is(window.spellingio.selected)
            # Go back to the top
            window.spellingio.selected = $('.spelling-results').children(":first").find('a').addClass 'selected'
          else
            window.spellingio.selected = window.spellingio.selected.parent().next().find('a').addClass 'selected'
        return

      # Up key
      else if e.keyCode is 38
        e.preventDefault()
        unless window.spellingio.selected
          window.spellingio.selected = $('.spelling-results').children(":last").find('a').addClass 'selected'
        else
          window.spellingio.selected.removeClass 'selected'
          if $('.spelling-results').children(":first").find('a').is(window.spellingio.selected)
            # Go to the last
            window.spellingio.selected = $('.spelling-results').children(":last").find('a').addClass 'selected'
          else
            window.spellingio.selected = window.spellingio.selected.parent().prev().find('a').addClass 'selected'
        return

      # Enter key when an element is focused
      if e.keyCode is 13
        selected_word = window.spellingio.selected.html()
        val = window.spellingio.inputbox.val()
        val_arr = val.split ' '
        # Replace
        val_arr[val_arr.length-1] = selected_word
        _str = val_arr.join(' ')
        window.spellingio.inputbox.val(_str)
        # return the focus back to the input box
        window.spellingio.inputbox.focus()
        # Then empty the result box
        $('.spelling-results').empty()
        # Add space in the end
        window.spellingio.inputbox.val window.spellingio.inputbox.val() + ' '

      # If there is a space after the last word, assume the user is done with the previous word
      return $('.spelling-results').empty() if e.keyCode is 32
      return $('.spelling-results').empty() if window.spellingio.inputbox.val().slice(-1) is ' '

      # We are only concerned with the last word. i.e. after the last space
      input_arr  = @val().split(' ')
      last_input = input_arr[input_arr.length-1]

      $('.spelling-results').empty() if last_input.length < 3
      if last_input.length > 2
        url = 'http://api.spelling.io/api/query/en/'
        query_string = '?limit=' + QUERY_LIMIT + '&states=' + WITH_STATES
        callback = '&callback=query_results'
        uri = url + last_input + query_string + callback

        $.getJSON uri, null, (rets) ->

          $('.spelling-results').empty()
          delete window.spellingio.selected

          _.each rets, (word) =>
            
            if WITH_STATES
              result_presentation = word.word + ' ' + word.occurrence + ' ' + word.similarity
            else 
              result_presentation = word.word 

            $li = $("<li/>").html($("<a/>").html result_presentation)
            $('.spelling-results').append $li

            # Switch the selected word with the word in the input box (Word that has the cursor)
            $li.bind 'click', (event)=>
              word = $(event.currentTarget).find('a').html()
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