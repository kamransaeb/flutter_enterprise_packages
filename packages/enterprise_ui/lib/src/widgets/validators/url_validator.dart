import 'package:formz/formz.dart';

/// Validation error for [UrlValidator].
enum UrlValidationError {
  /// The value is not a valid URL.
  invalid,
}

/// A URL validator.
///
/// Empty values are allowed (optional field).
class UrlValidator extends FormzInput<String, UrlValidationError> {
  /// Creates a [UrlValidator] in a pure state.
  const UrlValidator.pure() : super.pure('');

  /// Creates a [UrlValidator] in a dirty state.
  const UrlValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _urlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\/\S*)?',
    caseSensitive: false,
  );

  @override
  UrlValidationError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    return _urlRegExp.hasMatch(value) ? null : UrlValidationError.invalid;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `url_invalid`
  static String? getErrorMessage(UrlValidationError? error) {
    return switch (error) {
      UrlValidationError.invalid => 'url_invalid',
      null => null,
    };
  }
}
