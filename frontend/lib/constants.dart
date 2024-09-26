import 'package:flutter/material.dart';

class InfoProvider extends ChangeNotifier {
  bool _isView = false;
  String? message;

  bool get isView => _isView;

  void setMessage(String? value) {
    message = value;
    notifyListeners();
  }

  void setView(bool loading) {
    _isView = loading;
    notifyListeners();
  }
}

class NavigationProvider with ChangeNotifier {
  String _activeButton = 'Home';

  String get activeButton => _activeButton;

  void setActiveButton(String button) {
    _activeButton = button;
    notifyListeners();
  }
}

const String webSiteUrl = 'https://petfight.club';

class ImagesPath {
  static const String parentPath = "assets";
  static const String background = "$parentPath/background.png";
  static const String friendsBoard = "$parentPath/friends.png";
  static const String taskBoard = "$parentPath/task.png";
  static String personImage({required String person}) => '$parentPath/persons/$person.png';
}

class Endpoints {
  static const String host = "https://api.petfight.twc1.net";
  static const String auth = "$host/auth";
  static const String claim = "$host/claim";
  static const String task = "$host/task";
}

const Map<String, dynamic> taskList = {
  'joinToGame': {
    "name": "Join to Game",
    "text_button": 'Join',
    "url": null,
    "reward": 100,
  },
  'visitToWebSite': {
    "name": "Join to WebSite",
    "text_button": 'Visit',
    "url": webSiteUrl,
    "reward": 200,
  },
  'joinToTelegramChannel': {
    "name": "Join to Telegram",
    "text_button": 'Join',
    "url": "https://t.me/petfightclub",
    "reward": 500,
  },
  'subscribeToTelegramChannel': {
    "name": "Subscribe to Telegram Group",
    "text_button": 'Subscribe',
    "url": 'https://t.me/petfightclub',
    "reward": 1000,
  },
  'joinToTwitterChannel': {
    "name": "Join to Twitter",
    "text_button": 'Join',
    "url": 'https://ya.ru',
    "reward": 500,
  },
};