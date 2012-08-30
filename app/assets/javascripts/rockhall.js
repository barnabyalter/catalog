/*
  Rockhall Javascript
  Adam Wead
  Rock and Roll Hall of Fame

  This has JQuery functions that get loaded when the page is loaded.  You should either
  use anonymous functions with the .ready method:

  $(document).ready(function () {
    do some stuff..
  });

  or, you can use a named function defined at the end of this page. Ex:

  $(document).ready(myNamedFunction);

*/

// Used to show current holdings from Innovative
$(document).ready(returnStatus);
$(document).ready(returnHoldings);

// Sets up our JSTree using JSON data
// see: http://www.jstree.com/documentation/json_data
$(document).ready(function () {
  $(".ead_toc").jstree({
    "json_data" : {
      "ajax" : {
        "url" : ROOT_PATH+"fa/"+$(".ead_toc").attr("id")+".json"
      }
    },
    "themes" : {
      "theme" : "apple",
      "dots"  : false,
      "icons" : false
    },
    "plugins" : [ "themes", "json_data", "ui" ]
  }).bind("select_node.jstree", function (e, data) {
    // Scroll to the anchor or top of page when the node is clicked
    if(data.rslt.obj.data("anchor") == null) {
      $("html, body").animate({ scrollTop: 0 }, "slow");
    }
    else {
      $('html,body').animate({scrollTop: $(data.rslt.obj.data("anchor")).offset().top},'slow');
    }
    return false;
  });
});

/*

  Named functions

*/

function returnStatus() {

  $('.innovative_status').each(function() {

    var id  = $(this).attr("id");
    var url = ROOT_PATH + "holdings/" + id;

    $.ajax({
      url: url,
      error: function(){
        $('#'+id).append("Unknown");
      },
      success: function(data){
        $('#'+id).replaceWith(data);
      }
    });

  });

}

function returnHoldings() {

  $('.innovative_holdings').each(function() {

    var id  = $(this).attr("id");
    var url = ROOT_PATH + "holdings/" + id + "?type=full";

    $.ajax({
      url: url,
      error: function(){
        $('.innovative_holdings').append("Unknown");
      },
      success: function(data){
        $('.innovative_holdings').append(data);
      }
    });

  });

}