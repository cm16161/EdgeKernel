open Lwt.Infix
open Printf

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let output value uri_set=
    Uri.of_string (String.concat uri_set [""; (string_of_float value)])
  
  let new_average current day value =
    (current *. day +. value) /. (day +. 1.0)
  
  let http_fetch c resolver ctx uri_get_ave uri_get_val uri_get_day uri_set uri_update_day_count= 
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    Cohttp_mirage.Client.get ~ctx uri_get_ave >>= fun (response, average_body) ->
    Cohttp_lwt.Body.to_string average_body >>= fun average_body ->
    let json = Yojson.Basic.from_string average_body in
    let open Yojson.Basic.Util in
    let current_average = json |> member "GET" |> to_string in
    Cohttp_mirage.Client.get ~ctx uri_get_val >>= fun (response, value_body) ->
    Cohttp_lwt.Body.to_string value_body >>= fun value_body ->
    let json = Yojson.Basic.from_string value_body in
    let open Yojson.Basic.Util in
    let new_value = json |> member "RPOP" |> to_string in
    Cohttp_mirage.Client.get ~ctx uri_get_day >>= fun (response, day_body) ->
    Cohttp_lwt.Body.to_string day_body >>= fun day_body ->
    let json = Yojson.Basic.from_string day_body in
    let open Yojson.Basic.Util in
    let current_day = json |> member "GET" |> to_string in
    let new_value = new_average (float_of_string current_average) (float_of_string current_day) (float_of_string new_value) in
    let uri_set = output new_value uri_set in
    Cohttp_mirage.Client.get ~ctx uri_set >>= fun (response, day_body) ->
    Cohttp_mirage.Client.get ~ctx uri_update_day_count
  
    
  
    
    

  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()
    and uri_get_ave = Uri.of_string "http://192.168.0.37:7379/GET/eval_test_dhs_current_average"
    and uri_get_val = Uri.of_string "http://192.168.0.37:7379/RPOP/eval_test_dhs_new_value"
    and uri_get_day = Uri.of_string "http://192.168.0.37:7379/GET/eval_test_dhs_day_count"
    and uri_set = "http://192.168.0.37:7379/SET/eval_test_dhs_current_average/"
    and uri_update_day_count = Uri.of_string "http://192.168.0.37:7379/LPUSH/eval_dhs_increment_trigger/1"
    in
    http_fetch c res ctx uri_get_ave uri_get_val uri_get_day uri_set uri_update_day_count

end
