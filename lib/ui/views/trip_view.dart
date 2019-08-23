import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/viewmodels/trip_model.dart';
import 'package:carpool/ui/shared/custom_fab.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TripView extends StatelessWidget {
  final String tripId;

  TripView(this.tripId);
  @override
  Widget build(BuildContext context) {
    return BaseView<TripModel>(
      onModelReady: (model) => model.init(tripId),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.stop();
          return true;
        },
        child: Scaffold(
          body: model.isBusy
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
        ),
      ),
    );
  }
}

class WaitingForApproval extends StatelessWidget {
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
                Icon(
                  FontAwesomeIcons.hourglassHalf,
                  color: Colors.blueGrey,
                  size: 40,
                ),
                UIHelper.vSpaceMedium(),
                Text(
                  'Waiting for approval...',
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
                Icon(
                  FontAwesomeIcons.hourglassHalf,
                  color: Colors.blueGrey,
                  size: 40,
                ),
                UIHelper.vSpaceMedium(),
                Text(
                  'Waiting for approval...',
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
