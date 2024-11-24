import 'package:e_commerce/helpers/hive_helper.dart';
import 'package:e_commerce/login/login_screen.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int onboardingNumber = 1;

  final String ndText =
      "It is a long established fact that a reader\nwill be distracted by the readable.";

  @override
  Widget build(BuildContext context) {
    List<String> stText = [
      AppLocalizations.of(context)!.buy_groceries_easily,
      AppLocalizations.of(context)!.we_deliver_grocery,
      AppLocalizations.of(context)!.all_your_home_needs
    ];
    return Scaffold(
      backgroundColor: const Color(0xffEFF9F0),
      body: Padding(
        padding: const EdgeInsets.only(
            right: 22.0, left: 22.0, bottom: 8.0, top: 64),
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Image.asset(
                    "assets/images/onboarding$onboardingNumber.png")),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                      child: CustomText(
                    text: stText[onboardingNumber - 1],
                    textAlign: TextAlign.center,
                    textSize: 24,
                    textWeight: FontWeight.bold,
                  )),
                  Expanded(
                      child: CustomText(
                    text: ndText,
                    textAlign: TextAlign.center,
                    textWeight: FontWeight.w400,
                    textSize: 14,
                  )),
                  Expanded(
                      child: Container(
                          width: 56,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            iconSize: 24,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                onboardingNumber == 2
                                    ? HiveHelper.inFirstTime()
                                    : null;
                                onboardingNumber < 3
                                    ? onboardingNumber++
                                    : Get.to(LoginScreen());
                              });
                            },
                          )))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
