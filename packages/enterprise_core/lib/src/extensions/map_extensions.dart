/// Convenience helpers for [Map] null-checks, transforms, and merging.
extension MapExtensions<K, V> on Map<K, V> {
  /// Whether this map has no entries.
  bool get isNullOrEmpty => isEmpty;

  /// Whether this map has one or more entries.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns the value for [key], or `null` if the key is absent.
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  /// Returns the value for [key], or [defaultValue] if the key is absent.
  V getOrDefault(K key, V defaultValue) =>
      containsKey(key) ? this[key]! : defaultValue;

  /// Builds a new map by applying [transform] to each entry.
  Map<K2, V2> mapEntries<K2, V2>(
    MapEntry<K2, V2> Function(K key, V value) transform,
  ) {
    final result = <K2, V2>{};
    forEach((key, value) {
      final entry = transform(key, value);
      result[entry.key] = entry.value;
    });
    return result;
  }

  /// Returns a map containing only entries that satisfy [predicate].
  Map<K, V> filter(bool Function(K key, V value) predicate) {
    final result = <K, V>{};
    forEach((key, value) {
      if (predicate(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Returns a map containing only keys that satisfy [predicate].
  Map<K, V> filterKeys(bool Function(K key) predicate) {
    return filter((key, _) => predicate(key));
  }

  /// Returns a map containing only values that satisfy [predicate].
  Map<K, V> filterValues(bool Function(V value) predicate) {
    return filter((_, value) => predicate(value));
  }

  /// Groups entries by the key produced from [keySelector].
  Map<K2, Map<K, V>> groupBy<K2>(K2 Function(K key, V value) keySelector) {
    final result = <K2, Map<K, V>>{};
    forEach((key, value) {
      final groupKey = keySelector(key, value);
      result.putIfAbsent(groupKey, () => <K, V>{})[key] = value;
    });
    return result;
  }

  /// Maps each entry to [R] and returns the results as a list.
  List<R> flatten<R>(R Function(K key, V value) transform) {
    final result = <R>[];
    forEach((key, value) {
      result.add(transform(key, value));
    });
    return result;
  }

  /// Merges [other] into a copy of this map.
  ///
  /// When both maps contain the same key and [onConflict] is provided, that
  /// callback resolves the value; otherwise [other]'s value wins.
  Map<K, V> merge(Map<K, V> other, {V Function(V, V)? onConflict}) {
    final result = Map<K, V>.from(this);
    other.forEach((key, value) {
      if (result.containsKey(key) && onConflict != null) {
        result.update(key, (existing) => onConflict(existing, value));
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  /// Returns a map with keys and values swapped.
  Map<V, K> invert() {
    final result = <V, K>{};
    forEach((key, value) {
      result[value] = key;
    });
    return result;
  }

  /// Splits entries into maps of at most [size] entries each.
  List<Map<K, V>> chunked(int size) {
    if (size <= 0) return [];
    final entries = this.entries.toList();
    final result = <Map<K, V>>[];
    for (var i = 0; i < entries.length; i += size) {
      final chunk = <K, V>{};
      final end = i + size < entries.length ? i + size : entries.length;
      for (var j = i; j < end; j++) {
        final entry = entries[j];
        chunk[entry.key] = entry.value;
      }
      result.add(chunk);
    }
    return result;
  }

  /// Returns a map sorted by keys using [selector].
  Map<K, V> sortedByKey<R extends Comparable<R>>(R Function(K) selector) {
    final entries = this.entries.toList()
      ..sort((a, b) => selector(a.key).compareTo(selector(b.key)));
    return Map.fromEntries(entries);
  }

  /// Returns a map sorted by values using [selector].
  Map<K, V> sortedByValue<R extends Comparable<R>>(R Function(V) selector) {
    final entries = this.entries.toList()
      ..sort((a, b) => selector(a.value).compareTo(selector(b.value)));
    return Map.fromEntries(entries);
  }

  /// Returns a shallow copy of this map.
  Map<K, V> deepCopy() {
    return mapEntries(MapEntry.new);
  }

  /// Returns a map with each value replaced by [update].
  Map<K, V> updateValues(V Function(K key, V value) update) {
    return mapEntries((key, value) => MapEntry(key, update(key, value)));
  }

  /// Returns a copy with [key]'s value updated by [update], if present.
  Map<K, V> updateValueForKey(K key, V Function(V value) update) {
    if (!containsKey(key)) return Map.from(this);
    final result = Map<K, V>.from(this)..update(key, update);
    return result;
  }

  /// Converts keys to strings for a JSON-friendly map.
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    forEach((key, value) {
      result[key.toString()] = value;
    });
    return result;
  }

  /// Returns an indented string representation of this map.
  String toPrettyString({int indent = 2}) {
    final buffer = StringBuffer();
    _prettyPrintMap(this, buffer, 0, indent);
    return buffer.toString();
  }

  void _prettyPrintMap(
    Map<dynamic, dynamic> map,
    StringBuffer buffer,
    int depth,
    int indent,
  ) {
    buffer.write('{\n');
    map.forEach((key, value) {
      buffer
        ..write(' ' * ((depth + 1) * indent))
        ..write('$key: ');
      if (value is Map) {
        _prettyPrintMap(value, buffer, depth + 1, indent);
      } else if (value is List) {
        _prettyPrintList(value, buffer, depth + 1, indent);
      } else {
        buffer.write('$value');
      }
      buffer.write(',\n');
    });
    buffer
      ..write(' ' * (depth * indent))
      ..write('}');
  }

  void _prettyPrintList(
    List<dynamic> list,
    StringBuffer buffer,
    int depth,
    int indent,
  ) {
    buffer.write('[\n');
    for (final value in list) {
      buffer.write(' ' * ((depth + 1) * indent));
      if (value is Map) {
        _prettyPrintMap(value, buffer, depth + 1, indent);
      } else if (value is List) {
        _prettyPrintList(value, buffer, depth + 1, indent);
      } else {
        buffer.write('$value');
      }
      buffer.write(',\n');
    }
    buffer
      ..write(' ' * (depth * indent))
      ..write(']');
  }
}
