open Lwt.Infix
open Printf

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

  
  let http_fetch c resolver ctx uri uri_str uri_pop=
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    (* Cohttp_mirage.Client.get ~ctx uri_incr >>= fun (null_resp, null_body) -> *)
    Cohttp_mirage.Client.get ~ctx uri_pop >>= fun (null_res, null_bod) ->
    Cohttp_mirage.Client.get ~ctx uri >>= fun (response, body) ->
    Cohttp_lwt.Body.to_string body >>= fun body ->
    let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    let count = json |> member "GET" |> to_string in
    let fib = string_of_int (fibonacci (int_of_string count)) in
    C.log c (sprintf "%s" (fib)) >>= fun () ->
    let set = String.concat uri_str [""; fib] in
    let uri_str = Uri.of_string (set) in
    Cohttp_mirage.Client.get ~ctx uri_str
    

  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    and uri = Uri.of_string "http://192.168.0.37:7379/GET/fib_number"
    and uri_pop = Uri.of_string "http://192.168.0.37:7379/RPOP/eval_fib_trigger"
    and uri_str = "http://192.168.0.37:7379/SET/fib_result/"
    in
    http_fetch c res ctx uri uri_str uri_pop

end
