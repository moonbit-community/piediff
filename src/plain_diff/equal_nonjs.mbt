///|
fn[T : Eq] equal_for_diff(l : T, r : T) -> Bool {
  ignore(T::op_equal)
  physical_equal(l, r)
}
