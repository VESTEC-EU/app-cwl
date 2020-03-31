function ensure28(fn) {
    if (fn <= 28) {
        return fn;
    }
    return fn.substr(fn.length-28);
}
