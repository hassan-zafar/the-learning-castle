import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel {
  final String? feeId;
  final String? pendingFee;
  final Timestamp? lastDate;
  final String? feePackage;
  final String? totalFee;
  final bool? isPaid;
  FeeModel(
      {this.feeId,
      this.pendingFee,
      this.lastDate,
      this.feePackage,
      this.isPaid,
      this.totalFee});

  Map<String, dynamic> toMap() {
    return {
      'feeId': feeId,
      'pendingFee': pendingFee,
      'lastDate': lastDate,
      'feePackage': feePackage,
      'isPaid': isPaid,
      'totalFee': totalFee,
    };
  }

  factory FeeModel.fromMap(Map<String, dynamic> map) {
    return FeeModel(
      feeId: map['feeId'],
      pendingFee: map['pendingFee'],
      lastDate: map['lastDate'],
      feePackage: map['feePackage'],
      isPaid: map['isPaid'],
      totalFee: map['totalFee'],
    );
  }

  factory FeeModel.fromDocument(doc) {
    return FeeModel(
      feeId: doc['feeId'],
      pendingFee: doc['pendingFee'],
      lastDate: doc['lastDate'],
      feePackage: doc['feePackage'],
      isPaid: doc['isPaid'],
      totalFee: doc['totalFee'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeeModel.fromJson(String source) =>
      FeeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeeModel( feeId: $feeId, pendingFee: $pendingFee, lastDate: $lastDate, feePackage: $feePackage, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeeModel &&
        other.feeId == feeId &&
        other.pendingFee == pendingFee &&
        other.lastDate == lastDate &&
        other.feePackage == feePackage &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return feeId.hashCode ^
        pendingFee.hashCode ^
        lastDate.hashCode ^
        feePackage.hashCode ^
        isPaid.hashCode;
  }
}
