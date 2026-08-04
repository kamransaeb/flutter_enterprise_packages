import 'dart:math';

/// Convenience helpers for [List] access, transforms, and set-like ops.
extension ListExtensions<T> on List<T> {
  /// Whether this list has no elements.
  bool get isNullOrEmpty => isEmpty;

  /// Whether this list has one or more elements.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Whether this list is empty.
  bool get isBlank => isEmpty;

  /// Whether this list is not empty.
  bool get isNotBlank => isNotEmpty;

  /// Returns the element at [index], or `null` if out of range.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// The first element, or `null` if the list is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// The last element, or `null` if the list is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Maps each element with its index using [transform].
  List<R> mapIndexed<R>(R Function(int index, T element) transform) {
    final result = <R>[];
    for (var i = 0; i < length; i++) {
      result.add(transform(i, this[i]));
    }
    return result;
  }

  /// Filters elements with their index using [test].
  List<T> whereIndexed(bool Function(int index, T element) test) {
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (test(i, this[i])) {
        result.add(this[i]);
      }
    }
    return result;
  }

  /// Returns a new list sorted ascending by [selector].
  List<T> sortedBy<R extends Comparable<R>>(R Function(T) selector) {
    return [...this]..sort((a, b) => selector(a).compareTo(selector(b)));
  }

  /// Returns a new list sorted descending by [selector].
  List<T> sortedByDescending<R extends Comparable<R>>(R Function(T) selector) {
    return [...this]..sort((a, b) => selector(b).compareTo(selector(a)));
  }

  /// Groups elements by the key from [keySelector].
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Splits this list into sublists of at most [size] elements.
  List<List<T>> chunked(int size) {
    if (size <= 0) return [];
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      result.add(sublist(i, end));
    }
    return result;
  }

  /// Returns unique elements, preserving first-seen order.
  List<T> distinct() {
    final set = <T>{};
    return where(set.add).toList();
  }

  /// Returns elements unique by [selector], preserving first-seen order.
  List<T> distinctBy<K>(K Function(T) selector) {
    final set = <K>{};
    return where((element) => set.add(selector(element))).toList();
  }

  /// Index of the first element matching [test], or `null` if none.
  int? firstIndexWhere(bool Function(T) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return i;
    }
    return null;
  }

  /// Index of the last element matching [test], or `null` if none.
  int? findLastIndexWhere(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return i;
    }
    return null;
  }

  /// Replaces the first match of [predicate] with [item], or appends it.
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

  /// Returns a new list without elements that match [test].
  List<T> removeWhereSafe(bool Function(T) test) {
    return where((element) => !test(element)).toList();
  }

  /// Returns the [page]-th page of [pageSize] items (1-based page).
  List<T> paginate(int page, int pageSize) {
    final start = (page - 1) * pageSize;
    if (start >= length) return [];
    final end = (start + pageSize) > length ? length : start + pageSize;
    return sublist(start, end);
  }

  /// Element with the minimum [selector] value, or `null` if empty.
  T? minBy<R extends Comparable<R>>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }

  /// Element with the maximum [selector] value, or `null` if empty.
  T? maxBy<R extends Comparable<R>>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }

  /// Sum of values produced by [selector].
  num sumBy(num Function(T) selector) {
    return fold(0, (sum, element) => sum + selector(element));
  }

  /// Average of values produced by [selector], or `0` if empty.
  double averageBy(num Function(T) selector) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }

  /// Joins transformed elements with [separator].
  String joinWithIndex(
    String separator,
    String Function(int index, T item) transform,
  ) {
    if (isEmpty) return '';
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      if (i > 0) buffer.write(separator);
      buffer.write(transform(i, this[i]));
    }
    return buffer.toString();
  }

  /// Maps each element to a list via [transform] and concatenates results.
  List<R> flatten<R>(List<R> Function(T) transform) {
    final result = <R>[];
    for (final element in this) {
      result.addAll(transform(element));
    }
    return result;
  }

  /// Returns a new list with every element passed through [update].
  List<T> updateAll(T Function(T) update) {
    return map(update).toList();
  }

  /// Updates elements matching [test] via [update]; others unchanged.
  List<T> updateWhere(bool Function(T) test, T Function(T) update) {
    return map((item) => test(item) ? update(item) : item).toList();
  }

  /// Returns [count] randomly sampled elements (or all if fewer).
  List<T> sample(int count) {
    if (count >= length) return [...this];
    final shuffled = [...this]..shuffle();
    return shuffled.take(count).toList();
  }

  /// A random element, or `null` if the list is empty.
  T? random() {
    if (isEmpty) return null;
    final random = Random();
    return this[random.nextInt(length)];
  }

  /// Elements that also appear in [other].
  List<T> intersect(List<T> other) {
    final set = other.toSet();
    return where(set.contains).toList();
  }

  /// Unique elements from this list and [other].
  List<T> union(List<T> other) {
    return [...toSet(), ...other.toSet()];
  }

  /// Elements in this list that are not in [other].
  List<T> difference(List<T> other) {
    final set = other.toSet();
    return where((element) => !set.contains(element)).toList();
  }
}
