let maybe_line () =
    try Some(read_line ())
    with End_of_file -> None

let all_lines () =
    let rec aux acc = match maybe_line () with
        | Some line -> aux (line :: acc)
        | None -> acc
    in List.rev (aux [])

let string_to_digit_list str =
    let make_int x = int_of_char x - int_of_char '0'
    in let rec aux i acc = if i < 0 then acc else aux (i-1) (make_int str.[i] :: acc)
    in aux (String.length str - 1) []

let make_grid lines =
    let list_of_arr = List.map (fun x -> Array.of_list (string_to_digit_list x)) lines
    in Array.of_list list_of_arr

let valid_idx arr i j = i >= 0 && j >= 0 && i < Array.length arr && j < Array.length arr.(0)

let is_low_point arr i j =
    let di = [|1; -1; 0; 0|]
    in let dj = [|0; 0; 1; -1|]
    in let rec aux acc idx =
        if idx >= Array.length di
        then acc
        else
            if valid_idx arr (i+di.(idx)) (j+dj.(idx))
            then aux (arr.(i+di.(idx)).(j+dj.(idx)) :: acc) (idx + 1)
            else aux acc (idx + 1)
    in let neighbors = aux [] 0
    in arr.(i).(j) < List.fold_left (fun x y-> min x y) (List.hd neighbors) neighbors

let low_points arr =
    let rec aux i j acc =
        if i >= Array.length arr then acc
        else if j >= Array.length arr.(0) then aux (i+1) 0 acc
        else if is_low_point arr i j then aux i (j+1) ((i, j) :: acc)
        else aux i (j+1) acc
    in aux 0 0 []

let rec flood_helper arr i j count =
    if not (valid_idx arr i j) || arr.(i).(j) == -1 || arr.(i).(j) == 9 then count
    else
        let _ = arr.(i).(j) <- -1
        in 1 + count
             + flood_helper arr (i + 1) j 0
             + flood_helper arr (i - 1) j 0
             + flood_helper arr i (j + 1) 0
             + flood_helper arr i (j - 1) 0

let flood arr i j = flood_helper arr i j 0

let basin_sizes arr = List.map (fun (i, j) -> flood arr i j) (low_points arr)

let answer arr =
    let sorted_sizes = List.sort (fun x y -> -compare x y) (basin_sizes arr)
    in List.fold_left ( * ) 1 (List.map (List.nth sorted_sizes) [0;1;2])

let lines = all_lines ()
let grid = make_grid lines
let _ = Printf.printf "%d\n" (answer grid)
