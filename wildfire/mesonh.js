function ensure28(fn) {
    if (fn <= 28) {
        return fn;
    }
    return fn.substr(fn.length-28);
}

function latcen() {
    return 0.5 * (inputs.upperleft.lat + inputs.lowerright.lat);
}
function loncen() {
    return 0.5 * (inputs.upperleft.lon + inputs.lowerright.lon);
}

function multipleof235(n) {
    // impose n to be multiple of 2, 3 or 5
    var table = [ 2, 3, 4, 5, 6, 8, 9, 10, 15, 16, 18, 20, 24, 25, 27, 30, 32, 36,
		  40, 45, 48, 50, 54, 60, 64, 72, 75, 80, 81, 90, 96, 100, 108, 120,
		  125, 128, 135, 144, 150, 160, 162, 180, 192, 200, 216, 225, 240,
		  243, 250, 256, 270, 288, 300, 320, 324, 360, 375, 384, 400, 405,
		  432, 450, 480, 486, 500, 512, 540, 576, 600, 625, 640, 648, 675,
		  720, 729, 750, 768, 800, 810, 864, 900, 960, 972, 1000, 1064, 2128,
		  4256, 8512]
    var i = 0;
    while ( n > table[i] ) {
	i = i+1;
    }
    return table[i];
}

function ngrid(lower, upper) {
    var deltadeg = 0.05;
    var dif = upper - lower + deltadeg;
    // calculate the number of gridpoints
    // assuming an equivalence of 110 km for 1 degree of latitude and longitude (true at Equator only)
    return multipleof235(parseInt(Math.round(dif * 110575.0 / inputs.dx)));
}

function NI() {
    return ngrid(inputs.upperleft.lon, inputs.lowerright.lon);
}

function NJ() {
    return ngrid(inputs.lowerright.lat, inputs.upperleft.lat);
}
