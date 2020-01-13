
import 'cursors.dart';

class Pagination {
  //final Cursors cursor;
  final String next;

  Pagination(
    //this.cursor,
    this.next,
  );

  Pagination.fromJson(Map json)
      : //cursor = Cursors.fromJson(json['cursors']),
        next = json['next_url'];
}
