use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut prev = std::u64::MAX;
    let mut count = 0;
    for line in stdin.lock().lines() {
        let n = line.unwrap().parse::<u64>().unwrap();
        count += (n > prev) as u64;
        prev = n;
    }
    println!("{}", count);
}
