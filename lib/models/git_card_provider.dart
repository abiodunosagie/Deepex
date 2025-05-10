import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gift_card_model.dart';

final giftCardProvider = StateNotifierProvider<GiftCardNotifier, GiftCardModel?>((ref) {
  return GiftCardNotifier();
});

class GiftCardNotifier extends StateNotifier<GiftCardModel?> {
  GiftCardNotifier() : super(null);

  void updateGiftCard(GiftCardModel giftCard) {
    state = giftCard;
  }
}
