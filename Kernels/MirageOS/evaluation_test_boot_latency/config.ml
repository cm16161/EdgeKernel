open Mirage

let main =
  let packages = [ package "cohttp-mirage"; package "duration" ; package "yojson"; package "unix"] in
  foreign
    ~packages
    "Unikernel.Main" @@ time @-> pclock @-> console @-> resolver @-> conduit @-> job

let () =
  let stack = generic_stackv4 default_network in
  let res_dns = resolver_dns stack in
  let conduit = conduit_direct stack in
  let job =  [ main $ default_time $ default_posix_clock $default_console $ res_dns $ conduit ] in
  register "speaking_clock" job
