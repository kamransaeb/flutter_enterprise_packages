import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
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

class PermissionHelper {
  static Map<PermissionType, Permission> _permissionMap = {
    PermissionType.camera: Permission.camera,
    PermissionType.photos: Permission.photos,
    PermissionType.location: Permission.locationWhenInUse,
    PermissionType.microphone: Permission.microphone,
    PermissionType.contacts: Permission.contacts,
    PermissionType.calendar: Permission.calendar,
    PermissionType.reminders: Permission.reminders,
    PermissionType.notifications: Permission.notification,
    PermissionType.storage: Permission.storage,
  };

  static Future<PermissionStatus> checkPermission(PermissionType type) async {
    try {
      final permission = _permissionMap[type];
      if (permission == null) {
        return PermissionStatus.denied;
      }
      return await permission.status;
    } on PlatformException catch (e) {
      print('Error checking permission: $e');
      return PermissionStatus.denied;
    }
  }

  static Future<PermissionStatus> requestPermission(PermissionType type) async {
    try {
      final permission = _permissionMap[type];
      if (permission == null) {
        return PermissionStatus.denied;
      }
      return await permission.request();
    } on PlatformException catch (e) {
      print('Error requesting permission: $e');
      return PermissionStatus.denied;
    }
  }

  static Future<bool> isGranted(PermissionType type) async {
    final status = await checkPermission(type);
    return status.isGranted;
  }

  static Future<bool> isPermanentlyDenied(PermissionType type) async {
    final status = await checkPermission(type);
    return status.isPermanentlyDenied;
  }

  static Future<bool> shouldShowRequestRationale(PermissionType type) async {
    final status = await checkPermission(type);
    return status.isLimited || status.isDenied;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  static Future<Map<PermissionType, PermissionStatus>> checkMultiplePermissions(
    List<PermissionType> types,
  ) async {
    final results = <PermissionType, PermissionStatus>{};
    
    for (final type in types) {
      final status = await checkPermission(type);
      results[type] = status;
    }
    
    return results;
  }

  static Future<Map<PermissionType, PermissionStatus>> requestMultiplePermissions(
    List<PermissionType> types,
  ) async {
    final permissions = types
        .map((type) => _permissionMap[type])
        .whereType<Permission>()
        .toList();
    
    final results = await permissions.request();
    final mappedResults = <PermissionType, PermissionStatus>{};
    
    for (final entry in results.entries) {
      final type = _permissionMap.entries
          .firstWhere((e) => e.value == entry.key)
          .key;
      mappedResults[type] = entry.value;
    }
    
    return mappedResults;
  }

  static String getPermissionRationaleMessage(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return 'This app needs camera access to take photos and scan QR codes.';
      case PermissionType.photos:
        return 'This app needs photo library access to save and share images.';
      case PermissionType.location:
        return 'This app needs location access to show nearby services and provide location-based features.';
      case PermissionType.microphone:
        return 'This app needs microphone access for voice recording and audio calls.';
      case PermissionType.contacts:
        return 'This app needs contacts access to help you connect with friends.';
      case PermissionType.calendar:
        return 'This app needs calendar access to sync events and reminders.';
      case PermissionType.reminders:
        return 'This app needs reminders access to create and manage reminders.';
      case PermissionType.notifications:
        return 'This app needs notification access to send you important updates.';
      case PermissionType.storage:
        return 'This app needs storage access to save files and documents.';
    }
  }

  static String getPermissionDeniedMessage(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return 'Camera access is required for this feature. Please enable it in settings.';
      case PermissionType.photos:
        return 'Photo library access is required for this feature. Please enable it in settings.';
      case PermissionType.location:
        return 'Location access is required for this feature. Please enable it in settings.';
      case PermissionType.microphone:
        return 'Microphone access is required for this feature. Please enable it in settings.';
      case PermissionType.contacts:
        return 'Contacts access is required for this feature. Please enable it in settings.';
      case PermissionType.calendar:
        return 'Calendar access is required for this feature. Please enable it in settings.';
      case PermissionType.reminders:
        return 'Reminders access is required for this feature. Please enable it in settings.';
      case PermissionType.notifications:
        return 'Notification access is required for this feature. Please enable it in settings.';
      case PermissionType.storage:
        return 'Storage access is required for this feature. Please enable it in settings.';
    }
  }

  static Future<void> showPermissionDialog(
    BuildContext context,
    PermissionType type, {
    required VoidCallback onGranted,
    VoidCallback? onDenied,
  }) async {
    final isGranted = await PermissionHelper.isGranted(type);
    
    if (isGranted) {
      onGranted();
      return;
    }

    final shouldShowRationale = await PermissionHelper.shouldShowRequestRationale(type);
    
    if (shouldShowRationale) {
      await _showRationaleDialog(context, type, onGranted, onDenied);
    } else {
      final status = await PermissionHelper.requestPermission(type);
      
      if (status.isGranted) {
        onGranted();
      } else {
        onDenied?.call();
        await _showSettingsDialog(context, type);
      }
    }
  }

  static Future<void> _showRationaleDialog(
    BuildContext context,
    PermissionType type,
    VoidCallback onGranted,
    VoidCallback? onDenied,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(getPermissionRationaleMessage(type)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDenied?.call();
            },
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final status = await PermissionHelper.requestPermission(type);
              
              if (status.isGranted) {
                onGranted();
              } else {
                onDenied?.call();
                await _showSettingsDialog(context, type);
              }
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showSettingsDialog(
    BuildContext context,
    PermissionType type,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(getPermissionDeniedMessage(type)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await PermissionHelper.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}