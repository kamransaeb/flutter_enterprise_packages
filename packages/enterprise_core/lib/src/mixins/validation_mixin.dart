import 'package:flutter/material.dart';

/// Form-field registry helpers for a [State] that owns input fields.
mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  final Map<String, GlobalKey<FormFieldState<dynamic>>> _formFields = {};

  /// Registers a form field under [key] for later validation and access.
  void registerFormField(
    String key,
    GlobalKey<FormFieldState<dynamic>> fieldKey,
  ) {
    _formFields[key] = fieldKey;
  }

  /// Validates the field registered as [key]; returns `true` if missing.
  bool validateFormField(String key) {
    final field = _formFields[key];
    if (field == null) return true;

    return field.currentState?.validate() ?? true;
  }

  /// Validates every registered field; returns `true` only if all pass.
  bool validateAllFormFields() {
    var isValid = true;

    for (final field in _formFields.values) {
      if (!(field.currentState?.validate() ?? true)) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// Resets the field registered as [key].
  void resetFormField(String key) {
    _formFields[key]?.currentState?.reset();
  }

  /// Resets every registered form field.
  void resetAllFormFields() {
    for (final field in _formFields.values) {
      field.currentState?.reset();
    }
  }

  /// Saves the field registered as [key].
  void saveFormField(String key) {
    _formFields[key]?.currentState?.save();
  }

  /// Saves every registered form field.
  void saveAllFormFields() {
    for (final field in _formFields.values) {
      field.currentState?.save();
    }
  }

  /// Current value of the field registered as [key], if any.
  dynamic getFormFieldValue(String key) {
    return _formFields[key]?.currentState?.value;
  }

  /// Map of registered field keys to their current values.
  Map<String, dynamic> getAllFormFieldValues() {
    final values = <String, dynamic>{};

    for (final entry in _formFields.entries) {
      values[entry.key] = entry.value.currentState?.value;
    }

    return values;
  }

  /// Requests focus for the field registered as [key].
  void focusFormField(String key) {
    final field = _formFields[key];
    if (field != null) {
      final fieldContext = field.currentState?.context;
      if (fieldContext != null) {
        FocusScope.of(context).requestFocus(Focus.of(fieldContext));
      }
    }
  }

  /// Shows [error] in a snack bar and focuses the field for [key].
  void showFieldError(String key, String error) {
    final field = _formFields[key];
    if (field != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );

      focusFormField(key);
    }
  }

  /// Resets all fields (clears interaction/error state via [FormFieldState.reset]).
  void clearFormFieldErrors() {
    for (final field in _formFields.values) {
      field.currentState?.reset();
    }
  }

  /// Whether all registered fields currently validate successfully.
  bool isFormValid() {
    return validateAllFormFields();
  }

  /// Whether any registered field has been interacted with by the user.
  bool hasFormChanges() {
    for (final field in _formFields.values) {
      if (field.currentState?.hasInteractedByUser ?? false) {
        return true;
      }
    }
    return false;
  }

  /// Saves all fields when [hasFormChanges] is true.
  void autoSaveForm() {
    if (hasFormChanges()) {
      saveAllFormFields();
    }
  }

  /// Returns a map of field keys to their current error messages.
  Map<String, String> getFormErrors() {
    final errors = <String, String>{};

    for (final entry in _formFields.entries) {
      final field = entry.value.currentState;
      if (field?.hasError ?? false) {
        errors[entry.key] = field!.errorText ?? 'Invalid field';
      }
    }

    return errors;
  }

  /// Re-validates all fields so invalid ones surface their errors.
  void highlightInvalidFields() {
    for (final entry in _formFields.entries) {
      final field = entry.value.currentState;
      if (!(field?.validate() ?? true)) {
        // Visual feedback can be added by the host widget.
      }
    }
  }
}

/// Stateless string validators suitable for [FormField.validator].
mixin FormValidationMixin {
  /// Requires a non-empty [value].
  String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Requires a non-empty email-shaped [value].
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Requires a strong password in [value].
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Requires a non-empty phone-shaped [value].
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Requires [value] length to be at least [minLength].
  String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Requires [value] length to be at most [maxLength].
  String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must be at most $maxLength characters';
    }
    return null;
  }

  /// Requires [value1] and [value2] to be equal.
  String? validateMatch(String? value1, String? value2, {String? fieldName}) {
    if (value1 != value2) {
      return '${fieldName ?? 'Fields'} do not match';
    }
    return null;
  }

  /// Requires [value] to parse as a number.
  String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} must be a number';
    }

    return null;
  }

  /// Requires [value] to be a number greater than zero.
  String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numericError = validateNumeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    if (double.parse(value!) <= 0) {
      return '${fieldName ?? 'Number'} must be positive';
    }

    return null;
  }

  /// Requires [value] to look like a URL.
  String? validateUrl(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'URL'} is required';
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Requires [value] to parse as an ISO-8601 date.
  String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }

    try {
      DateTime.parse(value);
      return null;
    } on FormatException {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  /// Requires [value] to pass a Luhn check as a card number.
  String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!_isValidLuhn(cleaned)) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  bool _isValidLuhn(String number) {
    var sum = 0;
    var alternate = false;

    for (var i = number.length - 1; i >= 0; i--) {
      var digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  /// Requires [value] as `MM/YY` and not expired.
  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    if (!expiryRegex.hasMatch(value)) {
      return 'Please enter a valid expiry date (MM/YY)';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]) + 2000;

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0);

    if (expiryDate.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  /// Requires [value] to be a 3–4 digit CVV.
  String? validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    final cvvRegex = RegExp(r'^[0-9]{3,4}$');
    if (!cvvRegex.hasMatch(value)) {
      return 'Please enter a valid CVV (3-4 digits)';
    }

    return null;
  }

  /// Runs [validators] in order and returns the first error, if any.
  FormFieldValidator<T> composeValidators<T>(
    List<FormFieldValidator<T>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
