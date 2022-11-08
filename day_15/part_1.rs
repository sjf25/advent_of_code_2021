use std::io::{self, BufRead};
use std::collections::HashMap;

fn best_path(grid: &Vec<Vec<u32>>, r: usize, c: usize, cache: &mut HashMap<(usize, usize), u32>) -> u32 {
    if r == grid.len() - 1 && c == grid[0].len() - 1 {
        return 0;
    }
    let mut path_cost = u32::MAX;
    if r < grid.len() - 1 {
        if !cache.contains_key(&(r+1, c)) {
            let val = best_path(grid, r+1, c, cache);
            cache.insert((r+1, c), val);
        }
        let sub_cost = cache[&(r+1, c)];
        path_cost = std::cmp::min(path_cost, grid[r+1][c] + sub_cost);
    }
    if c < grid[0].len() - 1 {
        if !cache.contains_key(&(r, c+1)) {
            let val = best_path(grid, r, c+1, cache);
            cache.insert((r, c+1), val);
        }
        let sub_cost = cache[&(r, c+1)];
        path_cost = std::cmp::min(path_cost, grid[r][c+1] + sub_cost);
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
