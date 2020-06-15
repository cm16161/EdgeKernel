open Lwt.Infix
open Printf
open EdgeKernelAPI

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let rec fibonacci n=
    if n < 3 then
    1
    else
    fibonacci (n-1) + fibonacci (n-2)

  
  let http_fetch c resolver ctx uri uri_pop=
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    EdgeKernelAPI.get resolver const_ctx uri >>= fun(response,body)->
    Cohttp_lwt.Body.to_string body >>= fun body ->
    let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    let count = json |> member "get" |> to_string in
    let fib = string_of_int (fibonacci (int_of_string count)) in
    let uri_str = EdgeKernelAPI.generate_default_set "fib_result" [fib] in 
    EdgeKernelAPI.get resolver const_ctx uri_str >>= fun(_res, _body) ->
    EdgeKernelAPI.get resolver const_ctx uri_pop
    

  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    and uri = EdgeKernelAPI.generate_default_get "fib_number"
  and uri_pop = EdgeKernelAPI.generate_default_pop "eval_fib_trigger"
    in
    http_fetch c res ctx uri uri_pop

end
