import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/viewmodels/history_tab_model.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryTabModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Text(
                'Trips',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            model.isBusy
                ? Center(child: CircularProgressIndicator())
                : model.trips.length == 0
                    ? Center(
                        child: Text('Belum ada trip',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 18)))
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          itemCount: model.trips.length,
                          itemBuilder: (context, index) {
                            final trip = model.trips[index];
                            return TripTile(trip);
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class TripTile extends StatelessWidget {
  final Trip trip;

  TripTile(this.trip);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HistoryTabModel>(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'trip', arguments: trip.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.carAlt, color: Colors.blueGrey, size: 30),
              UIHelper.hSpaceSmall(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    trip.destinations[0].name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.tripStateToReadable(trip.status),
                    style: TextStyle(color: Colors.black54),
                  ),
                  UIHelper.vSpaceXSmall(),
                  Text(
                    DateFormat.yMMMMd().format(trip.createdAt),
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
