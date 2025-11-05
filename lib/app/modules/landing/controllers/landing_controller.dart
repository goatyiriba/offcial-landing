import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/section_model.dart';
import '../../../utils/translations.dart' as AppTranslations;

class LandingController extends GetxController {
  // State
  final currentSectionIndex = 0.obs;
  final isScrolling = false.obs;
  
  // Language State
  final currentLanguage = AppTranslations.AppTranslations.fr.obs;
  
  // Protection Section Frame State
  final protectionFrameIndex = 0.obs;
  int? _previousSectionIndex;
  
  // Page Controller
  late PageController pageController;
  
  // Sections
  final List<SectionModel> sections = [
    SectionModel(index: 0, id: 'hero', type: SectionType.hero),
    SectionModel(index: 1, id: 'rethinking', type: SectionType.rethinking),
    SectionModel(index: 2, id: 'security', type: SectionType.security),
    SectionModel(index: 3, id: 'protection', type: SectionType.protection),
    SectionModel(index: 4, id: 'oneApp', type: SectionType.oneApp),
    SectionModel(index: 5, id: 'connected', type: SectionType.connected),
    SectionModel(index: 6, id: 'footer', type: SectionType.footer),
  ];

  int get totalSections => sections.length;
  bool get isFirstSection => currentSectionIndex.value == 0;
  bool get isLastSection => currentSectionIndex.value == totalSections - 1;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Navigation Methods
  void goToSection(int index) {
    if (index < 0 || index >= totalSections || isScrolling.value) return;
    
    isScrolling.value = true;
    currentSectionIndex.value = index;
    
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ).then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        isScrolling.value = false;
      });
    });
  }

  void nextSection() {
    if (isLastSection) {
      goToSection(0); // Retour au début
    } else {
      goToSection(currentSectionIndex.value + 1);
    }
  }

  void previousSection() {
    if (!isFirstSection) {
      goToSection(currentSectionIndex.value - 1);
    }
  }

  void onPageChanged(int index) {
    // Reset protection frame only when entering protection section (index 3)
    if (index == 3 && _previousSectionIndex != 3) {
      protectionFrameIndex.value = 0;
    }
    
    _previousSectionIndex = index;
    currentSectionIndex.value = index;
  }

  // Actions
  void downloadApp() {
    // TODO: Implémenter le téléchargement de l'app
    Get.snackbar(
      AppTranslations.AppTranslations.snackbarDownload(currentLanguage.value),
      AppTranslations.AppTranslations.snackbarDownloadMessage(currentLanguage.value),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }

  void switchLanguage() {
    // Toggle entre FR et EN
    if (currentLanguage.value == AppTranslations.AppTranslations.fr) {
      currentLanguage.value = AppTranslations.AppTranslations.en;
    } else {
      currentLanguage.value = AppTranslations.AppTranslations.fr;
    }
  }
  
  String get currentLang => currentLanguage.value;

  // Protection Section Navigation
  void nextProtectionFrame() {
    if (protectionFrameIndex.value < 1) {
      protectionFrameIndex.value++;
    }
  }

  void previousProtectionFrame() {
    if (protectionFrameIndex.value > 0) {
      protectionFrameIndex.value--;
    }
  }
}