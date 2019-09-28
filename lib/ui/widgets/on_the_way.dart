import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnTheWay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TripModel>(context);
    final trip = model.trip;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.0,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "You're on your way.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                UIHelper.vSpaceSmall(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            trip.driver.licensePlate,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Text(
                            trip.driver.vehicleName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Text(
                            trip.driver.name,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelper.vSpaceSmall(),
                Center(
                  child: CompactButton(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'TRIP DETAILS',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'trip_details',
                          arguments: trip);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
