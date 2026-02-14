import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StreamProvider<bool>((ref) {

  final connectivity = Connectivity();

  /// Listen to internet changes
  return connectivity.onConnectivityChanged.map((result) {

    /// latest connectivity_plus returns List<ConnectivityResult>
    final isOnline = !result.contains(ConnectivityResult.none);

    return isOnline;

  });
});
