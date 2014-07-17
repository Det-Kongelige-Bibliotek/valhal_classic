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
    if (document.getElementById("instance_agents").value.length == 0) {
        agentRelations =  [ {agent_relation: { relationshipType: relationshipType, agentID: agentObjectID }}];
        document.getElementById("instance_agents").value = JSON.stringify(agentRelations);
    } else {
        agentRelations = JSON.parse(document.getElementById("instance_agents").value);
        var agentRelation = {agent_relation: { relationshipType: relationshipType, agentID: agentObjectID }};
        agentRelations.push(agentRelation);
        document.getElementById("instance_agents").value = JSON.stringify(agentRelations);
    }
}
