import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'graph_api.dart';
import 'model/photo.dart';
import 'model/photo_paging.dart';
import 'ui/photo_grid.dart';

class InstagramImagePicker extends StatefulWidget {
  final String _accessToken;

  /// AppBar config
  final String appBarTitle;
  final TextStyle appBarTextStyle;
  final Color appBarColor;

  /// AppBar actions
  final String doneBtnText;
  final TextStyle doneBtnTextStyle;
  final Function(List<Photo>) onDone;
  final String cancelBtnText;
  final TextStyle cancelBtnTextStyle;
  final Function onCancel;

  InstagramImagePicker(
    this._accessToken, {
    this.appBarTitle = 'Pick Instagram Image',
    this.appBarTextStyle,
    this.appBarColor,
    this.doneBtnText = 'Done',
    this.doneBtnTextStyle,
    @required this.onDone,
    this.cancelBtnText = 'Cancel',
    this.cancelBtnTextStyle,
    @required this.onCancel,
  }) : assert(_accessToken != null);

  @override
  _InstagramImagePickerState createState() => _InstagramImagePickerState();
}

class _InstagramImagePickerState extends State<InstagramImagePicker>
    with TickerProviderStateMixin {
  GraphApi _client;
  List<Photo> _photos = [];
  String _photosNextLink;
  List<Photo> _selectedPhotos;

  AnimationController _controller;
  Animation<Offset> _imageListPosition;

  @override
  void initState() {
    super.initState();
    _selectedPhotos = List<Photo>();
    _client = GraphApi(widget._accessToken);
    _paginatePhotos();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _imageListPosition = new Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get title {
    return widget.appBarTitle;
  }

  Future<void> _paginatePhotos() async {
//    if (_photosNextLink == null) {
//      return;
//    }
    PhotoPaging photos = await _client.fetchPhotos();
    setState(() {
      _photos.addAll(photos.data);
      if (photos.pagination != null) {
        _photosNextLink = photos.pagination.next;
      }
    });
  }

  void _reset() {
    setState(() {
      _selectedPhotos = [];
      _photosNextLink = null;
    });
  }

  void _onDone() {
    widget.onDone(_selectedPhotos);
    _reset();
  }

  void _onLogout() async {
    //await Provider.of<AuthService>(context).fbLogin.logOut();
    _onCancel();
  }

  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: _onLogout,
      child: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.only(end: 8),
          child: Text(
            'Logout',
            textScaleFactor: 1.3,
            style: widget.doneBtnTextStyle ??
                TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  void _onCancel() {
    _reset();
    widget.onCancel();
  }

//  Widget _buildCancelButton() {
//    return GestureDetector(
//      onTap: _onCancel,
//      child: Center(
//        child: Padding(
//          padding: EdgeInsets.only(left: 5.00),
//          child: Text(
//            '${widget.cancelBtnText}',
//            textScaleFactor: 1.3,
//            style: widget.cancelBtnTextStyle ??
//                TextStyle(
//                  fontSize: 12.0,
//                  color: Colors.white,
//                ),
//          ),
//        ),
//      ),
//    );
//  }

  void _onPhotoTap(Photo photo) {
    int itemIndex = _selectedPhotos.indexOf(photo);

    if (itemIndex == -1) {
      return setState(() {
        _selectedPhotos.add(photo);
      });
    }

    setState(() {
      _selectedPhotos.removeAt(itemIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widget.appBarColor,
        title: Text(
          title,
          style: widget.appBarTextStyle,
        ),
        leading: //_selectedAlbum == null
            //? _buildCancelButton()
            /*:*/ IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _onCancel();
            //Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          _buildDoneButton(),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PhotoGrid(
                _photos,
                _selectedPhotos,
                onPhotoTap: _onPhotoTap,
                //onLoadMore: _paginatePhotos,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: RaisedButton(
              color: Colors.indigo,
              child: Text(
                "${widget.doneBtnText} (${_selectedPhotos.length})",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _onDone,
            ),
          ),
        ],
      ),
    );
  }
}
