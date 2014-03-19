/**
 * Created by rails_user on 3/19/14.
 */
/**
 * Javascript to enable bootstrap styling of our file upload button
 * stolen most ingloriously from anonymous heroes of the interwebs
 */
$(document)
    .on('change', '.btn-file :file', function() {
        var input = $(this),
            numFiles = input.get(0).files ? input.get(0).files.length : 1,
            label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
        input.trigger('fileselect', [numFiles, label]);
    });

$(document).ready(function () {
    console.log("getting to button.js");

    $('.btn-file :file').on('fileselect', function (event, numFiles, label) {
        $('#js_button_text').text(label);
    });
});