import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/widgets/RecentActivity.dart';
import 'package:nadi_user_app/widgets/app_back.dart';

class ViewAllLogs extends StatefulWidget {
  const ViewAllLogs({super.key});

  @override
  State<ViewAllLogs> createState() => _ViewAllLogsState();
}

class _ViewAllLogsState extends State<ViewAllLogs> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
                top: 10,
                bottom: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(icon: Icons.arrow_back, onPressed: () {
                    context.pop();
                  }),
                  Text(
                  l10n.myRecentActivity,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.large,
                    ),
                  ),
                const  Text(""),
                ],
              ),
            ),

           const SizedBox(height: 10,),
           const Divider(),

             Expanded(child: RecentActivity( limitLogs: false,))
          ],
        ),
      ),
    );
  }
}
