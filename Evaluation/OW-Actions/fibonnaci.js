function fibonacci(n){
    if (n < 3) return 1;
    return fibonacci (n-1) + fibonacci (n-2);
}

function main({fib_number}) {
    var msg = 1;
    if (fib_number) {
	msg = fibonacci(parseInt(fib_number,10));
  }    
    return {"body":msg}
}
