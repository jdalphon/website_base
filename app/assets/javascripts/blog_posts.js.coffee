# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#content_summernote').summernote
    height: 400
    
  new List('blog_posts', {valueNames: ['title', 'category']})