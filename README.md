# flutter_instagram_image_picker

A Flutter package for picking images from Instagram

## Getting Started

This plugin displays a gallery with user's Instagram Albums and Photos, based on the access token provided.
It does handle authorization and login by itself.\
Then just provides access data (userId+SessionKey) to the gallery.

### Usage
1.Check if user has logged in, if not prompt him to enter his login data using by navigation to the `InstagramLoginPage`
```dart
bool isLogged = await InstagramAuth().isLogged;
// check if user already logged in, if not log the user
if (!isLogged) {
  bool loginStatus = await InstagramAuth().signUserIn(context);

  // if user canceled the operation
  if (!loginStatus)
    return;
}
```
 
2.Check if the user logged in successfully by accessing his data.
```dart
final accessMapData = await InstagramAuth().accessData;
if(accessMapData == null){
  return null;
}
```

3.After we got the access data, we can navigate to `InstagramImagePicker`:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => InstagramImagePicker(
      accessMapData,
      showLogoutButton: true,
      onDone: (photos) {
        // photos are the photos you selected in the picker
        // each one has the url
        Navigator.pop(context);
      },
      onCancel: () => Navigator.pop(context),
    ),
  ),
);
,
```

## Screenshots
* Login Page:



![](images/login_filled.png)


* Image Picker:

![](images/picker_page.png)

* Image Picker (after selection):

![](images/picker_page_selected.png)