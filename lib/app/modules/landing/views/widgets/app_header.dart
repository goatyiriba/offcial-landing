import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class AppHeader extends GetView<LandingController> {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SizedBox(
            width: isMobile ? 120 : 150,
            height: isMobile ? 40 : 50,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              height: isMobile ? 40 : 50,
              fit: BoxFit.contain,
            ),
          ),
          
          // Navigation Buttons
          if (!isMobile)
            Obx(() => Row(
              children: [
                ElevatedButton(
                  onPressed: controller.downloadApp,
                  child: Text(AppTranslations.AppTranslations.downloadApp(controller.currentLang)),
                ),
                const SizedBox(width: 20),
                
                // Language Switcher
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: controller.switchLanguage,
                    child: Row(
                      children: [
                        Text(
                          'FR',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: controller.currentLang == AppTranslations.AppTranslations.fr 
                                ? FontWeight.w700 
                                : FontWeight.normal,
                            color: controller.currentLang == AppTranslations.AppTranslations.fr
                                ? AppColors.primary
                                : AppColors.darkGrey,
                          ),
                        ),
                        Text(
                          ' | ',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        Text(
                          'ENG',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: controller.currentLang == AppTranslations.AppTranslations.en 
                                ? FontWeight.w700 
                                : FontWeight.normal,
                            color: controller.currentLang == AppTranslations.AppTranslations.en
                                ? AppColors.primary
                                : AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
          else
            Obx(() => GestureDetector(
              onTap: controller.switchLanguage,
              child: Row(
                children: [
                  Text(
                    'FR',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: controller.currentLang == AppTranslations.AppTranslations.fr 
                          ? FontWeight.w700 
                          : FontWeight.normal,
                      color: controller.currentLang == AppTranslations.AppTranslations.fr
                          ? AppColors.primary
                          : AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    ' | ',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    'ENG',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: controller.currentLang == AppTranslations.AppTranslations.en 
                          ? FontWeight.w700 
                          : FontWeight.normal,
                      color: controller.currentLang == AppTranslations.AppTranslations.en
                          ? AppColors.primary
                          : AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}