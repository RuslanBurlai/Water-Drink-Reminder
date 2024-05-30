import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  double waterProgressValue;
  @HiveField(1)
  int drinkedValue;
  @HiveField(2)
  List<DateTime> drinkedTime;
  @HiveField(3)
  int selectedLites;

  User({
    required this.waterProgressValue,
    required this.drinkedValue,
    required this.drinkedTime,
    required this.selectedLites,
  });

  User copyWith({
    double? waterProgressValue,
    int? drinkedValue,
    List<DateTime>? drinkedTime,
    int? selectedLites,
  }) {
    return User(
      waterProgressValue: waterProgressValue ?? this.waterProgressValue,
      drinkedValue: drinkedValue ?? this.drinkedValue,
      drinkedTime: drinkedTime ?? this.drinkedTime,
      selectedLites: selectedLites ?? this.selectedLites,
    );
  }

  @override
  String toString() {
    return 'User(waterProgressValue: $waterProgressValue, drinkedValue: $drinkedValue, drinkedTime: $drinkedTime, selectedLites: $selectedLites)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.waterProgressValue == waterProgressValue &&
      other.drinkedValue == drinkedValue &&
      listEquals(other.drinkedTime, drinkedTime) &&
      other.selectedLites == selectedLites;
  }

  @override
  int get hashCode {
    return waterProgressValue.hashCode ^
      drinkedValue.hashCode ^
      drinkedTime.hashCode ^
      selectedLites.hashCode;
  }
}
