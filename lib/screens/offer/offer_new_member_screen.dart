import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/role_selection/role_selection_screen.dart';
import 'package:iw_app/widgets/components/new_member_form.dart';
import 'package:iw_app/widgets/components/new_member_form_lite.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

class OfferNewMemberScreen extends StatefulWidget {
  final Organization organization;
  const OfferNewMemberScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<OfferNewMemberScreen> createState() => _OfferNewMemberScreen();
}

class _OfferNewMemberScreen extends State<OfferNewMemberScreen> {
  Organization get organization => widget.organization;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  OrganizationMember member = OrganizationMember(
    role: MemberRole.Member,
  );

  handleNext() {
    if (formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoleSelectionScreen(
            member: member,
            organization: organization,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
    String formTitle =
        'Set the terms upon which a new member is invited to join organization';
    return ScreenScaffold(
      title: 'Offer to a New Member',
      child: Column(
        children: <Widget>[
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                config.mode == Mode.Lite
                    ? NewMemberFormLite(
                        title: formTitle,
                        formKey: formKey,
                        member: member,
                      )
                    : NewMemberForm(
                        title: formTitle,
                        formKey: formKey,
                        member: member,
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              onPressed: handleNext,
              child: Text(AppLocalizations.of(context)!.common_next),
            ),
          )
        ],
      ),
    );
  }
}
