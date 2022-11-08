use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let lines : Vec<_> = stdin.lock().lines().map(|x| x.unwrap()).collect();
    let mut counts = vec![0; lines[0].len()];
    for line in lines.iter() {
        for i in 0..line.len() {
            counts[i] += (line.chars().nth(i).unwrap() == '1') as usize;
        }
    }
    let mut gamma = 0;
    let mut epsilon = 0;
    for count in counts.iter() {
        gamma = (gamma << 1) | ((*count > lines.len() / 2) as usize);
        epsilon = (epsilon << 1) | ((*count < lines.len() / 2) as usize);
    }
    println!("gamma: {}", gamma);
    println!("epsilon: {}", epsilon);
    println!("{}", gamma * epsilon);
}
