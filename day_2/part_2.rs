use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut hor = 0;
    let mut depth = 0;
    let mut aim = 0;
    for line in stdin.lock().lines() {
        let line = line.unwrap();
        let mut splitter = line.splitn(2, " ");
        let dir = splitter.next().unwrap();
        let amt = splitter.next().unwrap().parse::<u64>().unwrap();
        match dir {
            "forward" => {
                hor += amt;
                depth += aim * amt;
            },
            "up" => aim -= amt,
            "down" => aim += amt,
            _ => panic!("lol wat?")
        }
    }
    println!("{}", hor * depth);
}
