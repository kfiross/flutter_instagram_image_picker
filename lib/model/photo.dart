/// Represent an Instagram Photo Object
class Photo {
  // The width of the photo in pixels
  final int width;

  // The height of the photo in pixels
  final int height;

  // The source of the photo
  final String url;

  Photo(
      this.width,
      this.height,
      this.url,
      );

  Photo.fromJson(Map json)
      : width = json['width'],
        height = json['height'],
        url = json['url'];
  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Photo && runtimeType == other.runtimeType && url == other.url;
}
