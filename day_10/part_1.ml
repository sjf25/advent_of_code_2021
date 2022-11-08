let maybe_line () =
    try Some(read_line ())
    with End_of_file -> None

let all_lines () =
    let rec aux acc = match maybe_line () with
        | Some line -> aux (line :: acc)
        | None -> acc
    in List.rev (aux [])

let corrupt_points line =
    let rec aux acc i =
        if i >= String.length line
        then 0
        else match line.[i] with
            | '(' -> aux (')' :: acc) (i + 1)
            | '[' -> aux (']' :: acc) (i + 1)
            | '{' -> aux ('}' :: acc) (i + 1)
            | '<' -> aux ('>' :: acc) (i + 1)
            | c -> if List.hd acc == c
                then aux (List.tl acc) (i + 1)
                else List.assoc c [(')', 3); (']', 57); ('}', 1197); ('>', 25137)]
    in aux [] 0

let answer = List.fold_left (+) 0 (List.map corrupt_points (all_lines ()))
let _ = Printf.printf "%d\n" answer
