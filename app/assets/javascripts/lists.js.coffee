# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  list_body = $('#list_body')
  main_list = $('#main_list')
  window.cur_position = main_list
  
  
  $('#add_checkbox').click ()->
    if window.cur_position == main_list
     main_list.append("<li><span class='form-group list_item'><input type='checkbox' class=''/> 
        #{$('#new_item_text').val()}</span></li>")
    else
      window.cur_position.after("<li><span class='form-group list_item'><input type='checkbox' class=''/> 
        #{$('#new_item_text').val()}</span></li>")
    
  $('#add_text').click ()->
    main_list.append("<li class='list_item'>
      #{$('#new_item_text').val()}</span></li>")
    
  $(document).on 'click', '.list_item', ()->
  
#     if $(this).children('input[type=checkbox]')
  
    if window.cur_position[0] == $(this)[0]
      window.cur_position = main_list
      $(this).css('background-color','white')
    else
      $('.list_item').each ()->
        $(this).css('background-color','white')
      window.cur_position = $(this)
      $(this).css('background-color','aqua')
  
  $('#save_button').click (e)->
    e.preventDefault()
    $('#list_body_form').val(list_body.html())
    $('#edit_list_1').submit()