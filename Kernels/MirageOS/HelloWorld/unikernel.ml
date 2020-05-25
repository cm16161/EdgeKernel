open Lwt.Infix
open Printf
open EdgeKernelAPI

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let hello queue c res ctx =
    let uri_get =  EdgeKernelAPI.generate_default_pop queue in
    EdgeKernelAPI.get res ctx uri_get >>= fun(_response, body) -> 
    Cohttp_lwt.Body.to_string body >>= fun(body) ->
    let value = EdgeKernelAPI.get_pop_option body in
    match value with
      Some p -> C.log c (sprintf "%s" p) >>= fun() ->
                let world = EdgeKernelAPI.generate_default_set "hello" ["world"] in
                EdgeKernelAPI.get res ctx world >>= fun( _res,_body) ->
                C.log c (sprintf "")
    | None ->   C.log c (sprintf "")
              

  let start _time c res (ctx:CON.t) =
    hello "hello_world_trigger" c res ctx

end
