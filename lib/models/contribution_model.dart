import 'package:iw_app/models/organization_model.dart';

class Contribution {
  String? id;
  dynamic member;
  dynamic org;
  double? impactRatio;
  String? stoppedAt;
  String? txnHash;
  double? lamportsEarned;
  String? createdAt;
  String? updatedAt;

  Contribution({
    this.member,
    this.org,
    this.impactRatio,
    this.stoppedAt,
    this.txnHash,
    this.lamportsEarned,
    this.createdAt,
    this.updatedAt,
  });

  Contribution.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    member = json['member'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    impactRatio = json[''];
    stoppedAt = json['stoppedAt'];
    txnHash = json['txnHash'];
    lamportsEarned = json['lamportsEarned'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
