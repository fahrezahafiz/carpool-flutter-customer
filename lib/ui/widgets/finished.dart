import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/star_rating.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:oktoast/oktoast.dart';
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            rating: trip.feedback == null ? model.rating : trip.feedback.rating,
            onRatingChanged: trip.feedback == null
                ? (rating) => model.setRating = rating
                : null,
          ),
          UIHelper.vSpaceSmall(),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'What do you think of the driver?',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLength: 100,
            maxLines: 3,
            onChanged: (val) => model.feedbackMessage = val,
            textInputAction: TextInputAction.done,
          ),
          Center(
            child: model.isBusy
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Colors.green,
                    elevation: 0,
                    highlightElevation: 1,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: model.rating == 0
                        ? null
                        : () async {
                            bool sendSuccess = await model.sendFeedback();
                            if (sendSuccess) {
                              showToast('Feedback berhasil dikirim');
                            } else {
                              showToast('Gagal mengirim feedback');
                            }
                          },
                  ),
          ),
          UIHelper.vSpaceSmall(),
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
                      trip.driver.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      trip.driver.licensePlate,
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
