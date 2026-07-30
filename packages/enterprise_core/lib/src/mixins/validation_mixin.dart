import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  final Map<String, GlobalKey<FormFieldState>> _formFields = {};

  void registerFormField(String key, GlobalKey<FormFieldState> fieldKey) {
    _formFields[key] = fieldKey;
  }

  bool validateFormField(String key) {
    final field = _formFields[key];
    if (field == null) return true;

    return field.currentState?.validate() ?? true;
  }

  bool validateAllFormFields() {
    bool isValid = true;

    for (final field in _formFields.values) {
      if (!(field.currentState?.validate() ?? true)) {
        isValid = false;
      }
    }

    return isValid;
  }

  void resetFormField(String key) {
    _formFields[key]?.currentState?.reset();
  }

  void resetAllFormFields() {
    for (final field in _formFields.values) {
      field.currentState?.reset();
    }
  }

  void saveFormField(String key) {
    _formFields[key]?.currentState?.save();
  }

  void saveAllFormFields() {
    for (final field in _formFields.values) {
      field.currentState?.save();
    }
  }

  dynamic getFormFieldValue(String key) {
    return _formFields[key]?.currentState?.value;
  }

  Map<String, dynamic> getAllFormFieldValues() {
    final values = <String, dynamic>{};

    for (final entry in _formFields.entries) {
      values[entry.key] = entry.value.currentState?.value;
    }

    return values;
  }

  void focusFormField(String key) {
    final field = _formFields[key];
    if (field != null) {
      final fieldContext = field.currentState?.context;
      if (fieldContext != null) {
        FocusScope.of(context).requestFocus(Focus.of(fieldContext));
      }
    }
  }

  void showFieldError(String key, String error) {
    final field = _formFields[key];
    if (field != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );

      // Optionally focus the field
      focusFormField(key);
    }
  }

  void clearFormFieldErrors() {
    for (final field in _formFields.values) {
      field.currentState?.reset();
    }
  }

  bool isFormValid() {
    return validateAllFormFields();
  }

  bool hasFormChanges() {
    for (final field in _formFields.values) {
      if (field.currentState?.hasInteractedByUser ?? false) {
        return true;
      }
    }
    return false;
  }

  void autoSaveForm() {
    if (hasFormChanges()) {
      saveAllFormFields();
    }
  }

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

  void highlightInvalidFields() {
    for (final entry in _formFields.entries) {
      final field = entry.value.currentState;
      if (!(field?.validate() ?? true)) {
        // You can add visual feedback here
        // For example, change border color or show error icon
      }
    }
  }
}

mixin FormValidationMixin {
  String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

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

  String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }
    return null;
  }

  String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must be at most $maxLength characters';
    }
    return null;
  }

  String? validateMatch(String? value1, String? value2, {String? fieldName}) {
    if (value1 != value2) {
      return '${fieldName ?? 'Fields'} do not match';
    }
    return null;
  }

  String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} must be a number';
    }

    return null;
  }

  String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numericError = validateNumeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    if (double.parse(value!) <= 0) {
      return '${fieldName ?? 'Number'} must be positive';
    }

    return null;
  }

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

  String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (_) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Luhn algorithm
    if (!_isValidLuhn(cleaned)) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

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
    final expiryDate = DateTime(year, month + 1, 0); // Last day of month

    if (expiryDate.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

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
