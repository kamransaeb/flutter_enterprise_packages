import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

enum AppPermission {
  camera,
  photos,
  location,
  microphone,
  contacts,
  calendar,
  reminders,
  notifications,
  storage,
}

/// App-level permission checks, requests, and simple dialogs.
class PermissionHelper {
  PermissionHelper._();

  static const Map<AppPermission, ph.Permission> _map = {
    AppPermission.camera: ph.Permission.camera,
    AppPermission.photos: ph.Permission.photos,
    AppPermission.location: ph.Permission.locationWhenInUse,
    AppPermission.microphone: ph.Permission.microphone,
    AppPermission.contacts: ph.Permission.contacts,
    AppPermission.calendar: ph.Permission.calendarFullAccess,
    AppPermission.reminders: ph.Permission.reminders,
    AppPermission.notifications: ph.Permission.notification,
    AppPermission.storage: ph.Permission.storage,
  };

  static Future<ph.PermissionStatus> check(AppPermission type) async {
    try {
      return await _map[type]!.status;
    } on PlatformException {
      return ph.PermissionStatus.denied;
    }
  }

  static Future<ph.PermissionStatus> request(AppPermission type) async {
    try {
      return await _map[type]!.request();
    } on PlatformException {
      return ph.PermissionStatus.denied;
    }
  }

  static Future<bool> isGranted(AppPermission type) async =>
      (await check(type)).isGranted;

  static Future<bool> isPermanentlyDenied(AppPermission type) async =>
      (await check(type)).isPermanentlyDenied;

  /// Opens the OS app settings screen.
  static Future<bool> openSettings() => ph.openAppSettings();

  static Future<Map<AppPermission, ph.PermissionStatus>> requestMany(
    List<AppPermission> types,
  ) async {
    final permissions = types.map((t) => _map[t]!).toList();
    final results = await permissions.request();
    return {
      for (final type in types) type: results[_map[type]!]!,
    };
  }

  static String rationaleMessage(AppPermission type) {
    return switch (type) {
      AppPermission.camera =>
        'This app needs camera access to take photos and scan QR codes.',
      AppPermission.photos =>
        'This app needs photo library access to save and share images.',
      AppPermission.location =>
        'This app needs location access for location-based features.',
      AppPermission.microphone =>
        'This app needs microphone access for voice features.',
      AppPermission.contacts =>
        'This app needs contacts access to help you connect with others.',
      AppPermission.calendar =>
        'This app needs calendar access to sync events.',
      AppPermission.reminders =>
        'This app needs reminders access to manage reminders.',
      AppPermission.notifications =>
        'This app needs notification access to send important updates.',
      AppPermission.storage =>
        'This app needs storage access to save files.',
    };
  }

  static String deniedMessage(AppPermission type) {
    return switch (type) {
      AppPermission.camera =>
        'Camera access is required. Please enable it in settings.',
      AppPermission.photos =>
        'Photo library access is required. Please enable it in settings.',
      AppPermission.location =>
        'Location access is required. Please enable it in settings.',
      AppPermission.microphone =>
        'Microphone access is required. Please enable it in settings.',
      AppPermission.contacts =>
        'Contacts access is required. Please enable it in settings.',
      AppPermission.calendar =>
        'Calendar access is required. Please enable it in settings.',
      AppPermission.reminders =>
        'Reminders access is required. Please enable it in settings.',
      AppPermission.notifications =>
        'Notification access is required. Please enable it in settings.',
      AppPermission.storage =>
        'Storage access is required. Please enable it in settings.',
    };
  }

  /// Requests [type], showing a short rationale / settings dialog when needed.
  static Future<void> ensure(
    BuildContext context,
    AppPermission type, {
    required VoidCallback onGranted,
    VoidCallback? onDenied,
  }) async {
    if (await isGranted(type)) {
      onGranted();
      return;
    }

    final status = await check(type);
    if (!context.mounted) return;
    
    if (status.isDenied || status.isLimited) {
      final allowed = await _showRationaleDialog(context, type);
      if (!context.mounted) return;
      if (!allowed) {
        onDenied?.call();
        return;
      }
    }

    final result = await request(type);
    if (!context.mounted) return;

    if (result.isGranted) {
      onGranted();
      return;
    }

    onDenied?.call();
    await _showSettingsDialog(context, type);
  }

  static Future<bool> _showRationaleDialog(
    BuildContext context,
    AppPermission type,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(rationaleMessage(type)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> _showSettingsDialog(
    BuildContext context,
    AppPermission type,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(deniedMessage(type)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}