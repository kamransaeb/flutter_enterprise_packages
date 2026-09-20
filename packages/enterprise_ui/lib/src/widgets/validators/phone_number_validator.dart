import 'package:formz/formz.dart';

/// Validation error for [PhoneNumberValidator].
enum PhoneNumberValidationError {
  /// The field is empty.
  empty,

  /// The value contains non-digit characters.
  invalid,

  /// The phone number is too short.
  tooShort,
}

/// A phone number validator.
class PhoneNumberValidator
    extends FormzInput<String, PhoneNumberValidationError> {
  /// Creates a [PhoneNumberValidator].
  const PhoneNumberValidator.pure() : super.pure('');

  /// Creates a [PhoneNumberValidator] in a dirty state.
  const PhoneNumberValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]+$');

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneNumberValidationError.empty;
    }
    if (!_phoneNumberRegExp.hasMatch(value)) {
      return PhoneNumberValidationError.invalid;
    }
    return value.length >= 9 ? null : PhoneNumberValidationError.tooShort;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `phone_number_required`
  /// - `phone_number_invalid`
  /// - `phone_number_too_short`
  static String? getErrorMessage(PhoneNumberValidationError? error) {
    return switch (error) {
      PhoneNumberValidationError.empty => 'phone_number_required',
      PhoneNumberValidationError.invalid =>
        'phone_number_invalid',
      PhoneNumberValidationError.tooShort =>
        'phone_number_too_short',
      null => null,
    };
  }
}
