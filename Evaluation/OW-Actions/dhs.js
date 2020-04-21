function calculate(current,value,day){
    return (current*day + value)/(day + 1);;
}

function main({current, new_value, day}) {
    var msg = calculate(current,new_value,day);
    return {"body":msg}
}
