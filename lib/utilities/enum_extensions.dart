enum ApiStatus { initial, loading, success, error }

extension ApiStatusX on ApiStatus {
  bool get isLoading => this == ApiStatus.loading;
  bool get isSuccess => this == ApiStatus.success;
  bool get isError => this == ApiStatus.error;
}
