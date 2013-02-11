$(document).ready(function(){

    //file_data = $('#file_data'),
    var clearBn = $('#clear');

    clearBn.on('click', function () {
        // Some browsers will actually honor .val('')
        // So I'm adding it back onto the solution
        file_data = $("#clear");
        //alert(file_data.val());
        file_data.replaceWith(file_data.val('').clone(true));
        //alert(file_data.val());
    });

});
