

List<DateTime> rangeDate(DateTime start, Duration diff, int count) {
  return List<DateTime>.generate(count, (index) {
    return start.add(diff * index);
  });
}
