$(document).ready(function() {
  $('a.collapse-table').click(function(e){
    if ($(this).text() == '▼'){ $(this).text('▲'); } else { $(this).text('▼'); }
    $(this).parents('table').find('tr.collapsible').toggle();
  });

  //Leave first table expanded
  $('a.collapse-table').each(function(i,e){
    if (i != 0){ $(e).click(); }
  });
});
