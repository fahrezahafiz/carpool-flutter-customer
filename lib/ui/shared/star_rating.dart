import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double size;
  final MainAxisAlignment alignment;
  final double starPadding;

  StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color,
      this.size,
      this.alignment = MainAxisAlignment.center,
      this.starPadding = 4});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        FontAwesomeIcons.star,
        color: Theme.of(context).buttonColor,
        size: this.size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        FontAwesomeIcons.starHalf,
        color: color ?? Theme.of(context).primaryColor,
        size: this.size,
      );
    } else {
      icon = new Icon(
        FontAwesomeIcons.solidStar,
        color: color ?? Theme.of(context).primaryColor,
        size: this.size,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: this.starPadding),
          child: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Row(
          mainAxisAlignment: this.alignment,
          children: new List.generate(
              starCount, (index) => buildStar(context, index))),
    );
  }
}
