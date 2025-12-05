///|UUID(90bdb95d-2767-40ed-8a29-0945c8df45c3)
pub struct Range(Int, Int) // line number, length

///|UUID(f4f7782a-2123-4b91-b8bb-024370560d24)
pub impl Show for Range with output(self, logger) {
  let mut beginning = self.0 + 1 // from array index to line number
  let len = self.1 - self.0
  if len == 1 {
    logger.write_string(beginning.to_string())
  } else {
    if len == 0 {
      // empty ranges begin at line just before the range
      beginning -= 1
    }
    logger.write_string(beginning.to_string())
    logger.write_char(',')
    logger.write_string(len.to_string())
  }
}

///|UUID(e1d5cc88-dfff-41fd-b8e4-d7a150a19e0e)
pub struct HunkHeader(Range, Range)

///|UUID(5f23dec9-5a9b-4a45-be11-43302a320700)
/// Creates a hunk header from a (non empty) array of edit
pub fn HunkHeader::new(edits : Array[Edit]) -> Self {
  let first = edits[0]
  let last = edits[edits.length() - 1]
  let old_start = first.old_range().0
  let new_start = first.new_range().0
  let old_end = last.old_range().1
  let new_end = last.new_range().1
  HunkHeader(Range(old_start, old_end), Range(new_start, new_end))
}

///|UUID(de1a4ca0-44eb-478b-af76-51d6472bacb6)
pub impl Show for HunkHeader with output(self, logger) {
  logger.write_string("@@ -\{self.0} +\{self.1} @@")
}
