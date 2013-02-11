$(document).ready(function(){

    var file_data = $('#file_data'),
    clearBn = $('#clear');

    clearBn.on('click', function () {
        // Some browsers will actually honor .val('')
        // So I'm adding it back onto the solution
        file_data.replaceWith(file_data.val('').clone(true));
    });

});
