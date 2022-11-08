type line_seg = {x1: int; y1: int; x2: int; y2: int}

let maybe_line () =
    try Some(read_line ())
    with End_of_file -> None

let all_lines () =
    let rec aux acc = match maybe_line () with
        | Some line -> aux (line :: acc)
        | None -> acc
    in List.rev (aux [])

let input_to_seg in_str = Scanf.sscanf in_str "%d,%d -> %d,%d" (fun x1 y1 x2 y2 -> {x1 = x1; y1 = y1; x2 = x2; y2 = y2})

let increment_count table coord =
    if Hashtbl.mem table coord
    then Hashtbl.replace table coord (1 + (Hashtbl.find table coord))
    else Hashtbl.add table coord 1

let list_range n =
    let rec aux acc i = if i == n then acc else aux (i :: acc) (i + 1)
    in List.rev (aux [] 0)

let my_list_init n f = List.map f (list_range n)

let add_points table seg =
    let min_y = min seg.y1 seg.y2 in
    let min_x = min seg.x1 seg.x2 in
    let n = 1 + max (abs (seg.x1 - seg.x2)) (abs (seg.y1 - seg.y2)) in
    let init_fun =
        if seg.x1 == seg.x2
        then (fun i -> (seg.x1, min_y + i))
        else (fun i -> (min_x + i, seg.y1)) in
    List.iter (fun coord -> increment_count table coord) (my_list_init n init_fun)

let point_counts segments =
    let counts = Hashtbl.create 100
    in let rec aux = function
        | seg::rest ->
                if seg.x1 == seg.x2 || seg.y1 == seg.y2
                then (add_points counts seg; aux rest)
                else aux rest
        | [] -> ()
    in aux segments; counts

let num_overlap counts =
    Hashtbl.fold (fun _ count x -> x + if count > 1 then 1 else 0) counts 0

let segments = List.map input_to_seg (all_lines ())

let _ = Printf.printf "overlaps: %d\n" (num_overlap (point_counts segments))
