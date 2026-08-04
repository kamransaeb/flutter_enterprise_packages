import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base file operation exception
class FileException extends AppException {
  /// Creates a [FileException].
  const FileException({
    required super.message,
    super.code = 'FILE_ERROR',
    super.stackTrace,
    super.details,
    this.path,
    this.fileName,
    super.severity = ErrorSeverity.medium,
  });

  /// File path that caused the error
  final String? path;

  /// File name that caused the error
  final String? fileName;
}

/// File not found exception
class FileNotFoundException extends FileException {
  /// Creates a [FileNotFoundException].
  const FileNotFoundException({
    super.message = 'File not found.',
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'FILE_NOT_FOUND',
         severity: ErrorSeverity.low,
       );
}

/// File already exists exception
class FileAlreadyExistsException extends FileException {
  /// Creates a [FileAlreadyExistsException].
  const FileAlreadyExistsException({
    super.message = 'File already exists.',
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'FILE_ALREADY_EXISTS',
         severity: ErrorSeverity.low,
       );
}

/// File read exception
class FileReadException extends FileException {
  /// Creates a [FileReadException].
  const FileReadException({
    required super.message,
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'FILE_READ_ERROR',
         severity: ErrorSeverity.medium,
       );
}

/// File write exception
class FileWriteException extends FileException {
  /// Creates a [FileWriteException].
  const FileWriteException({
    required super.message,
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'FILE_WRITE_ERROR',
         severity: ErrorSeverity.medium,
       );
}

/// File delete exception
class FileDeleteException extends FileException {
  /// Creates a [FileDeleteException].
  const FileDeleteException({
    required super.message,
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         code: 'FILE_DELETE_ERROR',
         severity: ErrorSeverity.low,
       );
}

/// Insufficient storage space
class InsufficientStorageException extends FileException {
  /// Creates an [InsufficientStorageException].
  const InsufficientStorageException({
    super.message = 'Insufficient storage space.',
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
    this.requiredSpace,
    this.availableSpace,
  }) : super(
         code: 'INSUFFICIENT_STORAGE',
         severity: ErrorSeverity.medium,
       );

  /// Space required for operation
  final int? requiredSpace;

  /// Available space on device
  final int? availableSpace;
}

/// File too large exception
class FileTooLargeException extends FileException {
  /// Creates a [FileTooLargeException].
  FileTooLargeException({
    required this.fileSize,
    required this.maxSize,
    String message = 'File size exceeds limit.',
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         message:
             '$message (${_formatSize(fileSize)} / ${_formatSize(maxSize)})',
         code: 'FILE_TOO_LARGE',
         severity: ErrorSeverity.low,
       );

  /// Actual file size
  final int fileSize;

  /// Maximum allowed size
  final int maxSize;

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Unsupported file type exception
class UnsupportedFileTypeException extends FileException {
  /// Creates an [UnsupportedFileTypeException].
  UnsupportedFileTypeException({
    required this.fileType,
    required this.supportedTypes,
    String message = 'File type not supported.',
    super.path,
    super.fileName,
    super.stackTrace,
    super.details,
  }) : super(
         message:
             '$message: $fileType. Supported: ${supportedTypes.join(', ')}',
         code: 'UNSUPPORTED_FILE_TYPE',
         severity: ErrorSeverity.low,
       );

  /// Actual file type
  final String fileType;

  /// List of supported file types
  final List<String> supportedTypes;
}
