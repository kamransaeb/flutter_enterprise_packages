import 'package:enterprise_network/src/constants/network_constants.dart';

/// Generic paginated list wrapper.
class PaginatedResponse<T> {
  /// Constructs a new [PaginatedResponse].
  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
  });

  /// Parses common shapes:
  /// - `{ data: [...], meta: { page, per_page, total } }`
  /// - `{ items: [...], page, per_page, total }`
  factory PaginatedResponse.fromJson(
    /// The JSON response.
    Map<String, dynamic> json,
    /// The function to parse the items in the response.
    T Function(Map<String, dynamic>) fromJsonT, {
    /// The key for the data in the response.
    String dataKey = NetworkConstants.dataKey,
    /// The key for the items in the response.
    String itemsKey = NetworkConstants.itemsKey,
    /// The pagination metadata key in the response.
    String metaKey = NetworkConstants.metaKey,
  }) {
    final meta = json[metaKey] as Map<String, dynamic>? ?? json;

    final rawItems = (json[dataKey] ?? json[itemsKey]) as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      items: items,
      page: _asInt(
        meta[NetworkConstants.pageKey] ?? meta[NetworkConstants.currentPageKey],
        fallback: NetworkConstants.defaultPage,
      ),
      perPage: _asInt(
        meta[NetworkConstants.perPageKey] ??
            meta[NetworkConstants.perPageCountKey],
        fallback: NetworkConstants.defaultPerPage,
      ),
      total: _asInt(
        meta[NetworkConstants.totalKey] ?? meta[NetworkConstants.totalCountKey],
        fallback: NetworkConstants.defaultTotal,
      ),
    );
  }

  /// The list of items in the response.
  final List<T> items;

  /// The page number of the response.
  final int page;

  /// The number of items per page in the response.
  final int perPage;

  /// The total number of items in the response.
  final int total;

  /// The total number of pages in the response.
  int get totalPages => perPage == 0 ? 0 : (total / perPage).ceil();

  /// Whether the response has a next page.
  bool get hasNextPage => page < totalPages;

  /// Whether the response has a previous page.
  bool get hasPreviousPage => page > 1;

  static int _asInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
