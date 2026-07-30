import 'dart:math';

import 'package:collection/collection.dart';

extension ListExtensions<T> on List<T> {
  // Null safety
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => !isEmpty;
  bool get isBlank => isEmpty;
  bool get isNotBlank => !isEmpty;

  // Safe access
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  // Transformation
  List<R> mapIndexed<R>(R Function(int index, T element) transform) {
    final result = <R>[];
    for (var i = 0; i < length; i++) {
      result.add(transform(i, this[i]));
    }
    return result;
  }

  List<T> whereIndexed(bool Function(int index, T element) test) {
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (test(i, this[i])) {
        result.add(this[i]);
      }
    }
    return result;
  }

  // Sorting
  List<T> sortedBy<R extends Comparable>(R Function(T) selector) {
    return [...this]..sort((a, b) => selector(a).compareTo(selector(b)));
  }

  List<T> sortedByDescending<R extends Comparable>(R Function(T) selector) {
    return [...this]..sort((a, b) => selector(b).compareTo(selector(a)));
  }

  // Grouping
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  // Partition
  List<List<T>> chunked(int size) {
    if (size <= 0) return [];
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      result.add(sublist(i, end));
    }
    return result;
  }

  // Distinct
  List<T> distinct() {
    final set = <T>{};
    return where((element) => set.add(element)).toList();
  }

  List<T> distinctBy<K>(K Function(T) selector) {
    final set = <K>{};
    return where((element) => set.add(selector(element))).toList();
  }

  // Searching
  int? firstIndexWhere(bool Function(T) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return i;
    }
    return null;
  }

  int? lastIndexWhere(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return i;
    }
    return null;
  }

  // Safe operations
  List<T> addOrUpdate(T item, bool Function(T) predicate) {
    final index = indexWhere(predicate);
    if (index != -1) {
      final newList = [...this];
      newList[index] = item;
      return newList;
    } else {
      return [...this, item];
    }
  }

  List<T> removeWhereSafe(bool Function(T) test) {
    return where((element) => !test(element)).toList();
  }

  // Pagination
  List<T> paginate(int page, int pageSize) {
    final start = (page - 1) * pageSize;
    if (start >= length) return [];
    final end = (start + pageSize) > length ? length : start + pageSize;
    return sublist(start, end);
  }

  // Statistics
  T? minBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }

  T? maxBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }

  num sumBy(num Function(T) selector) {
    return fold(0, (sum, element) => sum + selector(element));
  }

  double averageBy(num Function(T) selector) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }

  // Joining
  String joinWithIndex(String separator, String Function(int index, T item) transform) {
    if (isEmpty) return '';
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      if (i > 0) buffer.write(separator);
      buffer.write(transform(i, this[i]));
    }
    return buffer.toString();
  }

  // Flattening
  List<R> flatten<R>(List<R> Function(T) transform) {
    final result = <R>[];
    for (final element in this) {
      result.addAll(transform(element));
    }
    return result;
  }

  // Batch updates
  List<T> updateAll(T Function(T) update) {
    return map(update).toList();
  }

  List<T> updateWhere(bool Function(T) test, T Function(T) update) {
    return map((item) => test(item) ? update(item) : item).toList();
  }

  // Sampling
  List<T> sample(int count) {
    if (count >= length) return [...this];
    final shuffled = [...this]..shuffle();
    return shuffled.take(count).toList();
  }

  T? random() {
    if (isEmpty) return null;
    final random = Random();
    return this[random.nextInt(length)];
  }

  // Intersection & Union
  List<T> intersect(List<T> other) {
    final set = other.toSet();
    return where(set.contains).toList();
  }

  List<T> union(List<T> other) {
    return [...toSet(), ...other.toSet()].toList();
  }

  List<T> difference(List<T> other) {
    final set = other.toSet();
    return where((element) => !set.contains(element)).toList();
  }
}