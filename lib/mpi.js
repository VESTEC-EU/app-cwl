var mpi = {
    get_default: function (prop, def) {
	var val = inputs.mpi[prop];
	return (val === null) ? def : val;
    },
    run: function (basecommand) {
	var tasks = this.get_default("tasks", 0);
	var launcher = this.get_default("launcher", "mpirun");
	var tasks_flag = this.get_default("tasks_flag", "-n");
	var extra_flags = this.get_default("extra_flags", []);

	if (tasks > 0) {
	    var cmdlist = [launcher, tasks_flag, tasks];
	    cmdlist = cmdlist.concat(extra_flags);
	    cmdlist.push(basecommand);
	    return cmdlist;
	}
	return [basecommand];
    }
}
