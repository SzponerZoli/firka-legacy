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

// import 'dart:async';

import 'dart:io' show Platform;
import 'package:refilc/api/login.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_mobile_ui/screens/login/school_input/school_input.dart';
import 'package:refilc_mobile_ui/screens/settings/privacy_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.i18n.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:refilc_mobile_ui/screens/login/kreten_login.dart'; //new library for new web login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.back = false});

  final bool back;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = SchoolInputController();
  final _scrollController = ScrollController();
  final codeController = TextEditingController();

  LoginState _loginState = LoginState.normal;
  bool showBack = false;

  // Scaffold Gradient background
  // final LinearGradient _backgroundGradient = const LinearGradient(
  //   colors: [
  //     Color.fromARGB(255, 61, 122, 244),
  //     Color.fromARGB(255, 23, 77, 185),
  //     Color.fromARGB(255, 7, 42, 112),
  //   ],
  //   begin: Alignment(-0.8, -1.0),
  //   end: Alignment(0.8, 1.0),
  //   stops: [-1.0, 0.0, 1.0],
  // );

  late String tempUsername = '';

  @override
  void initState() {
    super.initState();
    showBack = widget.back;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.of(context).loginBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    // FilcAPI.getSchools().then((schools) {
    //   if (schools != null) {
    //     schoolController.update(() {
    //       schoolController.schools = schools;
    //     });
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
    //       content: Text("schools_error".i18n,
    //           style: const TextStyle(color: Colors.white)),
    //       backgroundColor: AppColors.of(context).red,
    //       context: context,
    //     ));
    //   }
    // });
  }

  double paddingTop = 0;
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/showcase1.png'), context);
    precacheImage(const AssetImage('assets/images/showcase2.png'), context);
    precacheImage(const AssetImage('assets/images/showcase3.png'), context);
    precacheImage(const AssetImage('assets/images/showcase4.png'), context);

    if (Platform.isIOS) {
      paddingTop = 0;
    } else if (Platform.isAndroid) {
      paddingTop = 20;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.of(context).loginBackground),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            decoration: BoxDecoration(color: AppColors.of(context).loginBackground),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                children: [
                  // app icon
                  Padding(
                      padding: EdgeInsets.only(left: 24, top: paddingTop),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/ic_rounded.png',
                            width: 30.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Firka',
                            style: TextStyle(
                                color: AppColors.of(context).loginPrimary,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: showBack
                                ? BackButton(color: AppColors.of(context).text)
                                : const SizedBox(height: 48.0),
                          ),
                        ],
                      )),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        //login buttons and ui starts here
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 21),
                          CarouselSlider(
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.height,
                                viewportFraction: 1,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 6),
                                pauseAutoPlayOnTouch: true),
                            items: [1, 2, 3, 4].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "welcome_title_$i".i18n,
                                                style: TextStyle(
                                                    color: AppColors.of(context).loginPrimary,
                                                    fontSize: 19,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3),
                                              ),
                                              const SizedBox(
                                                  height: 14.375), //meth
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Text(
                                                  "welcome_text_$i".i18n,
                                                  style: TextStyle(
                                                      color: AppColors.of(context).loginSecondary,
                                                      fontFamily: 'FigTree',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                      height: 1.3),
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 15.625),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Image.asset(
                                              'assets/images/showcase$i.png'))
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.of(context).loginBackground.withAlpha(0), AppColors.of(context).loginBackground],
                            stops: [0, 0.12],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 50,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: FilledButton(
                                      style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ))),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          isScrollControlled:
                                              true, // This ensures the modal accommodates input fields properly
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.9 +
                                                  MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                              decoration: BoxDecoration(
                                                color: AppColors.of(context).loginBackground,
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(24.0),
                                                  topLeft:
                                                      Radius.circular(24.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 18),
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                          AppColors.of(context).loginPrimary,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  2.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  2.0),
                                                        ),
                                                      ),
                                                      width: 40,
                                                      height: 4,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 14,
                                                              left: 14,
                                                              bottom: 24),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child:
                                                              KretenLoginWidget(
                                                            onLogin:
                                                                (String code) {
                                                              codeController
                                                                  .text = code;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ).then((value) {
                                          // After closing the modal bottom sheet, check if the code is set
                                          if (codeController.text.isNotEmpty) {
                                            // Call your API after retrieving the code
                                            _NewLoginAPI(context: context);
                                          }
                                        });
                                      },
                                      child: Text(
                                        "login_w_kreta_acc".i18n,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            color: AppColors.of(context).loginPrimary,
                                            fontWeight: FontWeight.w700),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 19),
                              // privacy policy
                              GestureDetector(
                                onTap: () => PrivacyView.show(context),
                                child: Text(
                                  'privacy'.i18n,
                                  style: TextStyle(
                                    color: AppColors.of(context).loginSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_loginState == LoginState.missingFields ||
                      _loginState == LoginState.invalidGrant ||
                      _loginState == LoginState.failed)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 12.0, right: 12.0),
                      child: Text(
                        [
                          "missing_fields",
                          "invalid_grant",
                          "error"
                        ][_loginState.index]
                            .i18n,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // privacy policy
                  GestureDetector(
                    onTap: () => PrivacyView.show(context),
                    child: Text(
                      'privacy'.i18n,
                      style: TextStyle(
                        color: AppColors.of(context).loginSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _loginAPI({required BuildContext context}) {
  //   String username = usernameController.text;
  //   String password = passwordController.text;

  //   tempUsername = username;

  //   if (username == "" ||
  //       password == "" ||
  //       schoolController.selectedSchool == null) {
  //     return setState(() => _loginState = LoginState.missingFields);
  //   }

  //   // ignore: no_leading_underscores_for_local_identifiers
  //   void _callAPI() {
  //     loginAPI(
  //         username: username,
  //         password: password,
  //         instituteCode: schoolController.selectedSchool!.instituteCode,
  //         context: context,
  //         onLogin: (user) {
  //           ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
  //             context: context,
  //             brightness: Brightness.light,
  //             content: Text("welcome".i18n.fill([user.name]),
  //                 overflow: TextOverflow.ellipsis),
  //           ));
  //         },
  //         onSuccess: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //           setSystemChrome(context);
  //           Navigator.of(context).pushReplacementNamed("login_to_navigation");
  //         }).then(
  //       (res) => setState(() {
  //         // if (res == LoginState.invalidGrant &&
  //         //     tempUsername.replaceAll(username, '').length <= 3) {
  //         //   tempUsername = username + ' ';
  //         //   Timer(
  //         //     const Duration(milliseconds: 500),
  //         //     () => _loginAPI(context: context),
  //         //   );
  //         //   // _loginAPI(context: context);
  //         // } else {
  //         _loginState = res;
  //         // }
  //       }),
  //     );
  //   }
  // ignore: non_constant_identifier_names
  void _NewLoginAPI({required BuildContext context}) {
    String code = codeController.text;

    if (code == "") {
      return setState(() => _loginState = LoginState.failed);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _callAPI() {
      newLoginAPI(
          code: code,
          context: context,
          onLogin: (user) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              context: context,
              brightness: Brightness.light,
              content: Text("welcome".i18n.fill([user.name]),
                  overflow: TextOverflow.ellipsis),
            ));
          },
          onSuccess: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            setSystemChrome(context);
            Navigator.of(context).pushReplacementNamed("login_to_navigation");
          }).then(
        (res) => setState(() {
          // if (res == LoginState.invalidGrant &&
          //     tempUsername.replaceAll(username, '').length <= 3) {
          //   tempUsername = username + ' ';
          //   Timer(
          //     const Duration(milliseconds: 500),
          //     () => _loginAPI(context: context),
          //   );
          //   // _loginAPI(context: context);
          // } else {
          _loginState = res;
          // }
        }),
      );
    }

    setState(() => _loginState = LoginState.inProgress);
    _callAPI();
  }
}
