function alert(n){
    if (n < 100.0) return "no";
    return n.toString();
}

function main({sensor}) {
    var msg = "no";
    if (sensor) {
	msg = alert(parseFloat(sensor));
  }    
    return {"body":msg}
}
