/**
 * Function for populating the adminMetaData Material Type drop-down with data depending on the material group chosen
 * Makes an AJAX GET request to the WorksController to load required data from admin_metadata_materials.yml
 */
function enableMaterialTypes(work_id) {
    //var div =$("#material_type_div");

    $.ajax({url:"/works/" + work_id +"/get_admin_material_types", format: 'json', success: function(result) {
        console.log(result);

        var selected_material_group = $('#material_group').val().toLowerCase();

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

    /*
     if (div.css('display') == 'none') {
     div.show();
     }*/
}
