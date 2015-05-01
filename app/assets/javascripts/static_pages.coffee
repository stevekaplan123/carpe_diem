# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $("input#fake-signup").click ->
    $("input#fake-signup").css("display", "none");
    $(".hidden").removeClass("hidden");
