# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  ############################################################################
  #-----   load mathjax ----------------------------------------------------#
  ############################################################################
  loadJax()
  $('.prob-id, .test-id, .student-id, .difficulty-used, .right-ans-count').hide()

loadJax = ->
  window.MathJax.Hub.Queue [
    'Typeset'
    MathJax.Hub
    'MainContainerDiv'
  ]

$(document).on "click",".next-btn",(e) ->
  answer = document.querySelector('input[name="answer"]:checked').value
  testId = $('.test-id').text()

  $.ajax
    url: '/test/'+ testId + '/next-problem',
    method: 'POST',
    data: {
      answer: answer,
      problem_number: $('.prob-number').text(),
      problem_id: $('.prob-id').text(),
      test_id: testId
      student_id: $('.student-id').text()
      difficulty_used : $('.difficulty-used').text()
      right_ans_count: $('.right-ans-count').text()
    }
    success: (response) ->
      $('.prob').html(response.text)
      $('.prob-id').html(response.id)
      $('.prob-number').html(response.number)
      $('.difficulty-used').html(response.difficulty_used)
      $('.right-ans-count').html(response.right_ans_count)
      $('input[name=answer]').attr('checked',false);
      if response.last_problem == true
        $('.next-btn').text('Save & Submit')
      loadJax()
      # alert('response received')

