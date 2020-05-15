open Lwt.Infix

let combine base extension =
  String.concat base [""; extension]

let default_base =
  combine "http://" 
  (combine "192.168.0.37"
    (combine ":"
       (combine (string_of_int 7379)
          ("/")
       )
    )
  )


let rec all_args args =
  match args with
    [] -> ""
  | x::xs -> combine "/" (combine x (all_args xs))

let generate_command ip port command key args =
  combine "http://" 
  (combine ip
    (combine ":"
       (combine (string_of_int port)
          (combine "/"
             (combine command
                (combine "/"
                   (combine key
                      (all_args args)
                   )
                )
             )
          )
       )
    )
  )


let get_val_option body command =
  let json = Yojson.Basic.from_string body in
    let open Yojson.Basic.Util in
    json |> member command |> to_string_option

let get_pop_option body =
  get_val_option body "rpop"

let get_push_option body =
  get_val_option body "lpush"

let get_incr_option body =
  get_val_option body "incr"

let get_get_option body =
  get_val_option body "get"

let get_set_option body =
  get_val_option body "set"


let edgekernel_communication res ctx command =
  let ctx = Cohttp_mirage.Client.ctx res ctx in
  Cohttp_mirage.Client.get ~ctx (Uri.of_string command)




let generate_default_command command queue args =
  combine default_base
    (combine command
       (combine "/"
          (combine queue
             (all_args args)
          )
       )
    )

  
let generate_default_pop queue  =
  generate_default_command "rpop" queue []

let generate_default_push queue args =
  generate_default_command "lpush" queue args

let generate_default_incr queue =
  generate_default_command "incr" queue []

let generate_default_get queue =
  generate_default_command "get" queue []

let generate_default_set queue args =
  generate_default_command "set" queue args

