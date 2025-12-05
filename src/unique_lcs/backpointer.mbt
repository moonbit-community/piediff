///|UUID(aca58ba8-4514-42a6-8fef-a515c15159cb)
priv struct BackPointer[T] {
  value : T
  prev : BackPointer[T]?
}

///|UUID(d66d45fd-ed9c-4ca6-a94e-1b5f28f1d87e)
fn[T] BackPointer::to_array(self : BackPointer[T]) -> Array[T] {
  match self.prev {
    None => [self.value]
    Some(prev) => {
      let prev = prev.to_array()
      prev.push(self.value)
      return prev
    }
  }
}
