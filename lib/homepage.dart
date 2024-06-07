import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handling_playground/extensions.dart';

import 'dialogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static final Set<Permission> _nonAndroidDefaultPermissions = {
    Permission.unknown,
    Permission.mediaLibrary,
    Permission.photosAddOnly,
    Permission.reminders,
    Permission.bluetooth,
    Permission.appTrackingTransparency,
    Permission.criticalAlerts,
    Permission.assistant,
    Permission.backgroundRefresh
  };
  static final Set<Permission> _webDefaults = {
    Permission.camera,
    Permission.location,
    Permission.microphone,
    Permission.notification
  };
  static final Set<Permission> _androidDefaults = Permission.values.toSet().difference(_nonAndroidDefaultPermissions);

  late final List<Permission> permissions;
  var wasAppSettingsOpened = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    permissions = (kIsWeb ? _webDefaults : _androidDefaults).toList();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (wasAppSettingsOpened) {
        setState(() {
          wasAppSettingsOpened = false;
        });
      }
    }
  }

  void requestPermission(Permission permission, PermissionStatus? status) {
    switch (status) {
      case PermissionStatus.denied:
        requestPermissionDialog(permission);
      case PermissionStatus.permanentlyDenied:
        requestPermanentlyDeniedPermissionDialog(permission);
      default:
    }
  }

  void _onPermissionChanged(Permission permission) {
    _onPopBack();
    permission.request().then((status) {
      setState(() {
        switch (status) {
          case PermissionStatus.denied:
            requestDeniedPermissionDialog(permission);
          case PermissionStatus.permanentlyDenied:
            requestPermanentlyDeniedPermissionDialog(permission);
          default:
        }
      });
    });
  }

  void _onOpenApplicationSettings() {
    _onPopBack();
    openAppSettings();
    wasAppSettingsOpened = true;
  }

  void _onPopBack() {
    Navigator.pop(context);
  }

  void requestPermissionDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) {
        return PermissionDescriptionDialog(
          permission: permission,
          onProvidePermission: _onPermissionChanged,
          onCancel: _onPopBack,
        );
      },
    );
  }

  void requestDeniedPermissionDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) {
        return PermissionDescriptionDeniedDialog(
          permission: permission,
          onProvidePermission: _onPermissionChanged,
          onCancel: _onPopBack,
        );
      },
    );
  }

  void requestPermanentlyDeniedPermissionDialog(Permission permission) {
    if (!kIsWeb) {
      showDialog(
        context: context,
        builder: (context) {
          return PermissionDescriptionDeniedPermanentlyDialog(
            permission: permission,
            onOpenSettings: _onOpenApplicationSettings,
            onCancel: _onPopBack,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Permission Handling")),
        body: ListView.builder(
            itemBuilder: (context, index) {
              final permission = permissions[index];
              return FutureBuilder(
                  future: permission.status,
                  builder: (context, snapshot) {
                    final status = snapshot.data;
                    return GestureDetector(
                        onTap: () => requestPermission(permission, status),
                        child: Card(
                            child: Container(
                                padding: const EdgeInsets.all(16),
                                color: status.color,
                                child: Text(permission.name, style: const TextStyle(fontSize: 24)))));
                  });
            },
            itemCount: permissions.length));
  }
}
