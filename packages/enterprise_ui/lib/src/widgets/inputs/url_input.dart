import 'package:formz/formz.dart';

enum UrlValidationError {
  invalid,
}

class UrlInput extends FormzInput<String, UrlValidationError> {

  const UrlInput.pure() : super.pure('');

  const UrlInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _urlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\/\S*)?',
    caseSensitive: false,
  );

  @override
  UrlValidationError? validator(String? value) {
    return (value == null || value == '') ? null :
      _urlRegExp.hasMatch(value)
        ? null
        : UrlValidationError.invalid;
  }
  
}