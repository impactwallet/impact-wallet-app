import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

_getContributionDuration(OrgEventsHistoryItem item) {
  final startDate = DateTime.parse(item.createdAt!);
  final stopDate = DateTime.parse(item.stoppedAt!);
  final diff = stopDate.difference(startDate);
  return trimZeros(diff.inMilliseconds / 1000 / 60 / 60);
}

buildPulseItem(
  BuildContext context,
  OrgEventsHistoryItem item,
  OrgEventsHistoryItem? prevItem,
) {
  Text? trailingText;
  final trailingTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
        color: COLOR_WHITE,
      );
  if (item.action == OrgHistoryItemAction.Contributed) {
    final duration = _getContributionDuration(item);
    trailingText = Text(
      '+ ${duration}h',
      style: trailingTextStyle,
    );
  }
  final primaryColor = item.action == OrgHistoryItemAction.Contributed
      ? COLOR_ALMOST_BLACK
      : COLOR_BLUE;
  final icon = Icon(
    item.action == OrgHistoryItemAction.Contributed
        ? CupertinoIcons.clock
        : Icons.add,
    color: COLOR_WHITE,
    size: 12,
  );
  final title = item.user?.nickname ?? item.orgUser?.username;
  final date =
      item.date != null ? DateTime.parse(item.date!).toLocal() : DateTime.now();
  final processedAtStr = getFormattedDate(date);
  bool shouldDisplayDate = true;
  if (prevItem != null) {
    final prevDate = prevItem.date != null
        ? DateTime.parse(prevItem.date!).toLocal()
        : DateTime.now();
    final prevProcessedAtStr = getFormattedDate(prevDate);
    shouldDisplayDate = prevProcessedAtStr != processedAtStr;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (shouldDisplayDate)
        Column(
          children: [
            Text(
              processedAtStr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: COLOR_GRAY,
                  ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      GenericListTile(
        title: title,
        subtitle: item.action!.name,
        image: item.user?.avatar != null || item.orgUser?.logo != null
            ? NetworkImageAuth(
                imageUrl:
                    '${usersApi.baseUrl}${item.user?.avatar ?? item.orgUser?.logo}',
              )
            : Image.asset('assets/images/avatar_placeholder.png'),
        trailingText: trailingText,
        primaryColor: primaryColor,
        icon: icon,
      ),
    ],
  );
}
