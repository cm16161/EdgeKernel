open Lwt.Infix
open EdgeKernelAPI
open Printf

let log = Logs.Src.create "speaking clock" ~doc:"At the third stroke..."
module Log = (val Logs.src_log log : Logs.LOG)

module Main (Time: Mirage_time.S) (PClock: Mirage_clock.PCLOCK) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let get_time (a,b) =
    let t = Int64.div b (Int64.of_float 1000.0) in
    let d =  Int64.mul (Int64.of_int a) (Int64.of_float 86.400e12) in
    Int64.add d t 
  
  let difference (a,b) c =
    let time  = get_time(a,b) in
    Int64.to_string (Int64.div (Int64.sub  time (Int64.of_string c) ) (Int64.of_float 1.0e6))

  
  let start _time pclock c res (ctx:CON.t) =
    let now = PClock.now_d_ps pclock in 
    let uri_get =  EdgeKernelAPI.generate_default_pop "time-test" in
    EdgeKernelAPI.get res ctx uri_get >>= fun(_response, body) -> 
    Cohttp_lwt.Body.to_string body >>= fun(body) ->
    let value = EdgeKernelAPI.get_pop_option body in
    match value with
      Some p -> C.log c (sprintf "#! %s " (difference now p))
    | None ->   C.log c (sprintf "Done")

end
