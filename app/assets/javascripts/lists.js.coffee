# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if namespace.controller is "lists" and namespace.action is "index"
    new List('lists', {valueNames: ['title', 'owner', 'date', 'completeness']})

  window.list_body = $('#list_body')
  
  if namespace.controller is "lists" and namespace.action is "edit"
        
    $("#list_body").sortable({items: 'li', placeholder: 'list-group-item placeholder', dropOnEmpty: true,tolerance: 'intersect', connectWith: 'ul'})
  
    # Edit an element #
    $(document).on 'dblclick', '.editable', (e) ->
      unless $(this).hasClass('editing')
        old = $(this).html().replace(/"/g, "&#34;").replace(/'/g, "&#39;")
        $(this).addClass('editing')
        $(this).html("<i class='fa fa-floppy-o save-edit'></i><input class='edit-box form-control' type='text' value='#{old}'/>")
        
    $(document).on 'click', '.save-edit', (e) ->
      $(this).parents('.editable').removeClass('editing')
      $(this).parents('.editable').html($(this).siblings('input').val())
  
  # Adding a checkbox #
  $('#add_checkbox').click (e) ->
    e.preventDefault()
    position = $('.cursor')
    if position.hasClass('sublist-title')
      position = position.siblings('ul')
    checkbox = $(HandlebarsTemplates['lists/checkbox']({value: $('#new_item_text').val()})).uniqueId()
    position.append(checkbox)
    $('#new_item_text').val('')
    $('#new_item_text').focus()
    calculate_completeness()
    
  # Adding a  sublist #
  $('#add_sublist').click (e) ->
    e.preventDefault()
    position = $('.cursor')
    if position.hasClass('sublist-title')
      position = position.siblings('ul')
    sublist = $(HandlebarsTemplates['lists/sublist']({value: $('#new_item_text').val()})).uniqueId()
    position.append(sublist)
    $('#new_item_text').val('')
    $('#new_item_text').focus()
    
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
    x = $(this).parents('li.checklist-item')
    x.fadeOut(250)
    x.remove()
    
  $(document).on 'click', '.delete-sublist-item', (e) ->
    e.stopPropagation()
    x = $(this).closest('li')
    x.fadeOut(250)
    x.remove()

  window.calculate_completeness = () ->
    $('.sublist').each () ->
      num_checkboxes = $(this).find('.checkbox').length
      num_checked = $(this).find('.checkbox.fa-check-square-o').length
      if num_checkboxes > 0
        completeness = ((num_checked/num_checkboxes)*100).toFixed(2)
      else
        completeness = 100
      $(this).find('.sublist_completion').html("(#{completeness}%)")

    #Overall
    num_checkboxes = $('.checkbox').length
    num_checked = $('.checkbox.fa-check-square-o').length


    if num_checkboxes > 0
      completeness = ((num_checked/num_checkboxes)*100).toFixed(2)
    else
      completeness = 100
    $('#completeness').html("#{completeness}% Complete")
    completeness
  calculate_completeness();
  
  
  $('#save_button').click (e)->
    e.preventDefault()
    $('.editing').each ()->
      $(this).find('.save-edit').trigger('click')
    $('i.fa-times-circle').each ()->
      $(this).show()
    $('ul').addClass('list-group')  
    $('li').addClass('list-group-item')  
    $('.cursor').css('background-color','white')
    $('.cursor').removeClass('cursor')
    window.list = {}
    listToJSON($('#list_body'), window.list)
    $('#list_body_form').val(JSON.stringify(window.list))
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
    $('ul.list-group').removeClass('list-group')
    $('li.list-group-item').removeClass('list-group-item')
    
    
  window.list = {}
  window.listToJSON = (obj, list_level) ->
    for item in obj.children('li')
      item = $(item)
      id = item.attr('id')
      text = $.trim($(item).find('text').html())
      if item.hasClass('checklist-item')
        list_level[id] =
          text: text
          id: id
          type: 'checkbox'
          checked: item.children('i.checkbox').attr('class')
      else
        list_level[id] = 
          text: text
          id: id
          type: 'sublist'
          list: {}
        listToJSON($(item).find('ul:first'), list_level[id].list)

  window.jsonToList = (element, obj) ->
    $.each obj, (key, val) ->
      if val.type == 'sublist'
        element.append(HandlebarsTemplates['lists/sublist']({value: val.text, id: val.id}))
        jsonToList(element.find("li[id=#{val.id}]").find('ul:first'), val.list)
      else
        element.append(HandlebarsTemplates['lists/checkbox']({value: val.text, id: val.id, checkstate: val.checked}))
       
  console.log $('#imported').data('imported')   
  window.jsonToList($('#list_body'), $('#imported').data('imported'))