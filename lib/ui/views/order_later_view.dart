import 'package:carpool/core/viewmodels/order_later_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderLaterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return BaseView<OrderLaterModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text('Order Nanti'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('TANGGAL',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              UIHelper.vSpaceXSmall(),
              CompactButton(
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300])),
                    child: Center(
                        child: Text(
                      DateFormat.yMMMMd().format(model.date),
                      style: TextStyle(color: Colors.green),
                    )),
                  ),
                  onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(minutes: 10)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 7)))),
              UIHelper.vSpaceSmall(),
              Text('WAKTU JEMPUT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              UIHelper.vSpaceXSmall(),
              CompactButton(
                backgroundColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  child: Center(
                      child: Text(
                    model.time.format(context),
                    style: TextStyle(color: Colors.green),
                  )),
                ),
                onTap: () => showTimePicker(
                        context: context, initialTime: TimeOfDay.now())
                    .then((value) => model.setTime = value),
              ),
              UIHelper.vSpaceXSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('DINAS ?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54)),
                  Switch(
                      activeColor: Colors.green,
                      value: model.isDinas,
                      onChanged: ((val) => model.toggleDinas(val))),
                ],
              ),
              UIHelper.vSpaceXSmall(),
              Text('Durasi dalam hari',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              UIHelper.vSpaceXSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CompactButton(
                    child: Icon(Icons.remove, color: Colors.black54),
                    onTap: () => model.subtractDuration(),
                  ),
                  UIHelper.hSpaceSmall(),
                  Container(
                    child: Text(
                      model.duration.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                  UIHelper.hSpaceSmall(),
                  CompactButton(
                    child: Icon(Icons.add, color: Colors.black54),
                    onTap: () => model.addDuration(),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: CompactButton(
          backgroundColor: Colors.green,
          splashColor: Colors.black12,
          padding: EdgeInsets.all(16),
          child: Container(
            height: 24,
            child: Center(
              child: Text(
                'Order Nanti',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
