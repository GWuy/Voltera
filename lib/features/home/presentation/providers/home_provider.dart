import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/debouncer.dart';
import '../../data/models/post_response.dart';
import '../../domain/repositories/post_repository.dart';

/// Manages home screen state: posts, search, category filtering, and caching.
///
/// Widgets listen via [Consumer] or [context.watch] — no direct API calls from UI.
class HomeProvider extends ChangeNotifier {
  HomeProvider({required PostRepository repository}) : _repository = repository;

  final PostRepository _repository;
  final Debouncer _searchDebouncer = Debouncer();

  // ── State ─────────────────────────────────────────────────────────────────
  List<PostResponse> _allPosts = [];
  List<PostResponse> _filteredPosts = [];
  bool _loading = true;
  String? _error;
  int _selectedCategory = 0; // 0=All, 1=Car, 2=Battery
  String _searchQuery = '';

  // ── Category cache ────────────────────────────────────────────────────────
  final Map<int, List<PostResponse>> _cache = {};

  // ── Getters ───────────────────────────────────────────────────────────────
  List<PostResponse> get filteredPosts => _filteredPosts;
  bool get loading => _loading;
  String? get error => _error;
  int get selectedCategory => _selectedCategory;

  // ── Price formatter (static — created once) ───────────────────────────────
  static final _priceFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  String formatPrice(double? price) {
    if (price == null) return 'N/A';
    return _priceFormatter.format(price);
  }

  // ── Fetch posts ───────────────────────────────────────────────────────────

  Future<void> fetchPosts({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _cache.containsKey(_selectedCategory)) {
      _allPosts = _cache[_selectedCategory]!;
      _loading = false;
      _error = null;
      _applyFilter();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final posts = await switch (_selectedCategory) {
        1 => _repository.getVehiclePosts(),
        2 => _repository.getBatteryPosts(),
        _ => _repository.getAllPosts(),
      };

      _allPosts = posts;
      _cache[_selectedCategory] = posts; // cache the result
      _loading = false;
      _error = null;
      _applyFilter();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Category selection ────────────────────────────────────────────────────

  void selectCategory(int index) {
    if (_selectedCategory == index) return;
    _selectedCategory = index;
    notifyListeners();
    fetchPosts();
  }

  // ── Search with debounce ──────────────────────────────────────────────────

  void updateSearch(String query) {
    _searchQuery = query;
    _searchDebouncer.run(_applyFilter);
  }

  void _applyFilter() {
    final query = _searchQuery.toLowerCase().trim();
    _filteredPosts = _allPosts.where((p) {
      return query.isEmpty ||
          (p.title?.toLowerCase().contains(query) ?? false) ||
          (p.location?.toLowerCase().contains(query) ?? false);
    }).toList();
    notifyListeners();
  }

  // ── Invalidate cache on refresh ───────────────────────────────────────────

  Future<void> refresh() async {
    _cache.clear();
    await fetchPosts(forceRefresh: true);
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
}
