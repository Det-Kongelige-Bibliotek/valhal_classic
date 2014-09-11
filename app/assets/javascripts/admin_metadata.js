/**
 * Function for populating the adminMetaData Material Type drop-down with data depending on the material group chosen
 * Makes an AJAX GET request to the WorksController to load required data from admin_metadata_materials.yml
 * @param object_id - the Fedora ID of the object whose admin metadata is being changed
 */
function enableMaterialTypes(object_id) {
    var div =$("#material_type_div");

    $.ajax({url:"/works/" + object_id +"/get_admin_material_types", format: 'json', success: function(result) {
        var selected_material_group = $('#material_group').val().toLowerCase();

        if (selected_material_group == '') {
            div.hide();
        }

        $('#administration_material_type').find('option').remove();

        if (result[selected_material_group] == undefined) {
            $('#administration_material_type')
                .append($("<option></option>")
                    .attr("value", selected_material_group)
                    .text($('#material_group').val()));
        } else {
            $.each(result[selected_material_group], function(key, value) {
                $('#administration_material_type')
                    .append($("<option></option>")
                        .attr("value", value)
                        .text(value));
            });
        }
    }});

     if (div.css('display') == 'none') {
        div.show();
     }
}

$(document).ready(function(){
    /**
     * Toggle display of embargo fields based on embargo
     * checklist. Update hidden field val with checkbox value.
     */
    $('[data-toggle="show-embargo-fields"]').click(function(){
        var checked = $(this).prop('checked');
        if (checked) {
            $('.embargo-fields').removeClass('hidden');

        } else {
            $('.embargo-fields').addClass('hidden');
        }
        $('#embargo-value').val(checked);
    });
});
