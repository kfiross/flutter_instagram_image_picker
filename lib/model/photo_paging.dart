import 'photo.dart';

class PhotoPaging {
  List<Photo>? data;
  bool? hasNext;

  //Pagination pagination;

  PhotoPaging.fromJson(Map json) {
    data = <Photo>[];
    var photosUrls = json['data'] ?? [];
    hasNext = json['hasNext'] ?? false;

    for (String url in photosUrls) {
      data!.add(Photo(url));
    }

    // if there are more than 20 photos
    //pagination = Pagination.fromJson(json['pagination']);
  }
//      : data = (json['data'][0]['images'] as Map)
//      .map((key, value) => Photo.fromJson(value))
//      .values.toList(),
//pagination = Pagination.fromJson(json['paging']);
}
