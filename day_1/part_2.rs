use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let nums: Vec<u64> = stdin.lock()
        .lines()
        .map(|line| line.unwrap().parse::<u64>().unwrap())
        .collect();
    let mut prev = std::u64::MAX;
    let mut count = 0;
    for i in 2..nums.len() {
        let current = nums[i] + nums[i-1] + nums[i-2];
        count += (current > prev) as u64;
        prev = current;
    }
    //println!("{:?}", nums);
    println!("{}", count);
}
