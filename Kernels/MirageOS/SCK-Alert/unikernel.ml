open Cohttp
open Lwt.Infix
open Printf

let red fmt    = sprintf ("\027[31m"^^fmt^^"\027[m")
let green fmt  = sprintf ("\027[32m"^^fmt^^"\027[m")
let yellow fmt = sprintf ("\027[33m"^^fmt^^"\027[m")
let blue fmt   = sprintf ("\027[36m"^^fmt^^"\027[m")

module Client (T: Mirage_time.S) (C: Mirage_console.S) (RES: Resolver_lwt.S) (CON: Conduit_mirage.S) = struct

  let output setting uri_set ctx c=
    if setting then
      let uri_set =  Uri.of_string (String.concat uri_set ["";"text=ALERT&pretty=1"]) in
      Cohttp_mirage.Client.get ~ctx uri_set >>= fun (res, body) ->
      Lwt.return_unit
    else
      let uri_set = String.concat uri_set ["";"text=OK&pretty=1"] in
      Lwt.return_unit

  let threshold value thresh =
    if float_of_string value > thresh then
      true
    else
      false
  
  let http_fetch c resolver ctx uri_pop uri_set=
    let const_ctx = ctx in
    let ctx = Cohttp_mirage.Client.ctx resolver ctx in
    Cohttp_mirage.Client.get ~ctx uri_pop >>= fun (response, body) ->
    Cohttp_lwt.Body.to_string body >>= fun body ->
    let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    let value = json |> member "RPOP" |> to_string in
    let thresh = threshold value 50.0 in
    if thresh then
      let uri_set = Uri.of_string (String.concat uri_set ["";(String.concat (String.concat "text=ALERT-" ["";value]) ["";"&pretty=1"])]) in
      Cohttp_mirage.Client.get ~ctx uri_set >>= fun (res, body) ->
      Lwt.return_unit
    else
      Lwt.return_unit
    (* output (threshold value 50.0) uri_set ctx c *)
    
    


  let start _time c res (ctx:CON.t) =
    let ns = Key_gen.resolver ()  
  and uri_get = Uri.of_string "http://192.168.0.37:7379/RPOP/sensor_data"
  and uri_message = "https://slack.com/api/chat.postMessage?token=ENTER-SLACK-TOKEN&"
    in
    http_fetch c res ctx uri_get uri_message

end
