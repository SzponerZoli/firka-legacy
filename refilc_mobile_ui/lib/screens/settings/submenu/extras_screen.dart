/*
    Firka legacy (formely "refilc"), the unofficial client for e-Kréta
    Copyright (C) 2025  Firka team (QwIT development)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

// import 'package:refilc/models/settings.dart';

import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/chips/new_chip.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/ui/mobile/settings/submenu/grade_exporting.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/settings/welcome_message.dart';

import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_mobile_ui/common/action_button.dart';

// import 'package:provider/provider.dart';
import 'submenu_screen.i18n.dart';

class MenuExtrasSettings extends StatelessWidget {
  const MenuExtrasSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(12.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => const ExtrasSettingsScreen()),
      ),
      title: Text("extras".i18n),
      leading: Icon(
        FeatherIcons.edit,
        size: 22.0,
        color: AppColors.of(context).text.withValues(alpha: 0.95),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Provider.of<SettingsProvider>(context)
              .unseenNewFeatures
              .toSet()
              .intersection({'grade_exporting'}).isNotEmpty)
            const NewChip(),
          Icon(
            FeatherIcons.chevronRight,
            size: 22.0,
            color: AppColors.of(context).text.withValues(alpha: 0.95),
          )
        ],
      ),
      borderRadius: borderRadius,
    );
  }
}

class ExtrasSettingsScreen extends StatefulWidget {
  const ExtrasSettingsScreen({super.key});

  @override
  ExtrasSettingsScreenState createState() => ExtrasSettingsScreenState();
}

class ExtrasSettingsScreenState extends State<ExtrasSettingsScreen> {
  late SettingsProvider settingsProvider;
  late UserProvider user;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "extras".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              SplittedPanel(
                padding: const EdgeInsets.only(top: 8.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      if (!Provider.of<PlusProvider>(context, listen: false)
                          .hasScope(PremiumScopes.customGradeRarities)) {
                        return;
                      }

                      // settingsProvider.update(
                      //     gradeOpeningFun: !settingsProvider.gradeOpeningFun);
                      SettingsHelper.surpriseGradeRarityText(
                        context,
                        title: 'rarity_title'.i18n,
                        cancel: 'cancel'.i18n,
                        done: 'done'.i18n,
                        rarities: [
                          "common".i18n,
                          "uncommon".i18n,
                          "rare".i18n,
                          "epic".i18n,
                          "legendary".i18n,
                        ],
                      );
                      setState(() {});
                    },
                    trailingDivider: true,
                    title: Text(
                      "surprise_grades".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withValues(
                            alpha:
                                settingsProvider.gradeOpeningFun ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.gift,
                      size: 22.0,
                      color: AppColors.of(context).text.withValues(
                          alpha: settingsProvider.gradeOpeningFun ? .95 : .25),
                    ),
                    trailing: Switch(
                      onChanged: (v) async {
                        settingsProvider.update(gradeOpeningFun: v);

                        setState(() {});
                      },
                      value: settingsProvider.gradeOpeningFun,
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  WelcomeMessagePanelButton(settingsProvider, user),
                ],
              ),
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  MenuGradeExporting(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ],
              ),
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      if (!settingsProvider.goodStudent) {
                        showDialog(
                          context: context,
                          builder: (context) => WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              title: Text("attention".i18n),
                              content: Text("goodstudent_disclaimer".i18n),
                              actions: [
                                ActionButton(
                                    label: "understand".i18n,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      settingsProvider.update(
                                          goodStudent: true);
                                      Provider.of<GradeProvider>(context,
                                              listen: false)
                                          .convertBySettings();
                                      setState(() {});
                                    })
                              ],
                            ),
                          ),
                        );
                      } else {
                        settingsProvider.update(goodStudent: false);
                        Provider.of<GradeProvider>(context, listen: false)
                            .convertBySettings();
                        setState(() {});
                      }
                    },
                    title: Text(
                      "goodstudent".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withValues(
                            alpha: settingsProvider.goodStudent ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.userCheck,
                      size: 22.0,
                      color: AppColors.of(context).text.withValues(
                          alpha: settingsProvider.goodStudent ? .95 : .25),
                    ),
                    trailing: Switch(
                      onChanged: (v) async {
                        if (v) {
                          showDialog(
                            context: context,
                            builder: (context) => WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                title: Text("attention".i18n),
                                content: Text("goodstudent_disclaimer".i18n),
                                actions: [
                                  ActionButton(
                                      label: "understand".i18n,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        settingsProvider.update(
                                            goodStudent: true);
                                        Provider.of<GradeProvider>(context,
                                                listen: false)
                                            .convertBySettings();
                                        setState(() {});
                                      })
                                ],
                              ),
                            ),
                          );
                        } else {
                          settingsProvider.update(goodStudent: false);
                          Provider.of<GradeProvider>(context, listen: false)
                              .convertBySettings();
                          setState(() {});
                        }
                      },
                      value: settingsProvider.goodStudent,
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      settingsProvider.update(
                          presentationMode: !settingsProvider.presentationMode);
                      setState(() {});
                    },
                    title: Text(
                      "presentation".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withValues(
                            alpha:
                                settingsProvider.presentationMode ? .95 : .25),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.tv,
                      size: 22.0,
                      color: AppColors.of(context).text.withValues(
                          alpha: settingsProvider.presentationMode ? .95 : .25),
                    ),
                    trailing: Switch(
                      onChanged: (v) async {
                        settingsProvider.update(presentationMode: v);
                        setState(() {});
                      },
                      value: settingsProvider.presentationMode,
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
