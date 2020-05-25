open Lwt.Infix
open Printf
open EdgeKernelAPI

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let rec clear queue c res ctx =
    let uri_get =  EdgeKernelAPI.generate_default_pop queue in
    EdgeKernelAPI.get res ctx uri_get >>= fun(_response, body) -> 
    Cohttp_lwt.Body.to_string body >>= fun(body) ->
    let value = EdgeKernelAPI.get_pop_option body in
    match value with
      Some p -> C.log c (sprintf "%s" p) >>= fun() ->
                clear queue c res ctx
    | None ->   let incr = EdgeKernelAPI.generate_default_set "consume_all_count" ["1"] in
                EdgeKernelAPI.get res ctx incr >>= fun(_response, _body) -> 
                C.log c (sprintf "Done")
              

  let start _time c res (ctx:CON.t) =
    clear "eval_test_consume_all_trigger" c res ctx

end
