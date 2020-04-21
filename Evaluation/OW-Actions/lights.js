function flip_switch(n){
    if (String(n) == "true") return "on";
    return "off";
}

function main({sensor}) {
    var msg = "off";
    if (sensor) {
	msg = flip_switch(sensor);
  }    
    return {"body":msg}
}
