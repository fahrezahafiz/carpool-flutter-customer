import 'package:carpool/core/viewmodels/root_model.dart';
import 'package:carpool/ui/shared/confirm_dialog.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RootModel>(context);
    final user = model.currentUser;
    UIHelper.init(context);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      children: <Widget>[
        UIHelper.vSpaceMedium(),
        Center(
          child: Text(
            user.name,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        UIHelper.vSpaceXSmall(),
        Center(
            child: Text(
          user.email,
          style: TextStyle(
              fontSize: 16, color: Colors.black45, fontWeight: FontWeight.bold),
        )),
        Center(
            child: Text(
          user.phone,
          style: TextStyle(
              fontSize: 16, color: Colors.black45, fontWeight: FontWeight.bold),
        )),
        UIHelper.vSpaceSmall(),
        CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 60,
        ),
        UIHelper.vSpaceSmall(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  model.getTotalDistance,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('Total Distance', style: TextStyle(color: Colors.black54))
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  model.getTotalTime,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('Total Time', style: TextStyle(color: Colors.black54))
              ],
            ),
          ],
        ),
        UIHelper.vSpaceMedium(),
        CompactButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.exit_to_app, color: Colors.red),
              UIHelper.hspaceXSmall(),
              Text(
                'Logout',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          padding: EdgeInsets.all(8),
          onTap: () => showDialog(
              context: context,
              builder: (context) => ConfirmDialog(
                    title: 'Logout',
                    content: 'Anda akan keluar dari aplikasi',
                    onConfirm: () {
                      model.logout();
                      Navigator.pop(context);
                    },
                  )),
        ),
      ],
    );
  }
}
