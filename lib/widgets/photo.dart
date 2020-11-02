import 'package:card_animation/models/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Photo extends StatelessWidget {
  const Photo({
    this.photoCard,
    Key key,
  }) : super(key: key);

  final PhotoCard photoCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: photoCard.link,
                fit: BoxFit.fill,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Text(
                  photoCard.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
