pub fn double(value: i32) -> i32 {
    value.checked_mul(2).expect("doubling overflow")
}
