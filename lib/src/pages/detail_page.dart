import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatefulWidget {
  final String? image;
  final String? heroTag;

  const DetailScreen({Key? key, this.image, this.heroTag}) : super(key: key);

  @override
  _DetailScreenWidgetState createState() => _DetailScreenWidgetState();
}

class _DetailScreenWidgetState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        child: Hero(
          tag: widget.heroTag!,
          child: PhotoView(
            // imageProvider: CachedNetworkImageProvider(widget.image),
            imageProvider: AssetImage(widget.image!),
          ),
        ),
      ),
    ));
  }
}
