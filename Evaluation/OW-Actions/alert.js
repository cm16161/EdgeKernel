function alert(n){
    if (n < 50.0) return "no";
    return "yes";
}

function main({sensor}) {
    var msg = "no";
    if (sensor) {
	msg = alert(parseFloat(sensor));
  }    
    return {"body":msg}
}
