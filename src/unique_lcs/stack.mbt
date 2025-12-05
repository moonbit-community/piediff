///|UUID(99d798fb-593a-44c1-84b7-a76fd9f08eb8)
#alias(Pile)
priv struct Stack[T] {
  mut top : T
  mut stack : @list.List[T]
}

///|UUID(730a3d81-87f0-4071-af02-fc2aa15724d3)
fn[T] Stack::push(self : Stack[T], t : T) -> Unit {
  self.stack = self.stack.add(self.top)
  self.top = t
}
