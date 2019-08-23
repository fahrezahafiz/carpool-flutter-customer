import 'package:carpool/core/viewmodels/root_model.dart';
import 'package:carpool/ui/shared/confirm_dialog.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RootModel>(context);
    UIHelper.init(context);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Account',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        UIHelper.vSpaceMedium(),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueGrey,
            ),
            UIHelper.hSpaceSmall(),
            Expanded(
              child: Text(
                model.currentUser.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.red,
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: 'Logout',
                    content: 'Anda yakin mau logout dari aplikasi?',
                    onConfirm: () => model.logout(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
