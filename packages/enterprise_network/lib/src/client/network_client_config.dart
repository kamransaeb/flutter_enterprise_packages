/// Configuration for the network client
class NetworkClientConfig {
    /// Constructor for the NetworkClientConfig class
  const NetworkClientConfig ({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.enableLogging = true,
    this.validateStatusBelow = 500,
  });

  /// Base URL for the API
  final String baseUrl;
  /// Timeout for connecting to the server
  final Duration connectTimeout;
  /// Timeout for receiving responses
  final Duration receiveTimeout;
  /// Timeout for sending requests
  final Duration sendTimeout;
  /// Default headers to be sent with each request
  final Map<String, dynamic> defaultHeaders;
  /// Enable logging of requests and responses
  final bool enableLogging;
  /// Treat status codes below this as non-throwing at Dio level
  /// (app/error interceptor decides how to handle 4xx).
  final int validateStatusBelow;
}
