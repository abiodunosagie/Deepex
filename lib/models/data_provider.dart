import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/data_model.dart';

final dataProvider = StateNotifierProvider<DataNotifier, DataModel?>((ref) {
  return DataNotifier();
});

class DataNotifier extends StateNotifier<DataModel?> {
  DataNotifier() : super(null);

  void updateData(DataModel data) {
    state = data;
  }
}
