import 'dart:async';

import 'package:flutter/material.dart';
import 'instagram_auth.dart';
import 'instagram_api_client.dart';
import 'model/photo.dart';
import 'model/photo_paging.dart';
import 'ui/photo_grid.dart';

/// Widget that presents the Image picker of photos of an Instagram account
class InstagramImagePicker extends StatefulWidget {
  final Map<String, String> _accessMap;

  /// AppBar config
  final String appBarTitle;
  final TextStyle? appBarTextStyle;
  final Color? appBarColor;

  /// AppBar actions
  final String doneBtnText;
  final TextStyle? doneBtnTextStyle;
  final Function(List<Photo>) onDone;
  final String cancelBtnText;
  final TextStyle? cancelBtnTextStyle;
  final Function onCancel;
  final bool showLogoutButton;

  const InstagramImagePicker(
    this._accessMap, {
    super.key,
    this.appBarTitle = 'Pick Instagram Image',
    this.appBarTextStyle,
    this.appBarColor,
    this.doneBtnText = 'Done',
    this.doneBtnTextStyle,
    required this.onDone,
    this.cancelBtnText = 'Cancel',
    this.cancelBtnTextStyle,
    required this.onCancel,
    this.showLogoutButton = false,
  }); //: assert(_accessToken != null);

  @override
  _InstagramImagePickerState createState() => _InstagramImagePickerState();
}

class _InstagramImagePickerState extends State<InstagramImagePicker>
    with TickerProviderStateMixin {
  InstagramApiClient? _client;
  final List<Photo> _photos = [];

  int _page = 0;
  bool _hasNext = true;

  List<Photo> _selectedPhotos = [];
  static bool first = true;

  AnimationController? _controller;

  // Animation<Offset> _imageListPosition;

  @override
  void initState() {
    super.initState();
    _selectedPhotos = <Photo>[];

    _client = InstagramApiClient();

    _paginatePhotos();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // _imageListPosition = Tween<Offset>(
    //   begin: Offset.zero,
    //   end: const Offset(-1.0, 0.0),
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // ));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String get title => widget.appBarTitle;

  /// Handles pagination and loading more photos if left
  Future<void> _paginatePhotos() async {
    if (!first && !_hasNext) {
      return;
    }
    _hasNext = false;

    PhotoPaging photoPaging;

    if (_page == 0) {
      photoPaging = await _client!.fetchPhotos(
        userId: widget._accessMap['userId'] ?? "",
        //sessionKey: widget._accessMap['sessionKey'] ?? "",
      );
    } else {
      photoPaging = await _client!.fetchPhotos(
        userId: widget._accessMap['userId'] ?? "",
        // sessionKey: widget._accessMap['sessionKey'] ?? "",
        // page: _page + 1,
      );
      _page++;
    }

    if (photoPaging.hasNext == false) {
      _hasNext = false;
    }

    setState(() {
      _photos.addAll(photoPaging.data ?? []);
    });
  }

  void _reset() {
    setState(() {
      _selectedPhotos = [];
      _hasNext = true;
    });
  }

  void _onDone() {
    widget.onDone(_selectedPhotos);
    _reset();
  }

  void _onLogout() async {
    await InstagramAuth().logout();
    _onCancel();
  }

  Widget _buildDoneButton() {
    return !widget.showLogoutButton
        ? Container()
        : GestureDetector(
            onTap: _onLogout,
            child: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Text(
                  'Logout',
                  textScaleFactor: 1.3,
                  style: widget.doneBtnTextStyle ??
                      const TextStyle(
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
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: _onCancel,
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
                onLoadMore: () {}, //_paginatePhotos,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                //color: Colors.indigo,
                child: Text(
                  "${widget.doneBtnText} (${_selectedPhotos.length})",
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: _onDone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
