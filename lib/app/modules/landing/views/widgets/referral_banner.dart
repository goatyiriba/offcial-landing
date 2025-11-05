import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class ReferralBanner extends GetView<LandingController> {
  const ReferralBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: AppColors.secondary,
      child: Text(
        AppTranslations.AppTranslations.referralBanner(controller.currentLang),
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: AppColors.white,
        ),
      ),
    ));
  }
}