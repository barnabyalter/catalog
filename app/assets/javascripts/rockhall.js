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

// Overrides links to archival items so that there's ajaxed like the others
$(document).ready(componentLink);


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
      "dots"  : true,
      "icons" : false
    },
    "plugins" : [ "themes", "json_data", "ui" ]
  }).bind("select_node.jstree", function (e, data) {
    showComponent(data);
  });
});


// Used with anchor links in the ead sidebar so that the document
// portion of the ead is reloaed via ajax and then scrolls to the anchor
$(document).ready(function () {
  $('.ead_anchor').click(function(event){
      url = this.href.split("#");
      $('#main_container').load(url[0], function() {
        window.scrollTo(0, $("#"+url[1]).position().top);}
      );
      history.replaceState({}, '', this);
      event.preventDefault(); // Prevent link from following its href
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

function showComponent(data) {

  // Declare some variables we are using here
  var url;
  var toggle_url; 
  var link;

  url = ROOT_PATH + "catalog/" + data.rslt.obj.data("id");

  // Toggle and link urls
  if (typeof data.rslt.obj.data("eadid") === "undefined") {
    toggle_url = ROOT_PATH+"catalog/"+data.rslt.obj.data("id")+"?view=full"
  }
  else {
    toggle_url = ROOT_PATH+"catalog/"+data.rslt.obj.data("eadid")+"?view=full#"+data.rslt.obj.data("ref");
  }
  link = '<div id="view_toggle"><a href="'+toggle_url+'">Full view</a></div>';

  $('#main_container').load(url);
  $('#view_toggle').replaceWith(link);

  // replace the current url with the new one
  var host = window.location.hostname;
  var port = window.location.port == 80 ? nil : (":"+window.location.port);
  history.replaceState({}, '', "http://"+host+port+url);

}

// When linking to an archival item:
//  - replaces the main section of the page with the new html via ajax 
//     instead of a completd http call
//  - updates the history so the browser's back button will work
//  - closes/reopens the JStree to same location as the component
function componentLink() {
  $(".component_link").click( function() {

    var url     = this.getAttribute("href");
    var id      = this.getAttribute("id");
    var parents = $(".ead_toc").jstree("get_path", "#"+id, "TRUE");

    $('#main_container').load(url);
    history.replaceState({}, '', this);
    
    if(id){
      $.each(parents, function(index, value) { 
        $(".ead_toc").jstree("open_node", "#"+value)
      });
    };
    
    return false;
  });

}

function openTreeForItem(id) {
  $(document).ready(function () {

    if(id){
      $(".ead_toc").bind("loaded.jstree", function (event, data) {
        var parents = $(".ead_toc").jstree("get_path", "#"+id, "TRUE");
        $.each(parents, function(index, value) { 
          $(".ead_toc").jstree("open_node", "#"+value)
        });
      });
    };

  });
}
