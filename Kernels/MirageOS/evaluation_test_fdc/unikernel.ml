open Lwt.Infix
open Printf
open EdgeKernelAPI

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let http_fetch c resolver ctx=
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    let uri =  EdgeKernelAPI.generate_default_incr "eval_test_fdc_count" in
    let uri_pop =  EdgeKernelAPI.generate_default_pop "eval_fdc_trigger" in
    EdgeKernelAPI.get resolver const_ctx uri >>= fun(_response, body) ->
    EdgeKernelAPI.get resolver const_ctx uri_pop


  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    in
    http_fetch c res ctx

end
