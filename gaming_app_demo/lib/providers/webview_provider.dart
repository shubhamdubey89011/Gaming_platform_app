import 'package:flutter/material.dart';

class WebViewProvider with ChangeNotifier {
  String _selectedUrl = 'https://store.steampowered.com';
  bool _isLoading = true;

  final List<String> _urls = [
    'https://store.steampowered.com',
    'https://www.epicgames.com/store',
    'https://www.origin.com',
    'https://battle.net',
    'https://www.gog.com',
  ];

  final List<String> _urlNames = [
    'Steam',
    'Epic Games Store',
    'Origin',
    'Battle.net',
    'GOG',
  ];

  String get selectedUrl => _selectedUrl;
  bool get isLoading => _isLoading;

  List<String> get urls => _urls;
  List<String> get urlNames => _urlNames;

  void setSelectedUrl(String url) {
    _selectedUrl = url;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
