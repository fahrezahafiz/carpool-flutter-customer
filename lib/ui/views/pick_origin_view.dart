import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:carpool/core/viewmodels/pick_origin_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpool/ui/shared/custom_fab.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';

class PickOriginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return BaseView<PickOriginModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
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
                    model.moveToUserLocation();
                  },
                ),
              ),
              PickOriginSheet(),
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
    );
  }
}

class PickOriginSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PickOriginModel>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Jemput di mana?',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    CompactButton(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'LANJUT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          UIHelper.hspaceXSmall(),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      onTap: () {
                        if (model.origin == null) {
                          showToast('Pilih lokasi penjemputan',
                              position:
                                  ToastPosition(align: Alignment.topCenter));
                        } else {
                          Navigator.pushNamed(context, 'trip_summary');
                        }
                      },
                    ),
                  ],
                ),
                UIHelper.vSpaceXSmall(),
                model.origin == null
                    ? CompactButton(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.orange,
                            ),
                            UIHelper.hspaceXSmall(),
                            Text(
                              'LOKASI PENJEMPUTAN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog<LocationResult>(
                                  context: context,
                                  builder: (context) => PlacePicker(
                                      'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs'))
                              .then(
                            (result) {
                              if (result != null) model.setOrigin(result);
                            },
                          );
                        },
                      )
                    : PlaceTile(
                        name: model.origin.name,
                        address: model.origin.formattedAddress,
                        leadingIconColor: Colors.blueAccent,
                        onTap: () {
                          showDialog<LocationResult>(
                            context: context,
                            builder: (context) => PlacePicker(
                                'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs'),
                          ).then(
                            (result) {
                              if (result != null) model.setOrigin(result);
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
