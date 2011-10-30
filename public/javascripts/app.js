(function() {
  $(function() {
    $("#build-hubot").validate({
      rules: {
        name: "required",
        email: {
          required: true,
          email: true
        }
      },
      messages: {
        name: "Oops! Your robot needs a name",
        email: {
          required: "Oops! We need your email to transfer the application to you"
        }
      }
    });
    return $("input[name='adapter']").change(function() {
      var name;
      name = $(this).val();
      $(".adapter-vars").slideUp(function() {
        return $(this).hide();
      });
      return $("#adapter-" + name).slideDown(function() {
        return $(this).show();
      });
    });
  });
}).call(this);
