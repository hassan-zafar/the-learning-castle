import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentJournelModel {
  final double? happySlider;
  final List<int>? iWas;
  final int? iAte;
  final int? diaperChange;
  final int? iNeed;
  final String? journelNotes;
  final String? sleepingTimeStr;
  final String? sleepTIme;
  StudentJournelModel(
      {this.happySlider,
      this.iWas,
      this.iAte,
      this.diaperChange,
      this.iNeed,
      this.journelNotes,
      this.sleepTIme,
      this.sleepingTimeStr});

  StudentJournelModel copyWith({
    double? happySlider,
    List<int>? iWas,
    int? iAte,
    int? diaperChange,
    int? iNeed,
     String? sleepingTimeStr,
    String? journelNotes,
    String? sleepTIme,
  }) {
    return StudentJournelModel(
      happySlider: happySlider ?? this.happySlider,
      iWas: iWas ?? this.iWas,
      iAte: iAte ?? this.iAte,
      diaperChange: diaperChange ?? this.diaperChange,
      iNeed: iNeed ?? this.iNeed,
      journelNotes: journelNotes ?? this.journelNotes,
      sleepTIme: sleepTIme ?? this.sleepTIme,
      sleepingTimeStr: sleepingTimeStr ?? this.sleepingTimeStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'happySlider': happySlider,
      'iWas': iWas,
      'iAte': iAte,
      'diaperChange': diaperChange,
      'iNeed': iNeed,
      'journelNotes': journelNotes,
      'sleepTIme': sleepTIme,
      'sleepingTimeStr': sleepingTimeStr,
    };
  }

  factory StudentJournelModel.fromMap(Map<String, dynamic> map) {
    return StudentJournelModel(
      happySlider: map['happySlider'],
      iWas: map['iWas'],
      iAte: map['iAte'],
      diaperChange: map['diaperChange'],
      iNeed: map['iNeed'],
      journelNotes: map['journelNotes'],
      sleepTIme: map['sleepTIme'],
      sleepingTimeStr: map['sleepingTimeStr'],
    );
  }
  factory StudentJournelModel.fromDocument(DocumentSnapshot doc) {
    return StudentJournelModel(
      happySlider: doc['happySlider'],
      iWas: doc['iWas'].cast<int>(),
      iAte: doc['iAte'],
      diaperChange: doc['diaperChange'],
      iNeed: doc['iNeed'],
      journelNotes: doc['journelNotes'],
      sleepTIme: doc['sleepTIme'],
      sleepingTimeStr: doc['sleepingTimeStr'],
    );
  }
  String toJson() => json.encode(toMap());

  factory StudentJournelModel.fromJson(String source) =>
      StudentJournelModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StudentJournelModel(happySlider: $happySlider, iWas: $iWas, iAte: $iAte, diaperChange: $diaperChange, iNeed: $iNeed, journelNotes: $journelNotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentJournelModel &&
        other.happySlider == happySlider &&
        other.iWas == iWas &&
        other.iAte == iAte &&
        other.diaperChange == diaperChange &&
        other.iNeed == iNeed &&
        other.journelNotes == journelNotes;
  }

  @override
  int get hashCode {
    return happySlider.hashCode ^
        iWas.hashCode ^
        iAte.hashCode ^
        diaperChange.hashCode ^
        iNeed.hashCode ^
        journelNotes.hashCode;
  }
}
