use std::io::{self, BufRead};
use std::mem;

fn bin_string_to_int(bin_string: String) -> u64 {
    let mut n = 0;
    for c in bin_string.chars() {
        n = (n << 1) | (c == '1') as u64;
    }
    n
}

fn rating(nums: &Vec<u64>, toggle: bool, bitstr_len: usize) -> u64 {
    let mut ones = Vec::new();
    let mut zeros = Vec::new();
    let mut working_list = nums.clone();
    for i in (0..bitstr_len).rev() {
        for n in working_list.iter() {
            if n & (1 << i)  != 0 {
                ones.push(*n);
            }
            else {
                zeros.push(*n);
            }
        }
        let to_swap_with = if toggle ^ (ones.len() >= zeros.len()) { &mut ones }
            else { &mut zeros };
        mem::swap(&mut working_list, to_swap_with);
        ones.clear();
        zeros.clear();
        if working_list.len() == 1 {
            break;
        }
    }
    assert!(working_list.len() == 1);
    working_list[0]
}


fn main() {
    let stdin = io::stdin();
    let lines: Vec<_> = stdin.lock().lines().map(|x| x.unwrap()).collect();
    let bitstr_len = lines[0].len();
    let nums: Vec<u64> = lines.iter()
        .map(|x| bin_string_to_int(x.to_string()))
        .collect();

    let oxygen = rating(&nums, false, bitstr_len);
    let co2 = rating(&nums, true, bitstr_len);
    println!("{}, {}", oxygen, co2);
    println!("{}", oxygen * co2);
}
