import 'package:formz/formz.dart';

/// Validation error for [PhoneNumberInput].
enum PhoneNumberValidationError {
  /// The phone number is invalid.
  invalid,
}

/// A phone number input.
class PhoneNumberInput extends FormzInput<String, PhoneNumberValidationError> {
  /// Creates a [PhoneNumberInput].
  const PhoneNumberInput.pure() : super.pure('');

  /// Creates a [PhoneNumberInput] in a dirty state.
  const PhoneNumberInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^[0-9]+$',
  );

  @override
  PhoneNumberValidationError? validator(String? value) {
    return (_phoneNumberRegExp.hasMatch(value ?? '') &&
            (value ?? '').length >= 9)
        ? null
        : PhoneNumberValidationError.invalid;
  }
}
