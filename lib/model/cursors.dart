class Cursors {
  final String before;
  final String after;

  Cursors(
    this.before,
    this.after,
  );

  Cursors.fromJson(Map json)
      : before = json['before'],
        after = json['after'];
}
