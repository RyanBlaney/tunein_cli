open Lwt.Infix
open Cohttp_lwt_unix


let urlencode s =
  let buffer = Buffer.create (String.length s * 3) in
  String.iter (function
    | 'A'..'Z' | 'a'..'z' | '0'..'9' | '-' | '_' | '.' | '~' as c ->
        Buffer.add_char buffer c
    | c ->
        Buffer.add_string buffer (Printf.sprintf "%%%02X" (Char.code c))
  ) s;
  Buffer.contents buffer

let fetch_url url =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Response body: %s\n%!" body;
  (resp, body)

let parse_xml xml_string =
  let input = Xmlm.make_input (`String (0, xml_string)) in
  let rec parse_nodes acc =
    try
      match Xmlm.input input with
      | `El_start ((ns, name), attrs) ->
        let formatted_attrs = List.map (fun ((_, n), v) -> (n, v)) attrs in
        parse_nodes (`El_start ((ns, name), formatted_attrs) :: acc)
      | `El_end -> parse_nodes (`El_end :: acc) 
      | `Data data -> parse_nodes (`Data data :: acc) 
      | `Dtd _ -> parse_nodes acc 
    with
    | End_of_file -> List.rev acc
    | Xmlm.Error ((line, col), err) ->
      Printf.eprintf "XML error at line %d, column %d: %s\n%!" line col (Xmlm.error_message err);
      List.rev acc 
  in
  parse_nodes []

let extract_url attrs =
  List.fold_left (fun acc (name, value) ->
    if name = "URL" then Some value else acc
  ) None attrs

let find_station nodes =
  let rec aux = function
    | [] -> None
    | `El_start ((_, "outline"), attrs) :: tl when List.exists (fun (n, v) -> n = "type" && v = "audio") attrs &&
                                                    List.exists (fun (n, v) -> n = "item" && v = "station") attrs ->
        (match extract_url attrs with
         | Some url -> Some url
         | None -> aux tl)
    | _ :: tl -> aux tl
  in
  aux nodes

let play_url url =
  let players = ["vlc"; "mplayer"; "mpg123"; "totem"; "audacious"; "xdg-open"] in
  let rec try_player = function
    | [] -> Lwt_io.printf "No suitable media player found.\n"
    | player :: rest ->
        if Sys.command (Printf.sprintf "which %s > /dev/null" player) = 0 then
          let cmd = Printf.sprintf "%s \"%s\" %s" player url "--qt-start-minimized" in
          Lwt_process.exec (Lwt_process.shell cmd) >>= fun _ ->
          Lwt.return_unit
        else
          try_player rest
  in
  try_player players

let search_station pattern =
  let api_target = Printf.sprintf "http://opml.radiotime.com/Search.ashx?query=%s" (urlencode pattern) in
  fetch_url api_target >>= fun (_, body) ->
  let nodes = parse_xml body in
  match find_station nodes with
  | None -> Lwt_io.printf "No radio stations found.\n" >>= fun () -> Lwt.return_none
  | Some url -> Lwt.return_some url

let main () =
  if Array.length Sys.argv < 2 then
    Lwt_io.printf "Usage: %s PATTERN\n" Sys.argv.(0)
  else
    let pattern = String.concat " " (Array.to_list (Array.sub Sys.argv 1 (Array.length Sys.argv - 1))) in
    search_station pattern >>= function
    | Some url ->
        Lwt_io.printf "Playing URL: %s\n%!" url >>= fun () ->
        play_url url
    | None -> Lwt.return_unit

let () =
  Lwt_main.run (main ())


