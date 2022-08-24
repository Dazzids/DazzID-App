import 'dart:io';

import 'package:dazz/src/services/user/profile_image_provider.dart';
import 'package:dazz/src/states/profile_image_state.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageSelectorWidget extends StatefulWidget {
  final String title;
  final String profileImage;
  ImageSelectorWidget(
      {Key key, @required this.title, @required this.profileImage})
      : super(key: key);

  @override
  _ImageSelectorWidgetState createState() => _ImageSelectorWidgetState();
}

class _ImageSelectorWidgetState extends State<ImageSelectorWidget> {
  File _loadedImage;
  final _picker = ImagePicker();
  ProfileImage _profileImage;
  ImageFirebaseProvider _imageProvider = ImageFirebaseProvider();

  @override
  void didChangeDependencies() {
    _profileImage = Provider.of<ProfileImage>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pictureSize = size.width * .3;

    FadeInImage fadeInImage;
    if (widget.profileImage != null && _loadedImage == null) {
      fadeInImage = FadeInImage(
          placeholder: AssetImage('assets/images/avatar-placeholder.png'),
          image: NetworkImage(widget.profileImage));
    }

    Container imageContent = Container(
        padding: EdgeInsets.all(5.0),
        child: _loadedImage == null && fadeInImage == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child:
                          Text(widget.title, style: TextStyle(fontSize: 20.0))),
                ),
              )
            : fadeInImage != null
                ? fadeInImage
                : Image.file(_loadedImage));

    Container buttons = Container(
      width: pictureSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () async {
                  await getImage(ImageSource.camera);
                },
              ),
              Text('Camara'),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: () async {
                  await getImage(ImageSource.gallery);
                },
              ),
              Text('Galeria'),
            ],
          )
        ],
      ),
    );

    final image = GestureDetector(
      //onTap: () => getImage(ImageSource.gallery),
      onLongPress: () {
        // if (widget.enabled) {
        //   _imagesFolio.removeItem(widget.imageDocument, logicRemove: widget.logicRemove);
        // }
      },

      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Colors.grey)),
          width: pictureSize,
          height: pictureSize * 1.2,
          child: imageContent),
    );

    return Column(
      children: <Widget>[
        image,
        SeparatorWidget(
          height: size.height * .02,
        ),
        if (widget.profileImage == null && fadeInImage == null)
          Container()
        else
          Text(widget.title, style: TextStyle(fontSize: 20.0)),
        buttons,
        SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    File _imageCompressed;

    if (pickedFile == null) {
      setState(() {
        _loadedImage = null;
        _profileImage.setProfileImage(_imageCompressed);
      });
    }

    if (pickedFile != null) {
      //var _image = File(pickedFile.path);
      _imageCompressed = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 50,
        aspectRatioPresets: [CropAspectRatioPreset.original],
        compressFormat: ImageCompressFormat.jpg,
        // androidUiSettings: AndroidUiSettings(
        //   hides
        // )
      );

      setState(() {
        _loadedImage = _imageCompressed;
        _profileImage.setProfileImage(_imageCompressed);
      });

      // if (_imageCompressed == null) {
      //   setState(() {
      //     _loadedImage = null;
      //   });
      // }
    } else {
      setState(() {
        _loadedImage = null;
        _profileImage.setProfileImage(_imageCompressed);
      });
    }
  }

  Future<String> _getProfileImage() async {
    return await _imageProvider.getImageURL(widget.profileImage);
  }
}
