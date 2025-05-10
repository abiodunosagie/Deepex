class ErrorUtils {
  static String parseErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else if (error is Map && error.containsKey('message')) {
      return error['message'];
    }
    return 'Something went wrong. Please try again.';
  }
}
