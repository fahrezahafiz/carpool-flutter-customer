import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/star_rating.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:carpool/ui/shared/place_tile.dart';

class Finished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TripModel>(context);
    final trip = model.trip;
    return SlidingUpPanel(
      controller: model.panelController,
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      minHeight: UIHelper.safeBlockVertical * 20,
      maxHeight: UIHelper.safeBlockVertical * 90,
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      backdropEnabled: true,
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Trip finished',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    DateFormat.yMMMMd().format(trip.createdAt),
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    DateFormat.jm().format(trip.createdAt),
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          UIHelper.vSpaceXSmall(),
          Text(
            'Order ' + trip.id,
            style: TextStyle(color: Colors.black54),
          ),
          UIHelper.vSpaceMedium(),
          Divider(height: 0),
          UIHelper.vSpaceSmall(),
          Center(
              child: Text(
            'Driver feedback',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          )),
          UIHelper.vSpaceSmall(),
          StarRating(
            size: 34,
            color: Colors.orangeAccent,
            starPadding: 4,
            rating: model.rating,
            onRatingChanged: (rating) => model.setRating = rating,
          ),
          UIHelper.vSpaceMedium(),
          Divider(height: 0),
          UIHelper.vSpaceSmall(),
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blueGrey,
              ),
              UIHelper.hSpaceSmall(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      trip.driverName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      trip.licensePlate,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          UIHelper.vSpaceSmall(),
          Divider(height: 0),
          UIHelper.vSpaceSmall(),
          Text('TRIP DETAILS',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black45)),
          PlaceTile(
            name: trip.origin.name,
            address: trip.origin.formattedAddress,
            leadingIconColor: Colors.blueAccent,
          ),
          Expanded(
            child: ListView(
              children: trip.destinations
                  .map(
                    (dest) => PlaceTile(
                      name: dest.name,
                      address: dest.formattedAddress,
                      leadingIconColor: Colors.red,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//Center(
//child: RaisedButton(
//padding: EdgeInsets.all(10),
//elevation: 0,
//highlightElevation: 1,
//color: Colors.green,
//child: Text(
//'Submit',
//style: TextStyle(fontSize: 16, color: Colors.white),
//),
//onPressed: () {},
//),
//),
