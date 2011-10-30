$ ->
  $("#build-hubot").validate
    rules:
      name: "required"
      email:
        required: true
        email: true
    messages:
      name: "Oops! Your robot needs a name"
      email:
        required: "Oops! We need your email to transfer the application to you"

  $("input[name='adapter']").change ->
    name = $(@).val()

    $(".adapter-vars").slideUp ->
      $(@).hide()

    $("#adapter-" + name).slideDown ->
     $(@).show()

