function handle_onsubmit() {
    //want it to invoke the sortable event
    var test_val;
    test_val = $("#structmap_file_list").find("li").filter(function() {
        return $(this).find("ul").length === 0;
    }).map(function(i, e) {
            return $(this).text();
        }).get();
    return $("#structmap_file_order").val(test_val);
}

$(document).ready(function() {
    var file_tei_file, file_tiff_file, teiFileClearBn, tiffFileClearBn;
    file_tei_file = $("#file_tei_file");
    file_tiff_file = $("#fileupload");
    tiffFileClearBn = $("#tiff_file_clear");
    teiFileClearBn = $("#tei_file_clear");
    teiFileClearBn.on("click", function() {
        return file_tei_file.replaceWith(file_tei_file.val("").clone(true));
    });
    tiffFileClearBn.on("click", function() {
        return file_tiff_file.replaceWith(file_tiff_file.val("").clone(true));
    });
    $(function() {});
    $(".sortable").sortable();
    $(".handles").sortable({
        handle: "span"
    });
    return $(".sortable").sortable().bind("sortupdate", function() {
        var test_val;
        test_val = $("#structmap_file_list").find("li").filter(function() {
            return $(this).find("ul").length === 0;
        }).map(function(i, e) {
                return $(this).text();
            }).get();
        return $("#structmap_file_order").val(test_val);
    });
});
