function mkdirs(paths) {
    return paths.reduceRight(
	function(accumulator, val) {
	    return {
		"class": "Directory",
		"basename": val,
		listing: accumulator ? [accumulator] : []
	    }
	},
	null
    );
}
