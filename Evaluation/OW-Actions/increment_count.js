function main({count}) {
    var msg = 1;
  if (count) {
      msg = parseInt(count,10) + 1
  }    
    return {"body":msg}
}
