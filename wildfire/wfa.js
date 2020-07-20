function structure_wfa_output(flat) {
    var output = {}
    flat.forEach(function(item, index) {
	var x = item.nameroot.split("_");
	var sim_type = x[1];
	var ras_type = x[2];
	if (!output.hasOwnProperty(sim_type))
	    output[sim_type] = {};
	output[sim_type][ras_type] = item;
    });
    return output;
}
