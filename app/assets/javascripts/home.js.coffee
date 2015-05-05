# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  #HIDE ALERTS
  timeout_hide_alerts = ()->
    $(document).find('.alert.fade.in').fadeOut(500)
  setTimeout timeout_hide_alerts, 2000