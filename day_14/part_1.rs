#![feature(linked_list_cursors)]

use std::io::{self, BufRead};
use std::collections::{HashMap, LinkedList};
use std::convert::TryFrom;

fn trans_step(polymer: &mut LinkedList<u8>, trans_table: &HashMap<(u8, u8), u8>) {
    let mut cur = polymer.cursor_front_mut();
    cur.move_next();

    while cur.index().is_some(){
        let to_insert = trans_table[&(*cur.peek_prev().unwrap(), *cur.current().unwrap())];
        cur.insert_before(to_insert);
        cur.move_next();
    }
}

fn main() {
    let mut trans_table = HashMap::new();

    let stdin = io::stdin();

    let mut starting = String::new();
    stdin.lock().read_line(&mut starting).unwrap();
    let mut polymer = starting.trim()
        .as_bytes()
        .iter()
        .cloned()
        .collect::<LinkedList<u8>>();
    
    for line in stdin.lock().lines().skip(1) {
        let line = line.unwrap();
        let tokens = line
            .split_ascii_whitespace()
            .map(|x| x.as_bytes())
            .collect::<Vec<&[u8]>>();

        let [pair, _, elem] = <[&[u8]; 3]>::try_from(tokens).ok().unwrap();
        trans_table.insert((pair[0], pair[1]), elem[0]);
    }

    for _i in 0..10 {
        trans_step(&mut polymer, &trans_table);
    }

    let mut counts = HashMap::new();
    for elem in polymer {
        let count = counts.entry(elem).or_insert(0);
        *count += 1;
    }

    let max_count = counts.values().max().unwrap();
    let min_count = counts.values().min().unwrap();

    println!("{}", max_count - min_count);
}
