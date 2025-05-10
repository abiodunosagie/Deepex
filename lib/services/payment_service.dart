class PaymentService {
  Future<bool> processPayment(double amount) async {
    // Simulating payment processing
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
