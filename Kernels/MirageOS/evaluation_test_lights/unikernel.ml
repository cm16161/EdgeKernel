open Lwt.Infix
open Printf
open EdgeKernelAPI

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let output setting queue=
    if bool_of_string setting then
      EdgeKernelAPI.generate_default_set queue ["on"]
    else
      EdgeKernelAPI.generate_default_set queue ["off"]
  
  let http_fetch c resolver ctx uri_pop = 
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    EdgeKernelAPI.get resolver const_ctx uri_pop >>= fun (response, body) -> 
    Cohttp_lwt.Body.to_string body >>= fun body ->
    let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    let setting = json |> member "rpop" |> to_string in
    let uri_set = output setting "eval_test_lights_output"  in
    EdgeKernelAPI.get resolver const_ctx uri_set
    

  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    and uri_pop = EdgeKernelAPI.generate_default_pop "eval_lights_input"
    in
    http_fetch c res ctx uri_pop

end
