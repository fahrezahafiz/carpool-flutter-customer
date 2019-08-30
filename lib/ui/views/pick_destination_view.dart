import 'dart:async';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/custom_fab.dart';
import 'package:carpool/ui/shared/icon_for_dismissible.dart';
import 'package:carpool/ui/shared/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:place_picker/place_picker.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:carpool/core/viewmodels/pick_destination_model.dart';
import 'package:oktoast/oktoast.dart';

class PickDestinationView extends StatelessWidget {
  final String category;

  PickDestinationView(this.category);

  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return BaseView<PickDestinationModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: SlidingUpPanel(
          controller: model.panelController,
          padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
          minHeight: UIHelper.safeBlockVertical * 18,
          maxHeight: UIHelper.safeBlockVertical * 85,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          panel: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Mau ke mana hari ini?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              UIHelper.vSpaceXSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CompactButton(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.orange,
                        ),
                        UIHelper.hspaceXSmall(),
                        Text(
                          'TAMBAH TUJUAN',
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
                              'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs')).then(
                        (result) {
                          if (result != null) model.addDestination(result);
                        },
                      );
                    },
                  ),
                  CompactButton(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'LANJUT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        UIHelper.hspaceXSmall(),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    onTap: () {
                      if (model.destinations.length == 0) {
                        showToast('Belum ada tujuan',
                            position:
                                ToastPosition(align: Alignment.topCenter));
                        model.expandPanel();
                      } else {
                        Navigator.pushNamed(context, 'pick_origin');
                      }
                    },
                  ),
                ],
              ),
              UIHelper.vSpaceMedium(),
              Text('${model.destinations.length} TUJUAN',
                  style: TextStyle(color: Colors.black54)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: model.destinations.length,
                  itemBuilder: (context, index) {
                    LocationResult dest = model.destinations[index];
                    return Dismissible(
                      direction: DismissDirection.horizontal,
                      key: Key(model.destinations[index].placeId),
                      background: IconForDismissible(
                        isLeft: true,
                        icon: Icons.delete,
                        backgroundColor: Colors.redAccent,
                      ),
                      secondaryBackground: IconForDismissible(
                        isLeft: false,
                        icon: Icons.delete,
                        backgroundColor: Colors.redAccent,
                      ),
                      onDismissed: (direction) {
                        model.deleteDestination(index);
                      },
                      child: PlaceTile(
                        name: dest.name,
                        address: dest.formattedAddress,
                        onTap: () {
                          showDialog<LocationResult>(
                            context: context,
                            builder: (context) => PlacePicker(
                                'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs'),
                          ).then(
                            (result) {
                              if (result != null)
                                model.changeDestination(result, index);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: UIHelper.safeBlockVertical * 90,
                        child: GoogleMap(
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
                CustomFAB(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                CustomFAB(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.my_location, color: Colors.blueAccent),
                  onTap: () => model.moveToUserLocation(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
