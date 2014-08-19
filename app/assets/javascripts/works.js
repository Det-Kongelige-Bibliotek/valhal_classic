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

/**
 * Provides functionality for adding new agents and their relationship to a work or instance in a table
 * @param relationshipType
 * @param agentName
 * @param agentObjectID
 */
function addAgent(relationshipType, agentName, agentObjectID) {

    var tableBody = document.getElementById("agent_relations").getElementsByTagName('tbody')[0];

    //Remove the None values row
    if (tableBody.getElementsByTagName("tr")[0].children[0].textContent == "None") {
        tableBody.deleteRow(0);
    }

    var rowId = tableBody.children.length;

    var row = tableBody.insertRow(tableBody.rows.length);
    var relationshipCell = row.insertCell(0);
    relationshipCell.setAttribute("id", "relation[" + rowId + "]");
    var agentNameCell = row.insertCell(1);
    agentNameCell.setAttribute("id", agentObjectID);
    relationshipCell.innerHTML = relationshipType;
    agentNameCell.innerHTML = agentName;

    var agentRelations;
    if (document.getElementById("work_agents").value.length == 0) {
        agentRelations =  [ {agent_relation: { relationshipType: relationshipType, agentID: agentObjectID }}];
        document.getElementById("work_agents").value = JSON.stringify(agentRelations);
    } else {
        agentRelations = JSON.parse(document.getElementById("work_agents").value);
        var agentRelation = {agent_relation: { relationshipType: relationshipType, agentID: agentObjectID }};
        agentRelations.push(agentRelation);
        document.getElementById("work_agents").value = JSON.stringify(agentRelations);
    }
}