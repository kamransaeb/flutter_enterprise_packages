import 'package:formz/formz.dart';

/// Validation error for [UrlInput].
enum UrlValidationError {
  /// The URL is invalid.
  invalid,
}

/// A URL input.
class UrlInput extends FormzInput<String, UrlValidationError> {
  /// Creates a [UrlInput] in a pure state.
  const UrlInput.pure() : super.pure('');

  /// Creates a [UrlInput] in a dirty state.
  const UrlInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _urlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\/\S*)?',
    caseSensitive: false,
  );

  @override
  UrlValidationError? validator(String? value) {
    return (value == null || value == '')
        ? null
        : _urlRegExp.hasMatch(value)
        ? null
        : UrlValidationError.invalid;
  }
}
