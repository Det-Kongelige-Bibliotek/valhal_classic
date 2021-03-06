// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee basic_files within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled basic_files.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.sortable.min
//= require works
//= require admin_metadata
//= require vocabularies
//= require bootstrap-combobox
//= require google-code-prettify/run_prettify
//
// require rails.validations DEPRECATED: Do Not Use
//
// Required by Blacklight
//= require blacklight/blacklight
// require_tree .
$(document).ready(function(){
    $('.combobox').combobox();
    $('.combobox').click(function(){
        $(this).siblings('.dropdown-toggle').click();
    });
});
