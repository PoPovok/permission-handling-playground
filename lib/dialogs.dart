import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handling_playground/extensions.dart';

class PermissionDescriptionDialog extends AlertDialog {
  final Permission permission;
  final Function(Permission) onProvidePermission;
  final Function() onCancel;

  const PermissionDescriptionDialog({
    required this.permission,
    required this.onProvidePermission,
    required this.onCancel,
    super.key,
  });

  @override
  Widget? get title => const Text("Permission request #1");

  @override
  Widget? get content => Text(
        "Providing ${permission.name} permission is necessary to show every feature of permission handling in this demo.",
      );

  @override
  List<Widget>? get actions => [
        MaterialButton(onPressed: () => onProvidePermission(permission), child: const Text("Provide")),
        MaterialButton(onPressed: onCancel, child: const Text("Cancel"))
      ];
}

class PermissionDescriptionDeniedDialog extends AlertDialog {
  final Permission permission;
  final Function(Permission) onProvidePermission;
  final Function() onCancel;

  const PermissionDescriptionDeniedDialog({
    required this.permission,
    required this.onProvidePermission,
    required this.onCancel,
    super.key,
  });

  @override
  Widget? get title => const Text("Permission request #2");

  @override
  Widget? get content => Text(
        "In order to change the color of the permission's card to green, the application must have access to the ${permission.name} permission.",
      );

  @override
  List<Widget>? get actions => [
        MaterialButton(onPressed: () => onProvidePermission(permission), child: const Text("Provide")),
        MaterialButton(onPressed: onCancel, child: const Text("Cancel"))
      ];
}

class PermissionDescriptionDeniedPermanentlyDialog extends AlertDialog {
  final Permission permission;
  final Function() onOpenSettings;
  final Function() onCancel;

  const PermissionDescriptionDeniedPermanentlyDialog({
    required this.permission,
    required this.onOpenSettings,
    required this.onCancel,
    super.key,
  });

  @override
  Widget? get title => const Text("Permission request #3");

  @override
  Widget? get content => Text(
        "You must go to the settings and allow ${permission.name} permission manually in order to use certain features of the application.",
      );

  @override
  List<Widget>? get actions => [
        MaterialButton(onPressed: onOpenSettings, child: const Text("Open Settings")),
        MaterialButton(onPressed: onCancel, child: const Text("Cancel"))
      ];
}
