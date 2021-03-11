/// Represent an Instagram Photo Object
class Photo {
  // The source of the photo
  final String url;

  Photo(this.url);

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo && runtimeType == other.runtimeType && url == other.url;
}
