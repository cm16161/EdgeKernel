open Lwt.Infix
open Printf

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let http_fetch c resolver ctx uri_pop uri_incr=
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    Cohttp_mirage.Client.get ~ctx uri_pop >>= fun (null_res, null_bod) ->
    Cohttp_mirage.Client.get ~ctx uri_incr

  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    and uri_pop = Uri.of_string "http://192.168.0.37:7379/RPOP/eval_dhs_increment_trigger"
    and uri_incr = Uri.of_string "http://192.168.0.37:7379/INCR/eval_test_dhs_day_count"
    in
    http_fetch c res ctx uri_pop uri_incr

end
