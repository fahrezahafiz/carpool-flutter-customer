import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/custom_fab.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:carpool/ui/widgets/waiting_for_approval.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
          return true;
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
                        : model.trip.status == TripState.FindingDriver
                            ? FindingDriver()
                            : model.trip.status == TripState.OnTheWay
                                ? OnTheWay()
                                : model.trip.status == TripState.Finished
                                    ? Finished()
                                    : Error(),
                CustomFAB(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
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

class FindingDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TripModel>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: CustomFAB(
              child: Icon(Icons.arrow_back),
              onTap: () {
                model.stop();
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                UIHelper.vSpaceMedium(),
                Text(
                  'Finding a driver...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
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

class OnTheWay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TripModel>(context);
    return SafeArea(
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
                model.getDirection();
              },
            ),
          ),
          //PickOriginSheet(),
          CustomFAB(
            child: Icon(Icons.arrow_back),
            onTap: () {
              model.stop();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class Finished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Finished'));
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          UIHelper.vSpaceMedium(),
          Text(
            'Error: State Not Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
