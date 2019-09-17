import 'package:carpool/core/models/trip.dart';
import 'package:carpool/ui/shared/place_tile.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

class TripDetailsView extends StatelessWidget {
  final Trip trip;
  TripDetailsView(this.trip);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: Text('Detail Trip'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('PRIVAT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              Switch(
                activeColor: Colors.green,
                value: trip.isPrivate,
                onChanged: null,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('KATEGORI',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              RaisedButton(
                elevation: 1,
                highlightElevation: 1,
                shape: StadiumBorder(),
                color: Colors.green,
                padding: EdgeInsets.zero,
                child: Text(
                  trip.category,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              )
            ],
          ),
          UIHelper.vSpaceSmall(),
          Text('ASAL',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
          PlaceTile(
            name: trip.origin.name,
            address: trip.origin.formattedAddress,
            leadingIconColor: Colors.blueAccent,
          ),
          UIHelper.vSpaceXSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('TUJUAN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              Text(
                '${trip.distanceText} ~ ${trip.timeText}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: trip.destinations.length,
            itemBuilder: (context, index) {
              final LocationResult destination = trip.destinations[index];
              return PlaceTile(
                name: destination.name,
                address: destination.formattedAddress,
              );
            },
          ),
        ],
      ),
    );
  }
}
