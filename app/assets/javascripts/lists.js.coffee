# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  window.list_body = $('#list_body')
  window.main_list = $('#main_list')
  window.cur_position = main_list
  
  window.calculate_completeness = () ->
    num_checkboxes = $('input[type=checkbox]').length
    num_checked = $('input[type=checkbox]:checked').length
    $('#completeness').html("#{(num_checked/num_checkboxes)*100}% Complete")

  calculate_completeness();
  
  ### Add a checkbox ###
  if namespace.controller is "lists" and namespace.action is "edit"
    $('#add_checkbox').click (e)->
      console.log window.cur_position
      e.preventDefault()
      if window.cur_position == main_list
        main_list.append("
          <li>
            <span class='form-group list_item'>
              <input type='checkbox' class=''/> #{$('#new_item_text').val()} 
            </span>
            <i class='fa fa-times-circle'></i>
          </li>")
      else
        window.cur_position.after("
          <li>
            <span class='form-group list_item'>
              <input type='checkbox' class=''/> #{$('#new_item_text').val()}
            </span>
            <i class='fa fa-times-circle'></i>
          </li>")
      $('#new_item_text').val('')
    $(document).on 'click', '.fa-times-circle', ()->
      $(this).parent('li').remove()
    
    ### Add a Heading ###  
    $('#add_text').click (e)->
      e.preventDefault()
      main_list.append("<li class='list_item'><span style='font-weight:bold; font-size:1.2em'>
        #{$('#new_item_text').val()} </span><i class='fa fa-times-circle'></i></li>")
      $('#new_item_text').val('')
      
    $('#add_break').click (e)->
      e.preventDefault()
      window.cur_position.after("<li><i class='fa fa-times-circle'></i></li>")
    
  $(document).on 'click', '.list_item', ()->
  
    if namespace.controller is "lists" and namespace.action is "show"
      x = $(this).children('input[type=checkbox]').prop('checked')
      unless typeof x == 'undefined'
        if x
          $(this).children('input[type=checkbox]')[0].setAttribute('checked','checked')
        else
          $($(this).children('input[type=checkbox]')[0]).removeAttr('checked')
        calculate_completeness();
        
    if namespace.controller is "lists" and namespace.action is "edit"
      if window.cur_position[0] == $(this)[0]
        window.cur_position = window.main_list
        $(this).css('background-color','white')
      else
        $('.list_item').each ()->
          $(this).css('background-color','white')
        window.cur_position = $(this)
        $(this).css('background-color','aqua')
  
  $('#save_button').click (e)->
    e.preventDefault()
    $('i.fa-times-circle').each ()->
      $(this).show()
    $('.list_item').each ()->
      $(this).css('background-color','white')
    $('#list_body_form').val(list_body.html())
    $('.edit_list').submit()
  
  $('#cancel_button').click (e)->
    e.preventDefault()
    location.reload()
   
  # Do not show delete buttons on show page 
  if namespace.controller is "lists" and namespace.action is "show"
    $('i.fa-times-circle').each ()->
      $(this).hide()