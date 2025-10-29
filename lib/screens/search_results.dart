import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Page 3 - Search Results
class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  const SearchResultsPage({Key? key, required this.searchQuery})
    : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _hotels = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;

  static const String _baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String _authToken = '71523fdd8d26f585315b4233e39d9263';

  @override
  void initState() {
    super.initState();
    _fetchHotels();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!_isLoading && _hasMore) {
        _fetchHotels();
      }
    }
  }

  Future<void> _fetchHotels() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${_baseUrl}hotels/search?query=${Uri.encodeComponent(widget.searchQuery)}&page=$_currentPage',
        ),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> newHotels = data['data'] ?? [];

        setState(() {
          _hotels.addAll(newHotels);
          _currentPage++;
          _hasMore = newHotels.isNotEmpty && newHotels.length >= 10;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load hotels: ${response.statusCode}';
          _isLoading = false;
          _hasMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.searchQuery}"')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hotels.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hotels.isEmpty && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'No hotels found',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Try a different search term',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${_hotels.length} hotel${_hotels.length != 1 ? 's' : ''} found',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _hotels.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _hotels.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final hotel = _hotels[index];
              return _buildHotelCard(hotel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotelCard(dynamic hotel) {
    final name = hotel['name'] ?? 'Unknown Hotel';
    final city = hotel['city'] ?? '';
    final state = hotel['state'] ?? '';
    final country = hotel['country'] ?? '';
    final address = hotel['address'] ?? '';
    final rating = hotel['rating']?.toString() ?? 'N/A';

    String location = [
      city,
      state,
      country,
    ].where((s) => s.isNotEmpty).join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (rating != 'N/A')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ],
            if (address.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                address,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
