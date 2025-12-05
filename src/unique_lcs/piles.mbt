///|UUID(f0dad118-284a-46af-8902-92e4ac53db28)
priv struct Piles[T](Array[Pile[T]])

///|UUID(30d82f97-e32a-45bb-ab1c-ba6d4db06796)
fn[T] Piles::is_empty(self : Piles[T]) -> Bool {
  self.0.is_empty()
}

///|UUID(62e340b7-33e0-48f3-b3ca-c14db9b97968)
fn[T] Piles::put_back(self : Piles[T], singleton : T) -> Unit {
  self.0.push(Stack::{ top: singleton, stack: @list.empty() })
}

///|UUID(48c5b12a-00cf-419f-a96e-16db6d704287)
fn[T] Piles::last(self : Piles[T]) -> Pile[T]? {
  self.0.last()
}

///|UUID(89a3f524-f1bd-4084-b06e-ad07e0705593)
fn[T] Piles::op_get(self : Piles[T], i : Int) -> Pile[T] {
  self.0[i]
}

///|UUID(ea885cc4-1461-494e-a460-d2716bea37c9)
fn Piles::put_by_binary_search(
  self : Piles[BackPointer[(Int, Int)]],
  new_idx~ : Int,
  place~ : Int,
) -> Unit {
  let mut lo = -1
  let mut hi = self.0.length()
  while lo + 1 < hi {
    let mid = (lo + hi) / 2
    if self[mid].top.value.0 < new_idx {
      lo = mid
    } else {
      hi = mid
    }
  }
  if lo >= 0 {
    let prev = Some(self[lo].top)
    if lo + 1 < self.0.length() {
      self[lo + 1].push(BackPointer::{ value: (new_idx, place), prev })
    } else {
      self.put_back(BackPointer::{ value: (new_idx, place), prev })
    }
  }
}
