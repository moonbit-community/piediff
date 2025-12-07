///|UUID(8fd4aa6e-af7f-46a1-af76-2c4347f745c7)
fn print_hunks(
  hunks : Array[(@edit.HunkHeader, Array[(@edit.EditTag, StringView)])],
) -> String {
  let buf = StringBuilder::new()
  for hunk in hunks {
    buf.write_string(hunk.0.to_string())
    buf.write_char('\n')
    for edit in hunk.1 {
      match edit.0 {
        Ins => buf.write_string(" + ")
        Del => buf.write_string(" - ")
        Eql => buf.write_string("   ")
      }
      buf.write_stringview(edit.1)
      buf.write_char('\n')
    }
  }
  buf.to_string()
}

///|UUID(02038cfd-7485-43e6-8d48-5a964ca0dc28)
test "insert/delete in middle" {
  let old =
    #|fn main() {
    #|  println("foo")
    #|}
  let new =
    #|fn main() {
    #|  println("bar")
    #|}
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,3 +1,3 @@
      #|   fn main() {
      #| -   println("foo")
      #| +   println("bar")
      #|   }
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,3 +1,3 @@
      #|   fn main() {
      #| -   println("foo")
      #| +   println("bar")
      #|   }
      #|
    ),
  )
}

///|UUID(4eaea414-23e0-431d-b79f-ce6e8acc39ce)
test "identical inputs" {
  let old =
    #|a
    #|b
    #|c
  let new = old
  inspect(print_hunks(line_diff(old~, new~)), content="")
  inspect(print_hunks(line_diff(old~, new~, patience=true)), content="")
}

///|UUID(6d6dc575-1a01-4015-9134-b82e466c8302)
test "insert at beginning" {
  let old =
    #|b
    #|c
  let new =
    #|a
    #|b
    #|c
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,2 +1,3 @@
      #| + a
      #|   b
      #|   c
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,2 +1,3 @@
      #| + a
      #|   b
      #|   c
      #|
    ),
  )
}

///|UUID(ce3c5b1e-2c7b-4d15-919f-86645bb74fd8)
test "insert at end" {
  let old =
    #|a
    #|b
  let new =
    #|a
    #|b
    #|c
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,2 +1,3 @@
      #|   a
      #|   b
      #| + c
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,2 +1,3 @@
      #|   a
      #|   b
      #| + c
      #|
    ),
  )
}

///|UUID(f14ae326-3eca-479b-9dd4-53e84a098d66)
test "delete at beginning" {
  let old =
    #|a
    #|b
    #|c
  let new =
    #|b
    #|c
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,3 +1,2 @@
      #| - a
      #|   b
      #|   c
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,3 +1,2 @@
      #| - a
      #|   b
      #|   c
      #|
    ),
  )
}

///|UUID(d7ed2179-a73f-4591-9466-58042fdd609f)
test "delete at end" {
  let old =
    #|a
    #|b
    #|c
  let new =
    #|a
    #|b
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,3 +1,2 @@
      #|   a
      #|   b
      #| - c
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,3 +1,2 @@
      #|   a
      #|   b
      #| - c
      #|
    ),
  )
}

///|UUID(ea9a7b07-297e-46e6-8655-f2cd73769a67)
test "blank lines and unicode" {
  let old =
    #|
    #|你
    #|
    #|好
  let new =
    #|
    #|你
    #|世
    #|界
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,4 +1,4 @@
      #|   
      #|   你
      #| - 
      #| - 好
      #| + 世
      #| + 界
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,4 +1,4 @@
      #|   
      #|   你
      #| - 
      #| - 好
      #| + 世
      #| + 界
      #|
    ),
  )
}

///|UUID(df2c5ee3-d6b4-4a56-9738-d5048b8c9e64)
test "no trailing newline behavior" {
  // Both inputs here end without a trailing newline implicitly; the lines() splitter
  // still treats them as single lines.
  let old =
    #|last
  let new =
    #|last
  inspect(print_hunks(line_diff(old~, new~)), content="")
  inspect(print_hunks(line_diff(old~, new~, patience=true)), content="")
}

///|UUID(f836bc1b-4596-413e-bb9b-9038213f6667)
test "multiple insert/delete" {
  let old =
    #|carrot
    #|tomato
    #|potato
    #|cabbage
  let new =
    #|apple
    #|banana
    #|tomato
    #|pineapple
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -1,4 +1,4 @@
      #| - carrot
      #| + apple
      #| + banana
      #|   tomato
      #| - potato
      #| - cabbage
      #| + pineapple
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -1,4 +1,4 @@
      #| - carrot
      #| + apple
      #| + banana
      #|   tomato
      #| - potato
      #| - cabbage
      #| + pineapple
      #|
    ),
  )
}

///|UUID(662d2ef8-951f-45fb-a808-479a2eb9b42b)
test "large text with small hunk" {
  let old =
    #|alert
    #|chop
    #|brave
    #|arise
    #|bring
    #|boy
    #|answer
    #|count
    #|begin
    #|casual
    #|dot
    #|bottom
  let new =
    #|alert
    #|chop
    #|brave
    #|arise
    #|bring
    #|joy
    #|answer
    #|count
    #|begin
    #|casual
    #|dot
    #|bottom
  inspect(
    print_hunks(line_diff(old~, new~)),
    content=(
      #|@@ -3,7 +3,7 @@
      #|   brave
      #|   arise
      #|   bring
      #| - boy
      #| + joy
      #|   answer
      #|   count
      #|   begin
      #|
    ),
  )
  inspect(
    print_hunks(line_diff(old~, new~, patience=true)),
    content=(
      #|@@ -3,7 +3,7 @@
      #|   brave
      #|   arise
      #|   bring
      #| - boy
      #| + joy
      #|   answer
      #|   count
      #|   begin
      #|
    ),
  )
}
