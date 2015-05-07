# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if namespace.controller is "lists" and namespace.action is "index"
    new List('lists', {valueNames: ['title', 'owner', 'date', 'completeness']})

  window.list_body = $('#list_body')
  
  if namespace.controller is "lists" and namespace.action is "edit"
    $("#list_body").sortable()
  
    # Edit an element #
    $(document).on 'dblclick', '.editable', (e) ->
      unless $(this).hasClass('editing')
        old = $(this).html()
        $(this).addClass('editing')
        $(this).html("<i class='fa fa-floppy-o save-edit'></i><input class='edit-box' type='text' value='#{old}'/>")
        
    $(document).on 'click', '.save-edit', (e) ->
      $(this).parents('.editable').removeClass('editing')
      $(this).parents('.editable').html($(this).siblings('input').val())
  
  # Adding a checkbox #
  $('#add_checkbox').click (e) ->
    e.preventDefault()
    position = $('.cursor')
    if position.hasClass('sublist-title')
      if namespace.controller is "lists" and namespace.action is "edit"
        position.siblings('.sublist-list').sortable()
      position = position.siblings('ul')
    position.append("
      <div class='checklist-item'>
        <i class='fa fa-square-o checkbox'></i>
        <text class='editable'>#{$('#new_item_text').val()}</text>
        <i class='fa fa-times-circle delete-checklist-item'></i>
      </div>")
    
    $('#new_item_text').val('')
  
  # Adding a  sublist #
  $('#add_sublist').click (e) ->
    e.preventDefault()
    list_body.append("
      <div class='sublist'>
        <div class='sublist-title'>
          <text class='editable'>#{$('#new_item_text').val()}</text> 
          <i class='fa fa-times-circle delete-sublist-item'></i>
        </div>
        <ul class='sublist-list'></ul>
      </div>") 
    $('#new_item_text').val('')
    
  # Selecting a sublist #
  $(document).on 'click', '.sublist-title', (e) ->
    if $(this).hasClass('cursor')
      $(this).css('background-color','white')
      $('.cursor').removeClass('cursor')
      window.list_body.addClass('cursor')
    else
      $('.cursor').css('background-color','white')
      $('.cursor').removeClass('cursor')
      $(this).css('background-color','aqua')
      $(this).addClass('cursor')
    
    
  # What to do when clicking checkbox
  $(document).on 'click', '.checkbox', (e) ->
    e.stopPropagation()
    if $(this).hasClass('fa-square-o')
      $(this).removeClass('fa-square-o')
      $(this).addClass('fa-check-square-o')
    else
      $(this).removeClass('fa-check-square-o')
      $(this).addClass('fa-square-o')
    calculate_completeness()

  # Delete a checklist item
  $(document).on 'click', '.delete-checklist-item', (e) ->
    x = $(this).parents('div.checklist-item')
    x.fadeOut(250)
    x.remove()
    
  $(document).on 'click', '.delete-sublist-item', (e) ->
    e.stopPropagation()
    x = $(this).parents('div.sublist')
    x.fadeOut(250)
    x.remove()

  window.calculate_completeness = () ->
    num_checkboxes = $('.checkbox').length
    num_checked = $('.checkbox.fa-check-square-o').length

    if num_checkboxes > 0
      completeness = ((num_checked/num_checkboxes)*100).toFixed(2)
    else
      completeness = 0
    $('#completeness').html("#{completeness}% Complete")
    completeness
  calculate_completeness();
  
  
  $('#save_button').click (e)->
    e.preventDefault()
    $('.editing').each ()->
      $(this).find('.save-edit').trigger('click')
    $('i.fa-times-circle').each ()->
      $(this).show()
    $('.cursor').css('background-color','white')
    $('.cursor').removeClass('cursor')
    $('#list_body_form').val(list_body.html())
    $('#list_completeness').val(calculate_completeness())
    $('.edit_list').submit()
  
  $('#cancel_button').click (e)->
    e.preventDefault()
    location.reload()
   
  $(document).on 'keypress', '.edit-box', (e) ->
    if(e.keyCode == 13)
      $(this).siblings('.save-edit').trigger('click')
      return false
   
  # Do not show delete buttons on show page 
  if namespace.controller is "lists" and namespace.action is "show"
    $('i.fa-times-circle').each ()->
      $(this).hide()