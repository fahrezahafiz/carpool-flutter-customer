import 'package:carpool/core/viewmodels/trip_summary_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/place_tile.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:place_picker/place_picker.dart';

class TripSummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<TripSummaryModel>(
      onModelReady: (model) => model.init,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text('Detail Pesanan'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('PRIVAT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      Switch(
                        inactiveThumbColor: Colors.green,
                        activeColor: Colors.green,
                        value: model.isPrivate,
                        onChanged: model.category == 'sedan'
                            ? null
                            : ((val) => model.togglePrivate(val)),
                      ),
                    ],
                  ),
                  UIHelper.vSpaceSmall(),
                  Text('ASAL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54)),
                  PlaceTile(
                    name: model.origin.name,
                    address: model.origin.formattedAddress,
                    leadingIconColor: Colors.blueAccent,
                  ),
                  UIHelper.vSpaceXSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('TUJUAN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      Text(
                        '${model.direction.distanceText}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: model.destinations.length,
                  itemBuilder: (context, index) {
                    final LocationResult destination =
                        model.destinations[index];
                    return PlaceTile(
                      name: destination.name,
                      address: destination.formattedAddress,
                    );
                  },
                ),
              ),
            ),
            UIHelper.vSpaceSmall(),
            SafeArea(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CompactButton(
                      backgroundColor: Colors.grey[200],
                      splashColor: Colors.black12,
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Center(
                          child: Text(
                            'Order Nanti',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(context, 'order_later'),
                    ),
                  ),
                  Expanded(
                    child: CompactButton(
                      backgroundColor: Colors.green,
                      splashColor: Colors.black12,
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Center(
                          child: Text(
                            'Order Sekarang',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      onTap: () {
                        model.sendOrder().then((success) {
                          if (success)
                            showToast('Order berhasil');
                          else
                            showToast('Order gagal');
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
