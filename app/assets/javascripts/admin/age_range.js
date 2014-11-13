$(document).ready(function() {
  if ($('input[name=has_age_range]:checked').val() == 'false'){
    $('#age-fields').hide();
  }
  $('#has_age_range_true, #has_age_range_false').change(function(){
    if($(this).val() == 'true'){
      $('#age-fields').show();
    } else {
      $('#age-fields').hide();
      $('#service_min_age').val(0);
      $('#service_max_age').val(100);
    }
  });
});
