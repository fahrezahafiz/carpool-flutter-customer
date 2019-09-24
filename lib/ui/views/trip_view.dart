import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/custom_fab.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:carpool/ui/widgets/denied.dart';
import 'package:carpool/ui/widgets/finding_driver.dart';
import 'package:carpool/ui/widgets/finished.dart';
import 'package:carpool/ui/widgets/on_the_way.dart';
import 'package:carpool/ui/widgets/loading.dart';
import 'package:carpool/ui/widgets/waiting_for_approval.dart';
import 'package:carpool/ui/widgets/booked.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripView extends StatelessWidget {
  final String tripId;

  TripView(this.tripId);
  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return BaseView<TripModel>(
      onModelReady: (model) => model.init(tripId),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.stop();
          Navigator.pop(context, true);
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  height: UIHelper.safeBlockVertical * 90,
                  child: GoogleMap(
                    polylines: model.polyLines,
                    markers: model.markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition:
                        model.userPosition ?? model.defaultPosition,
                    onMapCreated: (controller) {
                      model.setMapController = controller;
                    },
                  ),
                ),
                model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : model.trip.status == TripState.WaitingForApproval
                        ? WaitingForApproval()
                        : model.trip.status ==
                                TripState.WaitingForApprovalBooked
                            ? Booked()
                            : model.trip.status == TripState.DeniedByUser ||
                                    model.trip.status == TripState.DeniedByAdmin
                                ? Denied()
                                : model.trip.status == TripState.FindingDriver
                                    ? FindingDriver()
                                    : model.trip.status == TripState.OnTheWay
                                        ? OnTheWay()
                                        : model.trip.status ==
                                                TripState.Finished
                                            ? Finished()
                                            : Loading(),
                CustomFAB(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context, true),
                ),
                CustomFAB(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.my_location, color: Colors.blueAccent),
                  onTap: () => model.moveToUserLocation(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
