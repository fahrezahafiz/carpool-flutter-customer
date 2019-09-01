import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/confirm_dialog.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindingDriver extends StatelessWidget {
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
                Text(
                  'Searching for a driver...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                UIHelper.vSpaceXSmall(),
                Text(
                  '${model.trip.nearbyDrivers} driver' +
                      (model.trip.nearbyDrivers > 1 ? 's' : '') +
                      ' near you',
                  style: TextStyle(color: Colors.black54),
                ),
                UIHelper.vSpaceSmall(),
                CompactButton(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'Cancel order',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: 'Cancel Order',
                      content: 'Anda yakin mau cancel order ini?',
                      onConfirm: () => model.cancelOrder().then((success) {
                        if (success) {
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
