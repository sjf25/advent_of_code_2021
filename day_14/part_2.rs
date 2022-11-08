use std::io::{self, BufRead};
use std::collections::{HashMap};
use std::convert::TryFrom;

fn trans_step(polymer: &HashMap<(u8, u8), u64>, trans_table: &HashMap<(u8, u8), u8>) -> HashMap<(u8, u8), u64> {
    let mut new_polymer = HashMap::new();
    for ((p1, p2), count) in polymer.iter() {
        let new_elem = trans_table[&(*p1, *p2)];
        *new_polymer.entry((*p1, new_elem)).or_insert(0) += count;
        *new_polymer.entry((new_elem, *p2)).or_insert(0) += count;
    }
    new_polymer
}

fn main() {
    let mut trans_table = HashMap::new();

    let stdin = io::stdin();

    let mut starting = String::new();
    stdin.lock().read_line(&mut starting).unwrap();
    let starting = starting.trim()
        .as_bytes()
        .iter()
        .cloned()
        .collect::<Vec<u8>>();

    let mut polymer_pairs: HashMap<(u8, u8), u64> = std::iter::zip(starting.iter(), starting.iter().skip(1))
        .map(|(a, b)| ((*a, *b), 1))
        .into_iter()
        .collect();

    for line in stdin.lock().lines().skip(1) {
        let line = line.unwrap();
        let tokens = line
            .split_ascii_whitespace()
            .map(|x| x.as_bytes())
            .collect::<Vec<&[u8]>>();

        let [pair, _, elem] = <[&[u8]; 3]>::try_from(tokens).ok().unwrap();
        trans_table.insert((pair[0], pair[1]), elem[0]);
    }

    for _i in 0..40 {
        polymer_pairs = trans_step(&polymer_pairs, &trans_table);
    }

    let mut counts = HashMap::<u8, u64>::new();
    for ((p1, p2), c) in polymer_pairs.iter() {
        *counts.entry(*p1).or_insert(0) += c;
        *counts.entry(*p2).or_insert(0) += c;
    }
    *counts.entry(starting[0]).or_insert(0) += 1;
    *counts.entry(*starting.last().unwrap()).or_insert(0) += 1;

    let max_count = counts.values().max().unwrap() / 2;
    let min_count = counts.values().min().unwrap() / 2;
    println!("{}", max_count - min_count);
}
