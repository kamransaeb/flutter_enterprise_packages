import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base payment exception
class PaymentException extends AppException {
  /// Creates a [PaymentException].
  const PaymentException({
    required super.message,
    super.code = 'PAYMENT_ERROR',
    super.stackTrace,
    super.details,
    this.transactionId,
    this.paymentMethod,
    super.severity = ErrorSeverity.high,
  });

  /// Transaction identifier
  final String? transactionId;

  /// Payment method used
  final String? paymentMethod;
}

/// Payment declined exception
class PaymentDeclinedException extends PaymentException {
  /// Creates a [PaymentDeclinedException].
  const PaymentDeclinedException({
    required super.message,
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.declineReason,
  }) : super(         
         code: 'PAYMENT_DECLINED',
         severity: ErrorSeverity.medium,
       );

  /// Reason for decline from payment processor
  final String? declineReason;
}

/// Insufficient funds exception
class InsufficientFundsException extends PaymentException {
  /// Creates an [InsufficientFundsException].
  const InsufficientFundsException({
    super.message = 'Insufficient funds for this transaction.',
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.requiredAmount,
    this.availableAmount,
  }) : super(
         code: 'INSUFFICIENT_FUNDS',
         severity: ErrorSeverity.medium,
       );

  /// Amount required for transaction
  final double? requiredAmount;

  /// Amount available
  final double? availableAmount;
}

/// Payment processing exception
class PaymentProcessingException extends PaymentException {
  /// Creates a [PaymentProcessingException].
  const PaymentProcessingException({
    required super.message,
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.processingError,
  }) : super(
         code: 'PAYMENT_PROCESSING_ERROR',
         severity: ErrorSeverity.high,
       );

  /// Raw error from payment processor
  final String? processingError;
}

/// Payment timeout exception
class PaymentTimeoutException extends PaymentException {
  /// Creates a [PaymentTimeoutException].
  const PaymentTimeoutException({
    super.message = 'Payment processing timed out.',
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'PAYMENT_TIMEOUT',
         severity: ErrorSeverity.medium,
       );
}

/// Refund exception
class RefundException extends PaymentException {
  /// Creates a [RefundException].
  const RefundException({
    required super.message,
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.originalTransactionId,
  }) : super(
         code: 'REFUND_ERROR',
         severity: ErrorSeverity.high,
       );

  /// Original transaction being refunded
  final String? originalTransactionId;
}

/// Invalid payment method exception
class InvalidPaymentMethodException extends PaymentException {
  /// Creates an [InvalidPaymentMethodException].
  const InvalidPaymentMethodException({
    required String paymentMethod,
    String message = 'Invalid payment method.',
    super.transactionId,
    super.stackTrace,
    super.details,
  }) : super(
         message: '$message: $paymentMethod',
         code: 'INVALID_PAYMENT_METHOD',
         paymentMethod: paymentMethod,
         severity: ErrorSeverity.low,
       );
}

/// Subscription expired exception
class SubscriptionExpiredException extends PaymentException {
  /// Creates a [SubscriptionExpiredException].
  const SubscriptionExpiredException({
    super.message = 'Your subscription has expired.',
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.expirationDate,
  }) : super(
         code: 'SUBSCRIPTION_EXPIRED',
         severity: ErrorSeverity.medium,
       );

  /// Date when subscription expired
  final DateTime? expirationDate;
}

/// Subscription canceled exception
class SubscriptionCanceledException extends PaymentException {
  /// Creates a [SubscriptionCanceledException].
  const SubscriptionCanceledException({
    super.message = 'Your subscription has been canceled.',
    super.transactionId,
    super.paymentMethod,
    super.stackTrace,
    super.details,
    this.cancelDate,
  }) : super(
         code: 'SUBSCRIPTION_CANCELED',
         severity: ErrorSeverity.low,
       );

  /// Date when subscription was canceled
  final DateTime? cancelDate;
}
