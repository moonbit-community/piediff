///|
test {
  let old = [1, 2, 3, 4, 5]
  let new = [3, 4, 5, 6, 7]
  @json.json_inspect(find_unique(old~, new~), content=[[2, 0], [3, 1], [4, 2]])
}

///|
test {
  let old : Array[Int32] = []
  let new = []
  @json.json_inspect(find_unique(old~, new~), content=[])
}

///|
test {
  let old = [1, 2, 3]
  let new : Array[Int32] = [3, 2, 1]
  @json.json_inspect(find_unique(old~, new~), content=[[0, 2], [1, 1], [2, 0]])
}
