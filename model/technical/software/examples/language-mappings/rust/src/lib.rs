pub mod arithmetic;

#[derive(Default)]
pub struct Counter {
    value: i32,
}

impl Counter {
    pub fn read(&self) -> i32 {
        self.value
    }

    pub fn add(&mut self, amount: i32) {
        self.value = self.value.checked_add(amount).expect("counter overflow");
    }
}

#[cfg(test)]
mod tests {
    use super::Counter;

    #[test]
    fn independent_instances_and_read_without_mutation() {
        let mut first = Counter::default();
        let second = Counter::default();
        first.add(3);
        assert_eq!(first.read(), 3);
        assert_eq!(first.read(), 3);
        assert_eq!(second.read(), 0);
    }

    #[test]
    fn free_function() {
        assert_eq!(super::arithmetic::double(7), 14);
    }
}
