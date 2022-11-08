let maybe_line () =
    try Some(read_line ())
    with End_of_file -> None

let all_lines () =
    let rec aux acc = match maybe_line () with
        | Some line -> aux (line :: acc)
        | None -> acc
    in List.rev (aux [])

let compute_score xs =
    let point_vals = List.map (fun x -> List.assoc x [(')', 1); (']', 2); ('}', 3); ('>', 4)]) xs
    in List.fold_left (fun score x -> 5*score + x) 0 point_vals

let complete_points line =
    let rec aux acc i =
        if i >= String.length line
        then compute_score acc
        else match line.[i] with
            | '(' -> aux (')' :: acc) (i + 1)
            | '[' -> aux (']' :: acc) (i + 1)
            | '{' -> aux ('}' :: acc) (i + 1)
            | '<' -> aux ('>' :: acc) (i + 1)
            | c -> if List.hd acc == c
                then aux (List.tl acc) (i + 1)
                else 0
    in aux [] 0

let answer =
    let sorted_scores =
        List.sort compare @@
        List.filter ((!=) 0) @@
        List.map complete_points (all_lines ())
    in List.nth sorted_scores (List.length sorted_scores / 2)

let _ = Printf.printf "%d\n" answer
