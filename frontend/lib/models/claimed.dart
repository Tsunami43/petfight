class Claimed {
  DateTime? _timestamp; // DateTime может быть null

  Claimed({
    int? timestamp, // DateTime может быть null
  })  : _timestamp = timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000) : null;


  bool canClaimAgain() {
    if (_timestamp == null) {
      return false; // Если не было ни одного клейма
    }
    DateTime now = DateTime.now();
    Duration difference = now.difference(_timestamp!);
    return difference.inHours < 8; // Можно клеймить снова через 8 часов
  }

  int? get timestampAsInt {
    return _timestamp?.millisecondsSinceEpoch;
  }

  // Setter для _timestamp
  set timestamp(DateTime? value) {
    _timestamp = value;
  }

  // Метод для вычисления разницы в секундах между текущим временем и _timestamp
  int calculateDurationInSeconds() {
    if (_timestamp != null) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(_timestamp!);
      return difference.inSeconds;
    } else {
      return 0; // Возвращаем 0, если _timestamp равен null
    }
  }
}