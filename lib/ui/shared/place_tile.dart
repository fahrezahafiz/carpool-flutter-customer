import 'package:carpool/ui/shared/compact_button.dart';
import 'package:flutter/material.dart';
import 'package:carpool/ui/shared/ui_helper.dart';

class PlaceTile extends StatelessWidget {
  final String header;
  final String name;
  final String address;
  final Color leadingIconColor;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  PlaceTile({
    this.header = '',
    this.name,
    this.address,
    this.leadingIconColor = Colors.redAccent,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.place,
                color: leadingIconColor,
                size: 28,
              ),
              UIHelper.hspaceXSmall(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      address,
                      style: TextStyle(color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
