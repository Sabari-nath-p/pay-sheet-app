import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find<FirebaseService>();

  late FirebaseRemoteConfig _remoteConfig;

  // Remote config keys
  static const String _keyAppVersion = 'app_version';
  static const String _keyPlayStoreUrl = 'playstore_url';
  static const String _keyAppStoreUrl = 'appstore_url';
  static const String _keyForceUpdate = 'force_update';

  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Initialize Remote Config
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _setupRemoteConfig();

      // Initialize Analytics

      print('Firebase services initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  Future<void> _setupRemoteConfig() async {
    try {
      // Set config settings with more aggressive fetching for debugging
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: const Duration(
            seconds: 0,
          ), // Allow immediate fetching for debugging
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults({
        _keyAppVersion: '1.0.0',
        _keyPlayStoreUrl:
            'https://play.google.com/store/apps/details?id=com.paysheet.app',
        _keyAppStoreUrl: 'https://apps.apple.com/app/paysheet-app/id123456789',
        _keyForceUpdate: false,
      });

      print('Remote Config defaults set');

      // Fetch and activate config
      bool activated = await _remoteConfig.fetchAndActivate();
      print('Remote Config fetch and activate result: $activated');

      if (!activated) {
        print('Failed to fetch and activate remote config. Using defaults.');
        // Try to activate what we have
        bool activateResult = await _remoteConfig.activate();
        print('Activate existing config result: $activateResult');
      }

      // Print current values for debugging
      print('Current remote config values:');
      print('  app_version: ${_remoteConfig.getString(_keyAppVersion)}');
      print('  force_update: ${_remoteConfig.getBool(_keyForceUpdate)}');
      print('  last_fetch_status: ${_remoteConfig.lastFetchStatus}');
      print('  last_fetch_time: ${_remoteConfig.lastFetchTime}');

      print('Remote Config setup completed');
    } catch (e) {
      print('Error setting up Remote Config: $e');
    }
  }

  // Get remote config values
  String get latestAppVersion => _remoteConfig.getString(_keyAppVersion);
  String get playStoreUrl => _remoteConfig.getString(_keyPlayStoreUrl);
  String get appStoreUrl => _remoteConfig.getString(_keyAppStoreUrl);
  bool get isForceUpdateEnabled => _remoteConfig.getBool(_keyForceUpdate);

  // Manually refresh remote config
  Future<bool> refreshRemoteConfig() async {
    try {
      print('Attempting to refresh remote config...');

      // First try to fetch
      await _remoteConfig.fetch();
      print('Fetch completed. Status: ${_remoteConfig.lastFetchStatus}');

      // Then activate
      bool activated = await _remoteConfig.activate();
      print('Activate result: $activated');

      if (activated) {
        print('Remote config refreshed successfully');
        print('Updated values:');
        print('  app_version: ${_remoteConfig.getString(_keyAppVersion)}');
        print('  force_update: ${_remoteConfig.getBool(_keyForceUpdate)}');
      } else {
        print('Activation failed - using existing values');
      }

      return activated;
    } catch (e) {
      print('Error refreshing remote config: $e');
      return false;
    }
  }

  // Get current remote config status
  Map<String, dynamic> getRemoteConfigStatus() {
    return {
      'app_version': _remoteConfig.getString(_keyAppVersion),
      'playstore_url': _remoteConfig.getString(_keyPlayStoreUrl),
      'appstore_url': _remoteConfig.getString(_keyAppStoreUrl),
      'force_update': _remoteConfig.getBool(_keyForceUpdate),
      'last_fetch_time': _remoteConfig.lastFetchTime.toString(),
      'last_fetch_status': _remoteConfig.lastFetchStatus.toString(),
    };
  }

  // Comprehensive debug method
  Future<void> debugFirebaseSetup() async {
    print('=== Firebase Debug Information ===');

    try {
      // Check if Firebase is initialized
      print('Firebase Apps: ${Firebase.apps.map((app) => app.name).toList()}');

      // Check remote config status
      print('Remote Config Status:');
      print('  Last fetch time: ${_remoteConfig.lastFetchTime}');
      print('  Last fetch status: ${_remoteConfig.lastFetchStatus}');

      // Try to get all parameter keys
      print('All Remote Config parameters:');
      Map<String, RemoteConfigValue> allParameters = _remoteConfig.getAll();
      allParameters.forEach((key, value) {
        print('  $key: ${value.asString()} (source: ${value.source})');
      });

      // Test fetch
      print('Testing fetch...');
      await _remoteConfig.fetch();
      print('Fetch completed. New status: ${_remoteConfig.lastFetchStatus}');

      // Test activate
      print('Testing activate...');
      bool activated = await _remoteConfig.activate();
      print('Activate result: $activated');
    } catch (e) {
      print('Debug error: $e');
    }

    print('=== End Debug Information ===');
  }

  // Check if app update is required
  Future<UpdateInfo> checkForUpdate() async {
    try {
      print('Starting update check...');

      // Fetch latest config and activate it
      bool fetchResult = await _remoteConfig.fetchAndActivate();
      print('fetchAndActivate result: $fetchResult');

      if (!fetchResult) {
        print('Fetch failed, trying separate fetch and activate...');
        await _remoteConfig.fetch();
        print('Fetch status: ${_remoteConfig.lastFetchStatus}');

        bool activateResult = await _remoteConfig.activate();
        print('Activate result: $activateResult');
      }

      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Get remote version
      String remoteVersion = _remoteConfig.getString(_keyAppVersion);
      bool forceUpdate = _remoteConfig.getBool(_keyForceUpdate);

      print('Retrieved values:');
      print('  Current version: $currentVersion');
      print('  Remote version: $remoteVersion');
      print('  Force update: $forceUpdate');

      // Compare versions
      bool updateRequired = _isUpdateRequired(currentVersion, remoteVersion);

      print('Version comparison result: $updateRequired');

      return UpdateInfo(
        isUpdateRequired: updateRequired,
        isForceUpdate: forceUpdate && updateRequired,
        currentVersion: currentVersion,
        latestVersion: remoteVersion,
        playStoreUrl: _remoteConfig.getString(_keyPlayStoreUrl),
        appStoreUrl: _remoteConfig.getString(_keyAppStoreUrl),
      );
    } catch (e) {
      print('Error checking for update: $e');
      // Return default values in case of error
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      return UpdateInfo(
        isUpdateRequired: false,
        isForceUpdate: false,
        currentVersion: currentVersion,
        latestVersion: currentVersion,
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.paysheet.app',
        appStoreUrl: 'https://apps.apple.com/app/paysheet-app/id123456789',
      );
    }
  }

  // Compare version strings (basic implementation)
  bool _isUpdateRequired(String currentVersion, String remoteVersion) {
    try {
      List<int> current = currentVersion.split('.').map(int.parse).toList();
      List<int> remote = remoteVersion.split('.').map(int.parse).toList();

      // Ensure both versions have the same length
      while (current.length < remote.length) current.add(0);
      while (remote.length < current.length) remote.add(0);

      for (int i = 0; i < current.length; i++) {
        if (remote[i] > current[i]) return true;
        if (remote[i] < current[i]) return false;
      }

      return false; // Versions are equal
    } catch (e) {
      print('Error comparing versions: $e');
      return false;
    }
  }

  // Log analytics events
  Future<void> logEvent(
    String eventName,
    Map<String, Object>? parameters,
  ) async {
    try {} catch (e) {
      print('Error logging analytics event: $e');
    }
  }

  // Log user properties
  Future<void> setUserProperty(String name, String value) async {
    try {} catch (e) {
      print('Error setting user property: $e');
    }
  }
}

class UpdateInfo {
  final bool isUpdateRequired;
  final bool isForceUpdate;
  final String currentVersion;
  final String latestVersion;
  final String playStoreUrl;
  final String appStoreUrl;

  UpdateInfo({
    required this.isUpdateRequired,
    required this.isForceUpdate,
    required this.currentVersion,
    required this.latestVersion,
    required this.playStoreUrl,
    required this.appStoreUrl,
  });

  @override
  String toString() {
    return 'UpdateInfo(isUpdateRequired: $isUpdateRequired, isForceUpdate: $isForceUpdate, currentVersion: $currentVersion, latestVersion: $latestVersion)';
  }
}
