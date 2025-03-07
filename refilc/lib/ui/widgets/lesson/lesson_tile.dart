import 'package:i18n_extension/i18n_extension.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_kreta_api/providers/exam_provider.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
// import 'package:refilc_mobile_ui/common/widgets/exam/exam_view.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/homework/homework_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'lesson_tile.i18n.dart';

class LessonTile extends StatelessWidget {
  const LessonTile(
    this.lesson, {
    super.key,
    this.onTap,
    this.swapDesc = false,
    this.subjectPageView = false,
    this.swapRoom = false,
    this.currentLessonIndicator = true,
    this.padding,
    this.contentPadding,
    this.showSubTiles = true,
  });

  final Lesson lesson;
  final bool swapDesc;
  final void Function()? onTap;
  final bool subjectPageView;
  final bool swapRoom;
  final bool currentLessonIndicator;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final bool showSubTiles;

  @override
  Widget build(BuildContext context) {
    List<Widget> subtiles = [];

    Color accent = Theme.of(context).colorScheme.secondary;
    bool fill = false;
    bool fillLeading = false;
    String lessonIndexTrailing = "";

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    // Only put a trailing . if its a digit
    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    var now = DateTime.now();
    if (lesson.start.isBefore(now) &&
        lesson.end.isAfter(now) &&
        lesson.status?.name != "Elmaradt") {
      fillLeading = true;
    }

    if (lesson.substituteTeacher != null &&
        lesson.substituteTeacher?.name != "") {
      fill = true;
      accent = AppColors.of(context).yellow;
    }

    if (lesson.status?.name == "Elmaradt") {
      fill = true;
      accent = AppColors.of(context).red;
    }

    if (lesson.isEmpty) {
      accent = AppColors.of(context).text.withValues(alpha: 0.6);
    }

    if (!lesson.studentPresence) {
      subtiles.add(LessonSubtile(
        type: LessonSubtileType.absence,
        title: "absence".i18n,
      ));
    }

    if (lesson.homeworkId != "") {
      Homework homework = Provider.of<HomeworkProvider>(context, listen: false)
          .homework
          .firstWhere((h) => h.id == lesson.homeworkId,
              orElse: () => Homework.fromJson({}));

      if (homework.id != "") {
        subtiles.add(LessonSubtile(
          type: LessonSubtileType.homework,
          title: homework.content,
          onPressed: () => HomeworkView.show(homework, context: context),
        ));
      }
    }

    if (lesson.exam != "") {
      Exam exam = Provider.of<ExamProvider>(context, listen: false)
          .exams
          .firstWhere((t) => t.id == lesson.exam,
              orElse: () => Exam.fromJson({}));
      if (exam.id != "") {
        subtiles.add(LessonSubtile(
          type: LessonSubtileType.exam,
          title: exam.description != ""
              ? exam.description
              : exam.mode?.description ?? "exam".i18n,
          // onPressed: () => ExamView.show(exam, context: context),
          onPressed: () => ExamPopup.show(context: context, exam: exam),
        ));
      }
    }

    // String description = '';
    // String room = '';

    final cleanDesc = lesson.description
        .replaceAll(lesson.subject.name.specialChars().toLowerCase(), '');

    // if (!swapDesc) {
    //   if (cleanDesc != "") {
    //     description = lesson.description;
    //   }

    //   // Changed lesson Description
    //   if (lesson.isChanged) {
    //     if (lesson.status?.name == "Elmaradt") {
    //       description = 'cancelled'.i18n;
    //     } else if (lesson.substituteTeacher?.name != "") {
    //       description = 'substitution'.i18n;
    //     }
    //   }

    //   room = lesson.room.replaceAll("_", " ");
    // } else {
    //   description = lesson.room.replaceAll("_", " ");
    // }

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 4.0, top: 7.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: Visibility(
          visible: lesson.subject.id != '' || lesson.isEmpty,
          replacement: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: PanelTitle(title: Text(lesson.name)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: (subtiles.isNotEmpty && showSubTiles) ? 12.0 : 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  minVerticalPadding: cleanDesc == '' ? 12.0 : 0.0,
                  dense: true,
                  onTap: onTap,
                  // onLongPress: kDebugMode ? () => log(jsonEncode(lesson.json)) : null,
                  visualDensity: VisualDensity.compact,
                  contentPadding: contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 4.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  title: !subjectPageView
                      ? Text(
                          !lesson.isEmpty
                              ? lesson.subject.renamedTo ??
                                  lesson.subject.name.capital()
                              : "empty".i18n,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.5,
                              color: fill
                                  ? accent
                                  : AppColors.of(context).text.withValues(
                                      alpha: !lesson.isEmpty ? 1.0 : 0.5),
                              fontStyle: lesson.subject.isRenamed &&
                                      settingsProvider.renamedSubjectsItalics
                                  ? FontStyle.italic
                                  : null),
                        )
                      : Transform.translate(
                          offset: const Offset(0, -2.0),
                          child: Text(
                            "${DateFormat("E, H:mm", I18n.of(context).locale.toString()).format(lesson.start)}-${DateFormat("H:mm").format(lesson.end)}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: fill
                                  ? accent.withValues(alpha: .9)
                                  : AppColors.of(context)
                                      .text
                                      .withValues(alpha: .9),
                            ),
                          ),
                        ),
                  subtitle: !subjectPageView
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     Container(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 6.0, vertical: 3.5),
                            //       decoration: BoxDecoration(
                            //         color: Theme.of(context)
                            //             .colorScheme
                            //             .secondary
                            //             .withValues(alpha: .15),
                            //         borderRadius: BorderRadius.circular(10.0),
                            //       ),
                            //       child: Text(
                            //         lesson.room,
                            //         style: TextStyle(
                            //           height: 1.1,
                            //           fontSize: 12.5,
                            //           fontWeight: FontWeight.w600,
                            //           color: Theme.of(context)
                            //               .colorScheme
                            //               .secondary
                            //               .withValues(alpha: .9),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // if (cleanDesc != '')
                            //   const SizedBox(
                            //     height: 10.0,
                            //   ),
                            if (swapRoom)
                              Container(
                                width: lesson.room.length > 20 ? 111 : null,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.5, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: fill
                                      ? accent.withValues(alpha: .15)
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  lesson.room,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: fill
                                        ? accent.withValues(alpha: 0.9)
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: .9),
                                  ),
                                ),
                              ),
                            if (cleanDesc != '' && !swapRoom)
                              Text(
                                cleanDesc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: fill
                                      ? accent.withValues(alpha: 0.5)
                                      : null,
                                ),
                              ),
                          ],
                        )
                      : null,

                  // subtitle: description != ""
                  //     ? Text(
                  //         description,
                  //         style: const TextStyle(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14.0,
                  //         ),
                  //         maxLines: 1,
                  //         softWrap: false,
                  //         overflow: TextOverflow.ellipsis,
                  //       )
                  //     : null,
                  minLeadingWidth: 34.0,
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Stack(
                        children: [
                          RoundBorderIcon(
                            color: fill ? accent : AppColors.of(context).text,
                            width: 1.0,
                            icon: SizedBox(
                              width: subjectPageView ? 22 : 25,
                              height: subjectPageView ? 22 : 25,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    lesson.lessonIndex + lessonIndexTrailing,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: subjectPageView ? 15.5 : 17.5,
                                      fontWeight: FontWeight.w700,
                                      color: fill ? accent : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Text(
                          //   lesson.lessonIndex + lessonIndexTrailing,
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 30.0,
                          //     fontWeight: FontWeight.w600,
                          //     color: accent,
                          //   ),
                          // ),

                          // Current lesson indicator
                          if (currentLessonIndicator)
                            Transform.translate(
                              offset: const Offset(-22.0, -1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: fillLeading
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withValues(alpha: .3)
                                      : const Color(0x00000000),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    if (fillLeading)
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: .25),
                                        blurRadius: 6.0,
                                      )
                                  ],
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                width: 4.0,
                                height: double.infinity,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  trailing: !lesson.isEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // if (!swapDesc)
                            //   SizedBox(
                            //     width: 52.0,
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(right: 6.0),
                            //       child: Text(
                            //         room,
                            //         textAlign: TextAlign.center,
                            //         overflow: TextOverflow.ellipsis,
                            //         maxLines: 2,
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.w500,
                            //           color: AppColors.of(context)
                            //               .text
                            //               .withValues(alpha: .75),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            if (!swapRoom)
                              Container(
                                width: lesson.room.length > 20 ? 111 : null,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 3.5),
                                decoration: BoxDecoration(
                                  color: fill
                                      ? accent.withValues(alpha: .15)
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  lesson.room,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: fill
                                        ? accent.withValues(alpha: 0.9)
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: .9),
                                  ),
                                ),
                              ),
                            if (!subjectPageView)
                              const SizedBox(
                                width: 10,
                              ),
                            if (!subjectPageView)
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // xix alignment hack :p
                                  const Opacity(
                                      opacity: 0, child: Text("EE:EE")),
                                  Text(
                                    "${DateFormat("H:mm").format(lesson.start)}\n${DateFormat("H:mm").format(lesson.end)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: fill
                                          ? accent.withValues(alpha: .9)
                                          : AppColors.of(context)
                                              .text
                                              .withValues(alpha: .9),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      : null,
                ),

                // Homework & Exams
                if (showSubTiles) ...subtiles,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum LessonSubtileType { homework, exam, absence }

class LessonSubtile extends StatelessWidget {
  const LessonSubtile(
      {super.key, this.onPressed, required this.title, required this.type});

  final Function()? onPressed;
  final String title;
  final LessonSubtileType type;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor = AppColors.of(context).text;

    switch (type) {
      case LessonSubtileType.absence:
        icon = FeatherIcons.slash;
        iconColor = AppColors.of(context).red;
        break;
      case LessonSubtileType.exam:
        icon = FeatherIcons.file;
        break;
      case LessonSubtileType.homework:
        icon = FeatherIcons.home;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Center(
                child: SizedBox(
                  width: 30.0,
                  child: Icon(icon,
                      color: iconColor.withValues(alpha: .75), size: 20.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                  child: Text(
                    title.escapeHtml(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            AppColors.of(context).text.withValues(alpha: .65)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
