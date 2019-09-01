import 'package:carpool/ui/shared/confirm_dialog.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/views/account_tab_view.dart';
import 'package:carpool/ui/views/history_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex;

  Future<void> _checkLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission != PermissionStatus.granted) {
      PermissionStatus request =
          await LocationPermissions().requestPermissions();
      print('@PermissionRequest: request = $request');
    }
    ServiceStatus serviceStatus =
        await LocationPermissions().checkServiceStatus();
    if (serviceStatus != ServiceStatus.enabled &&
        serviceStatus != ServiceStatus.notApplicable) {
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          title: 'Location turned off',
          content: 'Location must be turned on to continue using this app.',
          onConfirm: () {},
        ),
      );
    }
    print(permission.toString());
  }

  @override
  void initState() {
    _currentIndex = 0;
    _checkLocationPermission();
    super.initState();
  }

  void onItemTapped(int index) {
    _currentIndex = index;
    setState(() {});
  }

  List<Widget> _tabs = [HomeTabView(), HistoryTabView(), AccountTabView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.listAlt), title: Text('Trips')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Account')),
        ],
        currentIndex: _currentIndex,
        onTap: onItemTapped,
      ),
    );
  }
}

class HomeTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset('images/sigma.png', width: 50),
            UIHelper.hSpaceSmall(),
            Text(
              'Carpool',
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
            Expanded(
                child: MenuCard(
              'Sedan VIP',
              image: 'images/sedan.png',
              onTap: () => Navigator.pushNamed(context, 'pick_destination',
                  arguments: 'sedan'),
            )),
            Expanded(
                child: MenuCard(
              'MPV',
              image: 'images/mpv-vip.png',
              onTap: () => Navigator.pushNamed(context, 'pick_destination',
                  arguments: 'mpvvip'),
            )),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: MenuCard(
              'MPV Pool',
              image: 'images/mpv-pool.png',
              onTap: () => Navigator.pushNamed(context, 'pick_destination',
                  arguments: 'mpvstandard'),
            )),
            Expanded(
                child: MenuCard(
              'Minibus',
              image: 'images/minibus.png',
              onTap: () => Navigator.pushNamed(context, 'pick_destination',
                  arguments: 'minibus'),
            )),
          ],
        ),
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String image;

  MenuCard(this.title,
      {this.color = Colors.black54,
      this.onTap,
      this.image = 'images/sedan.png'});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(8),
          color: Colors.grey[200],
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: AspectRatio(
            aspectRatio: 1,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(image, height: 40),
                UIHelper.vSpaceSmall(),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18, color: color, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onTap,
              ),
            ),
          ),
        )
      ],
    );
  }
}
