$(document).ready(function() {
  $('#availability-selector').select2({
    minimumInputLength: 3,
    ajax: {
      url: $(this).data('url'),
      dataType: "json",
      data: function(term, page) {
        return {
          q: term,
        }
      },
      results: function(data, page) {
        return {
          results: $.map( data, function(loc, i) {
            return { id: loc.id, text: loc.name }
          } )
        }
      }
    }
  });

  $('#availability-selector').on("select2-selecting", function(e) {
    $('#availability_at_' + e.choice.id).show();
    $('#destroy_availability_at_' + e.choice.id).val('false');
  });
});
