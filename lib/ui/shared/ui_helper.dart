import 'package:flutter/material.dart';

class UIHelper {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static double _extraSmallSpace = 10;
  static double _smallSpace = 20;
  static double _mediumSpace = 40;
  static double _largeSpace = 80;
  static double _extraLargeSpace = 120;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static Widget hspaceXSmall() => SizedBox(width: _extraSmallSpace);
  static Widget hSpaceSmall() => SizedBox(width: _smallSpace);
  static Widget hSpaceMedium() => SizedBox(width: _mediumSpace);
  static Widget hSpaceLarge() => SizedBox(width: _largeSpace);
  static Widget hSpaceXLarge() => SizedBox(width: _extraLargeSpace);

  static Widget vSpaceXSmall() => SizedBox(height: _extraSmallSpace);
  static Widget vSpaceSmall() => SizedBox(height: _smallSpace);
  static Widget vSpaceMedium() => SizedBox(height: _mediumSpace);
  static Widget vSpaceLarge() => SizedBox(height: _largeSpace);
  static Widget vSpaceXLarge() => SizedBox(height: _extraLargeSpace);
}
