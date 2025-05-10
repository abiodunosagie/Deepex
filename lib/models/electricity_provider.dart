import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/electricity_bill_model.dart';

final electricityProvider = StateNotifierProvider<ElectricityNotifier, ElectricityBillModel?>((ref) {
  return ElectricityNotifier();
});

class ElectricityNotifier extends StateNotifier<ElectricityBillModel?> {
  ElectricityNotifier() : super(null);

  void updateElectricity(ElectricityBillModel bill) {
    state = bill;
  }
}
