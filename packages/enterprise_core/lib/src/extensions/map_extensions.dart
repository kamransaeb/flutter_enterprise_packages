extension MapExtensions<K, V> on Map<K, V> {
  // Null safety
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => !isEmpty;

  // Safe access
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  V getOrDefault(K key, V defaultValue) =>
      containsKey(key) ? this[key]! : defaultValue;

  // Transformation
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) {
    final result = <K2, V2>{};
    forEach((key, value) {
      final entry = transform(key, value);
      result[entry.key] = entry.value;
    });
    return result;
  }

  Map<K, V> filter(bool Function(K key, V value) predicate) {
    final result = <K, V>{};
    forEach((key, value) {
      if (predicate(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }

  Map<K, V> filterKeys(bool Function(K key) predicate) {
    return filter((key, _) => predicate(key));
  }

  Map<K, V> filterValues(bool Function(V value) predicate) {
    return filter((_, value) => predicate(value));
  }

  // Grouping
  Map<K2, Map<K, V>> groupBy<K2>(K2 Function(K key, V value) keySelector) {
    final result = <K2, Map<K, V>>{};
    forEach((key, value) {
      final groupKey = keySelector(key, value);
      result.putIfAbsent(groupKey, () => <K, V>{})[key] = value;
    });
    return result;
  }

  // Flattening
  List<R> flatten<R>(R Function(K key, V value) transform) {
    final result = <R>[];
    forEach((key, value) {
      result.add(transform(key, value));
    });
    return result;
  }

  // Merging
  Map<K, V> merge(Map<K, V> other, {V Function(V, V)? onConflict}) {
    final result = Map<K, V>.from(this);
    other.forEach((key, value) {
      if (result.containsKey(key) && onConflict != null) {
        result[key] = onConflict(result[key]!, value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  // Invert
  Map<V, K> invert() {
    final result = <V, K>{};
    forEach((key, value) {
      result[value] = key;
    });
    return result;
  }

  // Partition
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

  // Sorting
  Map<K, V> sortedByKey<R extends Comparable>(R Function(K) selector) {
    final entries = this.entries.toList()
      ..sort((a, b) => selector(a.key).compareTo(selector(b.key)));
    return Map.fromEntries(entries);
  }

  Map<K, V> sortedByValue<R extends Comparable>(R Function(V) selector) {
    final entries = this.entries.toList()
      ..sort((a, b) => selector(a.value).compareTo(selector(b.value)));
    return Map.fromEntries(entries);
  }

  // Deep copy
  Map<K, V> deepCopy() {
    return map((key, value) => MapEntry(key, value));
  }

  // Update values
  Map<K, V> updateValues(V Function(K key, V value) update) {
    return map((key, value) => MapEntry(key, update(key, value)));
  }

  Map<K, V> updateValueForKey(K key, V Function(V value) update) {
    if (!containsKey(key)) return Map.from(this);
    final result = Map<K, V>.from(this);
    result[key] = update(this[key]!);
    return result;
  }

  // JSON handling
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    forEach((key, value) {
      result[key.toString()] = value;
    });
    return result;
  }

  // Pretty printing
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
      buffer.write(' ' * ((depth + 1) * indent));
      buffer.write('$key: ');
      if (value is Map) {
        _prettyPrintMap(value, buffer, depth + 1, indent);
      } else if (value is List) {
        _prettyPrintList(value, buffer, depth + 1, indent);
      } else {
        buffer.write('$value');
      }
      buffer.write(',\n');
    });
    buffer.write(' ' * (depth * indent));
    buffer.write('}');
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
    buffer.write(' ' * (depth * indent));
    buffer.write(']');
  }
}