use std::io::{self, BufRead};
use std::collections::HashMap;

fn best_path(grid: &Vec<Vec<u32>>, r: usize, c: usize, cache: &mut HashMap<(usize, usize), u32>) -> u32 {
    let row_end = 5*(grid.len() - 1);
    let col_end = 5*(grid[0].len() - 1);

    let get_val = |i: usize, j: usize| -> u32 {
        let num_r = grid.len();
        let num_c = grid[0].len();
        let offset = ((i % num_r) + (j % num_c)) as u32;
        (grid[i % num_r][j % num_c] + offset) % 10
    };

    if r == row_end && c == col_end {
        return 0;
    }
    let mut path_cost = u32::MAX;
    if r < row_end {
        if !cache.contains_key(&(r+1, c)) {
            let val = best_path(grid, r+1, c, cache);
            cache.insert((r+1, c), val);
        }
        let sub_cost = cache[&(r+1, c)];
        path_cost = std::cmp::min(path_cost, get_val(r+1, c) + sub_cost);
    }
    if c < col_end {
        if !cache.contains_key(&(r, c+1)) {
            let val = best_path(grid, r, c+1, cache);
            cache.insert((r, c+1), val);
        }
        let sub_cost = cache[&(r, c+1)];
        path_cost = std::cmp::min(path_cost, get_val(r, c+1) + sub_cost);
    }
    path_cost
}

fn main() {
    let grid = io::stdin().lock().lines()
        .map(|l| l.unwrap().chars().map(|c| c.to_digit(10).unwrap()).collect::<Vec<u32>>())
        .collect::<Vec<Vec<u32>>>();
    
    let best = best_path(&grid, 0, 0, &mut HashMap::new());
    println!("{}", best);
}

