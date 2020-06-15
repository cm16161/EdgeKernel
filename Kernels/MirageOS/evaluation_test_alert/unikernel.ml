open Lwt.Infix
open Printf
open EdgeKernelAPI

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let output setting uri_set=
    if setting then
      Uri.of_string (String.concat uri_set ["";"yes"])
    else
      Uri.of_string (String.concat uri_set ["";"no"])

  let threshold value thresh =
    if float_of_string value > thresh then
      true
    else
      false
  
  let http_fetch c resolver ctx= 
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    let uri_get =  EdgeKernelAPI.generate_default_pop "eval_alert_input" in
    EdgeKernelAPI.get resolver const_ctx uri_get >>= fun(_response, body) ->
    Cohttp_lwt.Body.to_string body >>= fun body ->
    let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    let value = json |> member "rpop" |> to_string in
    if (threshold value 50.0) then
      let uri_set = EdgeKernelAPI.generate_default_set "eval_test_alert_output" ["yes"] in
      EdgeKernelAPI.get resolver const_ctx uri_set 
    else
      let uri_set = EdgeKernelAPI.generate_default_set "eval_test_alert_output" ["no"] in
      EdgeKernelAPI.get resolver const_ctx uri_set


  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    in
    http_fetch c res ctx 

end
