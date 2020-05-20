function main({initial}) {
    let ts = Date.now();
    return {"body":ts - (initial/1000000)}
}
