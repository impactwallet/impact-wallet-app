import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';

class OrgMemberCard extends StatelessWidget {
  final Function()? onTap;
  final OrganizationMember? member;
  final Future<List<OrganizationMember>>? futureOtherMembers;

  const OrgMemberCard({
    Key? key,
    this.onTap,
    this.member,
    this.futureOtherMembers,
  }) : super(key: key);

  buildLogo() {
    return member != null
        ? FittedBox(
            clipBehavior: Clip.hardEdge,
            fit: BoxFit.cover,
            child: Image.memory(
              member?.org?.logo,
            ),
          )
        : const Center(
            child: Icon(
              CupertinoIcons.add,
              size: 30,
              color: COLOR_ALMOST_BLACK,
            ),
          );
  }

  buildOrgName(BuildContext context) {
    if (member == null) {
      return Text(
        AppLocalizations.of(context)!.homeScreen_createNewOrgTitle,
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }
    return Text(
      member?.org?.name,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  buildOrgUsername(BuildContext context) {
    if (member == null) {
      return Container();
    }
    return Column(
      children: [
        const SizedBox(height: 5),
        Text(
          '@${member?.org?.username}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: COLOR_GRAY),
        ),
      ],
    );
  }

  buildMainSection(BuildContext context) {
    if (member == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.homeScreen_createNewOrgDesc,
          style: const TextStyle(color: COLOR_GRAY),
        ),
      );
    }

    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );
    return Column(
      children: [
        const Spacer(),
        ListTile(
          dense: true,
          title: Text('You Contributed', style: textStyle),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text('${member!.contributed!.toStringAsFixed(2)}h',
              style: textStyle),
          visualDensity:
              const VisualDensity(vertical: VisualDensity.minimumDensity),
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          title: Text('Your Impact Ratio', style: textStyle),
          contentPadding: const EdgeInsets.all(0),
          trailing: Text('${member!.impactRatio}x', style: textStyle),
          visualDensity:
              const VisualDensity(vertical: VisualDensity.minimumDensity),
        ),
        const Divider(height: 1),
        const SizedBox(height: 15),
        FutureBuilder(
            future: futureOtherMembers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              return Row(
                children: [
                  ...snapshot.data!.map((member) {
                    return Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: COLOR_GRAY,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.memory(member.user.image),
                      ),
                    );
                  }),
                  const SizedBox(width: 5),
                  Text(
                    '${snapshot.data!.length} members',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              );
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        margin: const EdgeInsets.all(0),
        color: COLOR_LIGHT_GRAY,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: COLOR_LIGHT_GRAY2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: buildLogo(),
                ),
                const SizedBox(height: 10),
                buildOrgName(context),
                buildOrgUsername(context),
                Expanded(
                  child: buildMainSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
