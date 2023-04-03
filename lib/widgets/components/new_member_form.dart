import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/components/bottom_sheet_info.dart';
import 'package:iw_app/widgets/form/input_form.dart';

class NewMemberForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OrganizationMember member;
  final String title;

  const NewMemberForm({
    Key? key,
    required this.formKey,
    required this.member,
    required this.title,
  }) : super(key: key);

  @override
  State<NewMemberForm> createState() => _NewMemberFormState();
}

class _NewMemberFormState extends State<NewMemberForm> {
  final compensationCtrl = TextEditingController();

  OrganizationMember get member => widget.member;
  String get title => widget.title;

  onOccupationChanged(String value) {
    setState(() {
      member.occupation = value;
    });
  }

  onImpactRatioChanged(String value) {
    setState(() {
      member.impactRatio = double.tryParse(value) ?? 0;
    });
  }

  onMonthlyCompensationChanged(String value) {
    setState(() {
      member.monthlyCompensation = double.tryParse(value) ?? 0;
    });
  }

  onIsMonthlyCompensatedChanged(bool value) {
    setState(() {
      member.isMonthlyCompensated = value;
    });
  }

  onAutoContributionChanged(bool value) {
    setState(() {
      member.autoContribution = value;
    });
  }

  buildForm(BuildContext context) {
    return InputForm(
      formKey: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 40),
          AppTextFormField(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppLocalizations.of(context)!
                .createOrgMemberScreen_occupationLabel,
            validator: requiredField(
              AppLocalizations.of(context)!
                  .createOrgMemberScreen_occupationErrorLabel,
            ),
            onChanged: onOccupationChanged,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showBottomInfoSheet(context,
                      title: AppLocalizations.of(context)!
                          .createOrgMemberScreen_impactRatioLabel,
                      description:
                          'The Impact Ratio helps to account ‘the power of influence’ of members contributed the same amount of time to differentiate their impacts. \n\nMember’s dividends will be calculated based on their Equity. \n\nEvery member’s Equity is calculated based on Impact Shares. Impact Shares are earned multiplying member’s contribution time by their Impact Ratio.');
                },
                icon: const Icon(Icons.info_outline_rounded),
                iconSize: 16,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: COLOR_GRAY,
              ),
            ],
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            initialValue: widget.member.impactRatio.toString(),
            prefix: const Text('x'),
            validator: multiValidate([
              requiredField(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
              ),
              numberField(
                AppLocalizations.of(context)!
                    .createOrgMemberScreen_impactRatioLabel,
              ),
            ]),
            onChanged: onImpactRatioChanged,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_monthlyCompensationLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showBottomInfoSheet(context,
                          title: AppLocalizations.of(context)!
                              .createOrgSettingsScreen_treasuryLabel,
                          description: AppLocalizations.of(context)!
                              .treasury_description);
                    },
                    icon: const Icon(Icons.info_outline_rounded),
                    iconSize: 16,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: COLOR_GRAY,
                  ),
                ],
              ),
              CupertinoSwitch(
                value: widget.member.isMonthlyCompensated!,
                activeColor: COLOR_GREEN,
                onChanged: (bool? value) {
                  compensationCtrl.clear();
                  onIsMonthlyCompensatedChanged(value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextFormFieldBordered(
            controller: compensationCtrl,
            enabled: widget.member.isMonthlyCompensated,
            prefix: const Text('\$'),
            validator: widget.member.isMonthlyCompensated!
                ? multiValidate([
                    requiredField(
                      AppLocalizations.of(context)!
                          .createOrgMemberScreen_monthlyCompensationLabel,
                    ),
                    numberField(
                      AppLocalizations.of(context)!
                          .createOrgMemberScreen_monthlyCompensationLabel,
                    ),
                  ])
                : (_) => null,
            onChanged: onMonthlyCompensationChanged,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .createOrgMemberScreen_autoContributionLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showBottomInfoSheet(context,
                          title: AppLocalizations.of(context)!
                              .createOrgMemberScreen_autoContributionLabel,
                          description: AppLocalizations.of(context)!
                              .autoContribution_description);
                    },
                    icon: const Icon(Icons.info_outline_rounded),
                    iconSize: 16,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: COLOR_GRAY,
                  ),
                ],
              ),
              CupertinoSwitch(
                value: widget.member.autoContribution!,
                activeColor: COLOR_GREEN,
                onChanged: (bool? value) {
                  onAutoContributionChanged(value!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildForm(context);
  }
}