import 'pagination.dart';
import 'photo.dart';

class PhotoPaging {
  List<Photo> data;
  Pagination pagination;

  PhotoPaging.fromJson(Map json){
    data = <Photo>[];
    var albums = json['data'] as List;
    albums.forEach((album){

      try {
        (album['carousel_media'] as List).forEach((value) {
          try {
            Photo newPhoto = Photo.fromJson(value['images']['low_resolution']);
            data.add(newPhoto);
          }
          catch (e) {}
        });
      }
      catch (e) {
        // single photos
        try {
          Photo newPhoto = Photo.fromJson(album['images']['low_resolution']);
          data.add(newPhoto);
        }
        catch (e) {}

      }
    });



    // if there are more than 20 photos
    pagination = Pagination.fromJson(json['pagination']);
  }
//      : data = (json['data'][0]['images'] as Map)
//      .map((key, value) => Photo.fromJson(value))
//      .values.toList(),
        //pagination = Pagination.fromJson(json['paging']);
}
