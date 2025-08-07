import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Idea_Model extends ChangeNotifier {
  var ideaBox;

  Idea_Model({required this.ideaBox});

  List _myIdeaList = [];
  List<bool> isvoted = [];
  bool _isdark = false;

  bool get isdark => _isdark;

  List get myIdeaList => _myIdeaList;

  List<Map<String, dynamic>> get topIdeas {
    List<Map<String, dynamic>> sorted = List.from(_myIdeaList)
      ..sort((a, b) => (b['vote'] ?? 0).compareTo(a['vote'] ?? 0));
    return sorted.take(5).toList();
  }

  addData(value) async {
    await ideaBox.add(value);
    getItem();
    notifyListeners();
  }

  getItem() async {
    _myIdeaList = await ideaBox.keys.map((key) {
      var temp = Map<String, dynamic>.from(ideaBox.get(key));
      return {
        'key': key,
        'title': temp['title'] ?? "",
        "tag": temp["tag"] ?? "",
        "description": temp['description'] ?? "",
        'rating': temp['rating'] ?? '',
        'vote': temp['vote'] ?? 0,
        'isVoted': temp['isVoted'] ?? false,
      };
    }).toList();
    notifyListeners();
  }

  updateItem(key, Map<String, dynamic> newValue) async {
    var existing = Map<String, dynamic>.from(ideaBox.get(key) ?? {});
    var updated = Map<String, dynamic>.from(existing)..addAll(newValue);
    await ideaBox.put(key, updated);
    await getItem();
    notifyListeners();
  }

  deleteItem(key) async {
    await ideaBox.delete(key);
    getItem();
    notifyListeners();
  }

  double generateRandomRating() {
    return double.parse((Random().nextDouble() * 5).toStringAsFixed(1));
  }

  int generateRandomVote() {
    Random random = Random();
    return random.nextInt(100) + 1;
  }

  void sortListBy(String sortBy) {
    if (sortBy == 'Votes') {
      myIdeaList.sort((a, b) => b['vote'].compareTo(a['vote']));
    } else if (sortBy == 'Rating') {
      myIdeaList.sort((a, b) => b['rating'].compareTo(a['rating']));
    }
    notifyListeners();
  }

  void updateTheme({required bool value}) async {
    _isdark = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", value);
    notifyListeners();
  }

  Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isdark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void initialState() async {
    await getItem();
    await getTheme();
  }
}
