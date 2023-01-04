import 'package:flutter/material.dart';
import '../model/photo.dart';

import '../debounce.dart';

/// Widget that shows list of photos in a grid
class PhotoGrid extends StatefulWidget {
  final List<Photo> _photos;
  final List<Photo>? _selectedPhotos;
  final Function(Photo) onPhotoTap;
  final Function onLoadMore;

  const PhotoGrid(
    this._photos,
    this._selectedPhotos, {
    Key? key,
    required this.onPhotoTap,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  PhotoGridState createState() {
    return PhotoGridState();
  }
}

class PhotoGridState extends State<PhotoGrid> {
  ScrollController? _controller;
  Debouncer? _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(
      const Duration(seconds: 1),
      (arg) => widget.onLoadMore(),
      null,
      true,
    );

    _controller = ScrollController();
    _controller!.addListener(() {
      double maxScroll = _controller!.position.maxScrollExtent;
      double currentScroll = _controller!.position.pixels;
      double delta = 100.0;
      if (maxScroll - currentScroll <= delta) {
        _debouncer?.debounce();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  bool _isSelected(Photo photo) {
    return widget._selectedPhotos?.contains(photo) ?? false;
  }

  Widget _buildPhotoCell(Photo photo) {
    return GestureDetector(
      onTap: () => widget.onPhotoTap(photo),
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeInImage(
              image: NetworkImage(photo.url),
              placeholder: const AssetImage('assets/loading.gif',
                  package: 'flutter_instagram_image_picker'),
              fit: BoxFit.cover,
            ),
          ),
          if (_isSelected(photo))
            Opacity(opacity: 0.5, child: Container(color: Colors.blue))
        ].toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        controller: _controller,
        children: List.generate(widget._photos.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.00),
            child: _buildPhotoCell(widget._photos[index]),
          );
        }),
      ),
    );
  }
}
