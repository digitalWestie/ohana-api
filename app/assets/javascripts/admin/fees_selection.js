$(document).ready(function() {

  if ($('input[name=has_fee]:checked').val() == 'false'){
    $('#fees-para').hide();
  }

  $('#has_fee_true, #has_fee_false').change(function(){
    if($(this).val() == 'true'){
      $('#fees-para').show();
    } else {
      $('#fees-para').hide();
      $('#service_fees').val('');
      $('#service_fees').val('');
    }
  });

});
