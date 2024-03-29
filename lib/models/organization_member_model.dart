import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/utils/common.dart';
import 'package:iw_app/utils/numbers.dart';

enum MemberRole {
  Member,
  Admin,
  CoOwner,
  Investor,
}

enum PeriodType {
  Days,
  Weeks,
  Months,
  Years,
}

enum EquityType { Immediately, DuringPeriod }

enum CompensationType { PerMonth, OneTime }

class TokenAmount {
  String? amount;
  int? decimals;
  double? uiAmount;
  String? uiAmountString;

  TokenAmount({
    this.amount,
    this.decimals,
    this.uiAmount,
    this.uiAmountString,
  });

  TokenAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    decimals = json['decimals'];
    uiAmount = intToDouble(json['uiAmount']);
    uiAmountString = json['uiAmountString'];
  }
}

class Period {
  double? value;
  PeriodType? timeframe;

  Period({
    this.value,
    this.timeframe,
  });

  Period.fromJson(Map<String, dynamic> json) {
    value = intToDouble(json['value']);
    timeframe = CommonUtils.stringToEnum(json['timeframe'], PeriodType.values);
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timeframe': timeframe?.name,
    };
  }
}

class Compensation {
  double? amount;
  CompensationType? type;
  Period? period;

  Compensation({
    this.amount,
    this.type,
    this.period,
  });

  Compensation.fromJson(Map<String, dynamic> json) {
    amount = intToDouble(json['amount']);
    type = CommonUtils.stringToEnum(json['type'], CompensationType.values);
    period = json['period'] is Map
        ? Period.fromJson(json['period'])
        : json['period'];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type?.name,
      'period': period?.toJson(),
    };
  }
}

class OrganizationMemberPermissions {
  bool canSendMoney;
  bool canRaiseMoney;
  bool canInviteMembers;
  bool canChangeTreasury;
  bool canEditOrg;

  OrganizationMemberPermissions({
    this.canSendMoney = false,
    this.canRaiseMoney = false,
    this.canInviteMembers = false,
    this.canChangeTreasury = false,
    this.canEditOrg = false,
  });
}

class OrganizationMember {
  String? id;
  String? occupation;
  MemberRole? role;
  double? impactRatio;
  bool? isAutoContributing;
  double? hoursPerWeek;
  dynamic user;
  dynamic orgUser;
  dynamic org;
  double? contributed;
  InvestorSettings? investorSettings;
  double? lamportsEarned;
  double? equityAmount;
  EquityType? equityType;
  Period? equityPeriod;
  Compensation? compensation;
  String? createdAt;
  OrganizationMemberPermissions? permissions;
  double? profit;

  OrganizationMember({
    this.occupation,
    this.role,
    this.impactRatio = 1,
    this.isAutoContributing = false,
    this.hoursPerWeek = 40,
    this.user,
    this.org,
    this.contributed = 0,
    this.investorSettings,
    this.lamportsEarned,
    this.equityAmount,
    this.equityType,
    this.equityPeriod,
    this.compensation,
    this.permissions,
    this.profit = 0,
  });

  OrganizationMember.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    occupation = json['occupation'];
    role = CommonUtils.stringToEnum(json['role'], MemberRole.values);
    impactRatio = intToDouble(json['impactRatio']);
    isAutoContributing = json['isAutoContributing'];
    hoursPerWeek = intToDouble(json['hoursPerWeek']);
    user = json['user'] is Map ? User.fromJson(json['user']) : json['user'];
    orgUser = json['orgUser'] is Map
        ? Organization.fromJson(json['orgUser'])
        : json['orgUser'];
    org = json['org'] is Map ? Organization.fromJson(json['org']) : json['org'];
    contributed = intToDouble(json['contributed']);
    lamportsEarned = intToDouble(json['lamportsEarned']);
    investorSettings = json['investorSettings'] is Map
        ? InvestorSettings.fromJson(json['investorSettings'])
        : json['investorSettings'];
    equityAmount = intToDouble(json['equityAmount']);
    equityType =
        CommonUtils.stringToEnum(json['equityType'], EquityType.values);
    equityPeriod = json['equityPeriod'] is Map
        ? Period.fromJson(json['period'])
        : json['period'];
    compensation = json['compensation'] is Map
        ? Compensation.fromJson(json['compensation'])
        : json['compensation'];
    createdAt = json['createdAt'];

    final isAdmin = role == MemberRole.Admin;
    permissions = OrganizationMemberPermissions(
      canSendMoney: isAdmin,
      canRaiseMoney: isAdmin,
      canInviteMembers: isAdmin,
      canChangeTreasury: isAdmin,
      canEditOrg: isAdmin,
    );
    profit = json['profit'] ?? 0;
  }

  String? get image {
    if (user is User) {
      return (user as User).avatar;
    } else if (orgUser is Organization) {
      return (orgUser as Organization).logo;
    }
    return null;
  }

  String? get username {
    if (user is User) {
      return (user as User).nickname;
    } else if (orgUser is Organization) {
      return (orgUser as Organization).username;
    }
    return null;
  }

  @override
  String toString() {
    return '''
${super.toString()}
occupation: $occupation
impactRatio: $impactRatio
isAutoContributing: $isAutoContributing
hoursPerWeek: $hoursPerWeek
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'occupation': occupation,
      'role': role?.name,
      'impactRatio': impactRatio,
      'isAutoContributing': isAutoContributing,
      'hoursPerWeek': hoursPerWeek,
      'user': user,
      'org': org,
      'investorSettings': investorSettings?.toJson(),
      'equityAmount': equityAmount,
      'equityType': equityType?.name,
      'equityPeriod': equityPeriod?.toJson(),
      'compensation': compensation?.toJson(),
    };
  }
}

class OrganizationMemberWithEquity {
  OrganizationMember? member;
  String? equity;
  Future<String>? futureEquity;

  OrganizationMemberWithEquity({
    this.member,
    this.equity,
    this.futureEquity,
  });
}

class OrganizationMemberWithOtherMembers extends OrganizationMemberWithEquity {
  List<OrganizationMember>? otherMembers;
  Future<Map<String, dynamic>>? futureOtherMembers;

  OrganizationMemberWithOtherMembers({
    OrganizationMember? member,
    this.futureOtherMembers,
    this.otherMembers,
    String? equity,
    Future<String>? futureEquity,
  }) : super(
          member: member,
          equity: equity,
          futureEquity: futureEquity,
        );
}

class InvestorSettings {
  double? investmentAmount;
  double? equityAllocation;

  InvestorSettings({
    this.investmentAmount,
    this.equityAllocation,
  });

  InvestorSettings.fromJson(Map<String, dynamic> json) {
    investmentAmount = intToDouble(json['investmentAmount']);
    equityAllocation = intToDouble(json['equityAllocation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'investmentAmount': investmentAmount,
      'equityAllocation': equityAllocation,
    };
  }
}
