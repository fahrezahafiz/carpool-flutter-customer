import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TripModel>(context);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.red, size: 36),
                UIHelper.vSpaceXSmall(),
                Text(
                  'Error: Trip state not found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
