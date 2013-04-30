$(document).ready ->
    file_data = $("#file_data")
    clearBn = $("#clear")
    clearBn.on "click", ->
        file_data.replaceWith file_data.val("").clone(true)
