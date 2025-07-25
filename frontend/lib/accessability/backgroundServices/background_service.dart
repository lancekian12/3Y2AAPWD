import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_updates',
      initialNotificationTitle: 'Location Updates',
      initialNotificationContent: 'Tracking your location in the background',
      foregroundServiceNotificationId: 1,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: "Location Tracking",
        content: "Your location is being updated.",
      );
      service.setAsForegroundService();
    }

    // Check if the user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      service.invoke('stopService');
      return;
    }

    // Initialize location service
    final location = Location();

    // Listen for location updates
    location.onLocationChanged.listen((LocationData locationData) async {
      await FirebaseFirestore.instance
          .collection('UserLocations')
          .doc(user.uid)
          .set({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'timestamp': DateTime.now(),
      });

      service.invoke('update', {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      });
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Keep alive
    while (service is AndroidServiceInstance &&
        await service.isForegroundService()) {
      await Future.delayed(Duration(seconds: 5));
    }
  } catch (e) {
    print('Error in background service: $e');
  }
}
