//import 'package:MatchIt/external_libs/facebook_image_picker/lib/model/album.dart';
//import 'package:flutter/material.dart';
//
//import '../debounce.dart';
//
//
//class AlbumGrid extends StatefulWidget {
//  final List<Album> _albums;
//  final Function(Album) onAlbumSelected;
//  final Function onLoadMore;
//
//  AlbumGrid(
//    this._albums, {
//    @required this.onAlbumSelected,
//    @required this.onLoadMore,
//  });
//
//  @override
//  AlbumGridState createState() {
//    return new AlbumGridState();
//  }
//}
//
//class AlbumGridState extends State<AlbumGrid> {
//  ScrollController _controller;
//  Debouncer _debouncer;
//
//  @override
//  void initState() {
//    super.initState();
//    _debouncer = Debouncer(
//      Duration(seconds: 1),
//      (arg) => widget.onLoadMore(),
//      null,
//      true,
//    );
//
//    _controller = ScrollController();
//    _controller.addListener(() {
//      double maxScroll = _controller.position.maxScrollExtent;
//      double currentScroll = _controller.position.pixels;
//      double delta = 100.0;
//      if (maxScroll - currentScroll <= delta) {
//        _debouncer.debounce();
//      }
//    });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _controller.dispose();
//  }
//
//  Widget _buildAlbumCell(Album album) {
//    return GestureDetector(
//      onTap: () {
//        widget.onAlbumSelected(album);
//      },
//      child: Stack(
//        children: <Widget>[
//          Align(
//            alignment: Alignment.topCenter,
//            child: ClipRRect(
//              borderRadius: new BorderRadius.circular(8.0),
//              child: FadeInImage(
//                image: NetworkImage(album.coverPhoto),
//                placeholder: AssetImage(
//                  'assets/loading.gif',
//                  package: 'flutter_facebook_image_picker',
//                ),
//                fit: BoxFit.cover,
//                height: 190.00,
//              ),
//            ),
//          ),
//          Positioned(
//            top: 5.00,
//            right: 10.00,
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.grey.withOpacity(0.5),
//                shape: BoxShape.rectangle,
//              ),
//              child: Row(
//                children: <Widget>[
//                  Icon(
//                    Icons.photo_library,
//                    color: Colors.white,
//                  ),
//                  Text(
//                    album.count.toString(),
//                    style: TextStyle(
//                      color: Colors.white,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Align(
//            alignment: Alignment.bottomCenter,
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.grey.withOpacity(0.8),
//                shape: BoxShape.rectangle,
//              ),
//              child: Text(
//                album.name,
//                textAlign: TextAlign.center,
//                style: TextStyle(color: Colors.white),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    // 24 is for notification bar on Android
//    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
//    final double itemWidth = size.width / 2;
//
//    return GridView.count(
//      crossAxisCount: 2,
//      childAspectRatio: (itemWidth / itemHeight),
//      shrinkWrap: true,
//      controller: _controller,
//      children: List.generate(widget._albums.length, (index) {
//        return Padding(
//          padding: EdgeInsets.all(8.00),
//          child: _buildAlbumCell(widget._albums[index]),
//        );
//      }),
//    );
//  }
//}
