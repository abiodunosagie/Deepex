import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/airtime_model.dart';

final airtimeProvider = StateNotifierProvider<AirtimeNotifier, AirtimeModel?>((ref) {
  return AirtimeNotifier();
});

class AirtimeNotifier extends StateNotifier<AirtimeModel?> {
  AirtimeNotifier() : super(null);

  void updateAirtime(AirtimeModel airtime) {
    state = airtime;
  }
}
