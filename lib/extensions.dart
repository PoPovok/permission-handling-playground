import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

extension Coloring on PermissionStatus? {
  Color get color => switch (this) {
        null => Colors.white,
        PermissionStatus.granted => Colors.lightGreenAccent,
        PermissionStatus.denied => Colors.orange,
        PermissionStatus.restricted => Colors.brown,
        PermissionStatus.permanentlyDenied => Colors.redAccent,
        PermissionStatus.limited => Colors.limeAccent,
        PermissionStatus.provisional => Colors.purpleAccent,
      };
}

extension Naming on Permission {
  get name => toString().substring(11);
}
