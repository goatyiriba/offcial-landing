import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../utils/translations.dart' as AppTranslations;
import '../controllers/landing_controller.dart';
import 'sections/hero_section.dart';
import 'sections/rethinking_section.dart';
import 'sections/security_section.dart';
import 'sections/protection_section.dart';
import 'sections/one_app_section.dart';
import 'sections/connected_section.dart';
import 'sections/footer_section.dart';
import 'widgets/qr_code_widget.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const NextSectionIntent(direction: -1),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const NextSectionIntent(direction: 1),
        },
        child: Actions(
          actions: {
            NextSectionIntent: CallbackAction<NextSectionIntent>(
              onInvoke: (NextSectionIntent intent) {
                final isProtectionSection = controller.currentSectionIndex.value == 3;
                
                if (isProtectionSection) {
                  // Si on est sur la section protection, naviguer entre les frames
                  if (intent.direction > 0) {
                    // Flèche bas : aller au frame suivant ou section suivante
                    if (controller.protectionFrameIndex.value < 1) {
                      // Pas au dernier frame, aller au frame suivant
                      controller.nextProtectionFrame();
                    } else {
                      // Au dernier frame, aller à la section suivante
                      controller.nextSection();
                      controller.protectionFrameIndex.value = 0; // Reset frame
                    }
                  } else {
                    // Flèche haut : aller au frame précédent ou section précédente
                    if (controller.protectionFrameIndex.value > 0) {
                      // Pas au premier frame, aller au frame précédent
                      controller.previousProtectionFrame();
                    } else {
                      // Au premier frame, aller à la section précédente
                      controller.previousSection();
                    }
                  }
                } else {
                  // Sinon, navigation normale entre les sections
                  if (intent.direction > 0) {
                    controller.nextSection();
                  } else {
                    controller.previousSection();
                  }
                }
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            canRequestFocus: true,
            skipTraversal: false,
            child: Obx(() {
              final isProtectionSection = controller.currentSectionIndex.value == 3;
              final isLastProtectionFrame = isProtectionSection && 
                  controller.protectionFrameIndex.value == 1;
              final isFooterSection = controller.currentSectionIndex.value == 6;
              
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isProtectionSection && !isLastProtectionFrame
                    ? null // Let ProtectionSection handle the tap
                    : () {
                        if (isLastProtectionFrame) {
                          // Last frame of protection, move to next section
                          controller.nextSection();
                          controller.protectionFrameIndex.value = 0; // Reset frame
                        } else {
                          controller.nextSection();
                        }
                      },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                    controller.previousSection();
                  } else if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                    controller.nextSection();
                  }
                },
                child: Stack(
                  children: [
                    PageView(
                      controller: controller.pageController,
                      scrollDirection: Axis.vertical,
                      onPageChanged: controller.onPageChanged,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const HeroSection(),
                        const RethinkingSection(),
                        const SecuritySection(),
                        const ProtectionSection(),
                        const OneAppSection(),
                        const ConnectedSection(),
                        const FooterSection(),
                      ],
                    ),
                    
                    // QR Code Widget - caché sur la section Footer et en mobile
                    if (!isFooterSection && MediaQuery.of(context).size.width >= 600)
                      const Positioned(
                        bottom: 40,
                        right: 40,
                        child: QRCodeWidget(),
                      ),
                    
                    // Bouton "Télécharger l'application" pour mobile - caché sur la section Footer
                    if (!isFooterSection && MediaQuery.of(context).size.width < 600)
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Obx(() => GestureDetector(
                            onTap: controller.downloadApp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.25),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(
                                      'assets/images/logo1.svg',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppTranslations.AppTranslations.downloadApp(controller.currentLang),
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NextSectionIntent extends Intent {
  final int direction;
  const NextSectionIntent({required this.direction});
}