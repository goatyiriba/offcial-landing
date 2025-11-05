import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class QRCodeWidget extends GetView<LandingController> {
  const QRCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.downloadApp,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() {
          // Détermine si on doit masquer le texte (sections 1-5)
          final hideText = controller.currentSectionIndex.value >= 1 && 
                            controller.currentSectionIndex.value <= 5;
          // Observer aussi le changement de langue
          final _ = controller.currentLang;
          
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!hideText) ...[
                Text(
                  AppTranslations.AppTranslations.qrCodeDownloadText(controller.currentLang),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/qr-code.svg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}