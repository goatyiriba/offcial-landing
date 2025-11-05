import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class OneAppSection extends StatefulWidget {
  const OneAppSection({super.key});

  @override
  State<OneAppSection> createState() => _OneAppSectionState();
}

class _OneAppSectionState extends State<OneAppSection>
    with TickerProviderStateMixin {
  late AnimationController _titleFadeController;
  late AnimationController _walletsMorphingController;
  late AnimationController _personMorphingController;
  late AnimationController _qrCodeMorphingController;
  // Controllers pour mobile
  late AnimationController _noteFadeController;
  late AnimationController _descriptionFadeController;

  late Animation<double> _titleFadeAnimation;
  late Animation<double> _walletsScaleAnimation;
  late Animation<double> _walletsOpacityAnimation;
  late Animation<double> _personScaleAnimation;
  late Animation<double> _personOpacityAnimation;
  // Animations pour mobile
  late Animation<double> _noteFadeAnimation;
  late Animation<double> _descriptionFadeAnimation;

  bool _hasAnimated = false;
  Worker? _sectionIndexWorker;

  @override
  void initState() {
    super.initState();

    // Animation fade in pour le titre "Une App\npour tout."
    _titleFadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleFadeController, curve: Curves.easeOut),
    );

    // Animation de morphing pour wallets_frame.png
    _walletsMorphingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _walletsScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _walletsMorphingController,
        curve: Curves.easeOut,
      ),
    );
    _walletsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _walletsMorphingController,
        curve: Curves.easeIn,
      ),
    );

    // Animation de morphing pour person1.jpg
    _personMorphingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _personScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _personMorphingController,
        curve: Curves.easeOut,
      ),
    );
    _personOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _personMorphingController,
        curve: Curves.easeIn,
      ),
    );

    // Animations pour mobile
    _noteFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _noteFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _noteFadeController, curve: Curves.easeOut),
    );

    _descriptionFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _descriptionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _descriptionFadeController, curve: Curves.easeOut),
    );

    // Écouter les changements de section
    _listenToSectionChanges();
  }

  void _listenToSectionChanges() {
    final controller = Get.find<LandingController>();
    _sectionIndexWorker = ever(controller.currentSectionIndex, (int index) {
      if (index == 4 && mounted) {
        // Section oneApp est active (index 4)
        if (_hasAnimated) {
          // S'assurer que les animations restent à leur état final
          if (_titleFadeController.value != 1.0) {
            _titleFadeController.value = 1.0;
          }
          if (_walletsMorphingController.value != 1.0) {
            _walletsMorphingController.value = 1.0;
          }
          if (_personMorphingController.value != 1.0) {
            _personMorphingController.value = 1.0;
          }
          if (_qrCodeMorphingController.value != 1.0) {
            _qrCodeMorphingController.value = 1.0;
          }
          if (_noteFadeController.value != 1.0) {
            _noteFadeController.value = 1.0;
          }
          if (_descriptionFadeController.value != 1.0) {
            _descriptionFadeController.value = 1.0;
          }
        } else {
          // Démarrer les animations
          _startAnimations();
        }
      }
    });

    // Vérifier si on est déjà sur cette section au chargement initial
    if (controller.currentSectionIndex.value == 4) {
      if (!_hasAnimated) {
        _startAnimations();
      }
    }
  }

  void _startAnimations() {
    if (!_hasAnimated && mounted) {
      _hasAnimated = true;
      final size = MediaQuery.of(Get.context!).size;
      final isMobile = size.width < 600;

      if (isMobile) {
        // Animations séquentielles pour mobile
        // 1. Titre (déjà visible avec subtitle)
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _titleFadeController.forward();
          }
        });
        // 2. Note
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _noteFadeController.forward();
          }
        });
        // 3. Wallets frame
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _walletsMorphingController.forward();
          }
        });
        // 4. Description
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (mounted) {
            _descriptionFadeController.forward();
          }
        });
        // 5. Person image (group.jpg)
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) {
            _personMorphingController.forward();
          }
        });
      } else {
        // Animations pour desktop
        // 1. Titre
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _titleFadeController.forward();
          }
        });
        // 2. Wallets frame
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _walletsMorphingController.forward();
          }
        }); 
        // 3. Person image
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _personMorphingController.forward();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _sectionIndexWorker?.dispose();
    _sectionIndexWorker = null;
    _titleFadeController.dispose();
    _walletsMorphingController.dispose();
    _personMorphingController.dispose();
    _qrCodeMorphingController.dispose();
    _noteFadeController.dispose();
    _descriptionFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.white,
      child: isMobile
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // 1. Subtitle + Title
                    _buildAppTextMobile(),
                    const SizedBox(height: 15),
                    // 2. Note
                    _buildNoteMobile(),
                    const SizedBox(height: 20),
                    // 3. Wallets frame
                    _buildWalletsFrameMobile(),
                    const SizedBox(height: 40),
                    // 4. Description
                    _buildDescriptionMobile(),
                    const SizedBox(height: 20),
                    // 5. Person image (group.jpg)
                    _buildPersonImageMobile(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                              padding: const EdgeInsets.only(right: 60, top: 10),
                              child: _buildAppText(),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: _buildAppVisuals(),
                            ),
                            ],
                          ),
                      )
                    ],
                  ),
                ),
              ),
          ),
    );
  }

  Widget _buildAppText() {
    final controller = Get.find<LandingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Subtitle statique
        Obx(() => Text(
          AppTranslations.AppTranslations.oneAppSubtitle(controller.currentLang),
          style: Get.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: AppColors.grey,
          ),
        )),
        const SizedBox(height: 15),
        
        // Titre avec animation fade in
        FadeTransition(
          opacity: _titleFadeAnimation,
          child: Obx(() => Text(
            AppTranslations.AppTranslations.oneAppTitle(controller.currentLang),
            style: Get.textTheme.displayMedium?.copyWith(
              fontSize: 56,
              height: 1.1,
            ),
          )),
        ),
        const SizedBox(height: 25),
        
        // Description statique
        Obx(() => Text(
          AppTranslations.AppTranslations.oneAppDescription(controller.currentLang),
          style: Get.textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.6,
          ),
        )),
      ],
    );
  }

  Widget _buildAppVisuals() {
    final controller = Get.find<LandingController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 650,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Bloc gauche - wallets_frame avec note
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Note statique
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 20),
                    child: Obx(() => Text(
                      AppTranslations.AppTranslations.oneAppNote(controller.currentLang),
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    )),
                  ),
                  // Image wallets_frame avec animation
                  AnimatedBuilder(
                    animation: _walletsMorphingController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _walletsScaleAnimation.value,
                        alignment: Alignment.topCenter,
                        child: Opacity(
                          opacity: _walletsOpacityAnimation.value,
                          child:               Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/wallets_frame.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Bloc droit - person1.jpg
            Expanded(
              flex: 3,
              child: AnimatedBuilder(
                animation: _personMorphingController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _personScaleAnimation.value,
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: _personOpacityAnimation.value,
                      child: SizedBox(
                        height: 430,
                        child: ClipRRect(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Image en arrière-plan
                              Image.asset(
                                'assets/images/person1.jpg',
                                fit: BoxFit.cover,
                              ),
                              // Overlay avec badge @kab304
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          ),
        );
      },
    );
  }

  // Méthodes pour mobile
  Widget _buildAppTextMobile() {
    final controller = Get.find<LandingController>();
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtitle
          Obx(() => Text(
            AppTranslations.AppTranslations.oneAppSubtitle(controller.currentLang),
            style: Get.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          )),
          const SizedBox(height: 10),
          
          // Titre avec animation fade in
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: Obx(() => Text(
              controller.currentLang == AppTranslations.AppTranslations.en
              ? "One app for everything"
              : "Une App pour tout.",
              style: Get.textTheme.displayMedium?.copyWith(
                fontSize: 30,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteMobile() {
    final controller = Get.find<LandingController>();
    return FadeTransition(
      opacity: _noteFadeAnimation,
      child: Obx(() => Text(
        AppTranslations.AppTranslations.oneAppNote(controller.currentLang),
        style: Get.textTheme.bodyMedium?.copyWith(
          fontSize: 12,
        ),
      )),
    );
  }

  Widget _buildWalletsFrameMobile() {
    return AnimatedBuilder(
      animation: _walletsMorphingController,
      builder: (context, child) {
        return Transform.scale(
          scale: _walletsScaleAnimation.value,
          alignment: Alignment.center,
          child: Opacity(
            opacity: _walletsOpacityAnimation.value,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/wallets_frame.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionMobile() {
    final controller = Get.find<LandingController>();
    return FadeTransition(
      opacity: _descriptionFadeAnimation,
      child: Obx(() => Text(
        AppTranslations.AppTranslations.oneAppDescription(controller.currentLang)
            .replaceAll('\n', ' '),
        style: Get.textTheme.bodyLarge,
      )),
    );
  }

  Widget _buildPersonImageMobile() {
    return AnimatedBuilder(
      animation: _personMorphingController,
      builder: (context, child) {
        return Transform.scale(
          scale: _personScaleAnimation.value,
          alignment: Alignment.center,
          child: Opacity(
            opacity: _personOpacityAnimation.value,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF04E4E),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/group.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}