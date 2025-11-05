import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class SecuritySection extends StatefulWidget {
  const SecuritySection({super.key});

  @override
  State<SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends State<SecuritySection>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _taglineController;
  late AnimationController _titleController;
  late AnimationController _blockController;
  
  late Animation<double> _taglineFadeAnimation;
  late Animation<Offset> _taglineSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _blockFadeAnimation;
  late Animation<Offset> _blockSlideAnimation;

  bool _hasAnimated = false;
  bool _lottieCompleted = false;
  Worker? _sectionIndexWorker;

  @override
  void initState() {
    super.initState();

    // Controller pour l'animation Lottie
    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_lottieCompleted) {
        _onLottieComplete();
      }
    });

    // Animation pour le tagline
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );
    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // Animation pour le titre
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );

    // Animation pour le bloc
    _blockController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _blockFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blockController, curve: Curves.easeOut),
    );
    _blockSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _blockController, curve: Curves.easeOut),
    );

    // Écouter les changements de section
    _listenToSectionChanges();
  }

  void _listenToSectionChanges() {
    final controller = Get.find<LandingController>();
    _sectionIndexWorker = ever(controller.currentSectionIndex, (int index) {
      if (index == 2 && mounted) {
        // Section security est active (index 2)
        // Si les animations sont déjà complètes, s'assurer qu'elles restent à leur état final
        if (_hasAnimated) {
          if (_taglineController.value != 1.0) {
            _taglineController.value = 1.0;
          }
          if (_titleController.value != 1.0) {
            _titleController.value = 1.0;
          }
          if (_blockController.value != 1.0) {
            _blockController.value = 1.0;
          }
        } else {
          // Démarrer les animations des textes immédiatement, indépendamment de Lottie
          _startTextAnimations();
        }
      }
    });

    // Vérifier si on est déjà sur cette section au chargement initial
    if (controller.currentSectionIndex.value == 2) {
      // Démarrer les animations des textes immédiatement
      if (!_hasAnimated) {
        _startTextAnimations();
      }
    }
  }

  void _onLottieComplete() {
    if (mounted && !_lottieCompleted) {
      _lottieCompleted = true;
      // L'animation Lottie est terminée, mais les textes sont déjà indépendants
    }
  }

  void _startTextAnimations() {
    if (!_hasAnimated && mounted) {
      _hasAnimated = true;
      // Tagline d'abord
      _taglineController.forward();
      // Titre après 200ms
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _titleController.forward();
        }
      });
      // Bloc après 400ms
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _blockController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _sectionIndexWorker?.dispose();
    _sectionIndexWorker = null;
    _lottieController.dispose();
    _taglineController.dispose();
    _titleController.dispose();
    _blockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      color: AppColors.primary,
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // iPhone frame (plus petit)
            Positioned(
              top: size.height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/iPhone_frame.svg',
                  width: isMobile ? 160 : 280,
                  height: isMobile ? 330 : 580,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        
            // Wespee cadenas (animation Lottie)
            Positioned(
              top: size.height * 0.10,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: isMobile ? 35 : 55,
                  height: isMobile ? 50 : 75,
                  child: Lottie.asset(
                    'assets/animations/wespee_cadenas.json',
                    controller: _lottieController,
                    fit: BoxFit.contain,
                    onLoaded: (composition) {
                      _lottieController.duration = composition.duration;
                      _lottieController.forward();
                    },
                    repeat: false,
                  ),
                ),
              ),
            ),
        
            // Colonne principale
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Réduit l'espace pour remonter le contenu
                      SizedBox(height: isMobile ? 200 : 190),
        
                    // Tagline (animé)
                    SlideTransition(
                      position: _taglineSlideAnimation,
                      child: FadeTransition(
                        opacity: _taglineFadeAnimation,
                        child: Obx(() => Text(
                          AppTranslations.AppTranslations.securityTagline(Get.find<LandingController>().currentLang),
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 13 : 15,
                            color: AppColors.darkGrey,
                          ),
                        )),
                      ),
                    ),
                    SizedBox(height: isMobile ? 10 : 15),
        
                    // Titre (animé)
                    SlideTransition(
                      position: _titleSlideAnimation,
                      child: FadeTransition(
                        opacity: _titleFadeAnimation,
                        child: Obx(() => Text(
                          AppTranslations.AppTranslations.securityTitle(Get.find<LandingController>().currentLang),
                          textAlign: TextAlign.center,
                          style: Get.textTheme.displayLarge?.copyWith(
                            fontSize: isMobile ? 36 : 60,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            height: 1.2,
                          ),
                        )),
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 30),
        
                    // Bloc avec 2 parties de couleurs différentes (animé)
                    SlideTransition(
                      position: _blockSlideAnimation,
                      child: FadeTransition(
                        opacity: _blockFadeAnimation,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 700,
                            minHeight: isMobile ? 220 : 280,
                            maxHeight: isMobile ? 600 : 800,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: isMobile
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Partie gauche (blanc)
                                      Container(
                                        padding: EdgeInsets.all(isMobile ? 15 : 40),
                                        color: AppColors.white,
                                        child: _buildSecurityText(isMobile),
                                      ),
                                      // Partie droite (gris)
                                      Container(
                                                padding: EdgeInsets.only(
                                              right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 60 : 150,
                                            ),
                                        color: AppColors.lightGrey,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: _buildSecuFrame(isMobile),
                                        ),
                                      ),
                                    ],
                                  )
                                : IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Partie gauche (blanc) - 2/3
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: EdgeInsets.all(isMobile ? 20 : 40),
                                            color: AppColors.white,
                                            child: _buildSecurityText(isMobile),
                                          ),
                                        ),
                                        // Partie droite (gris) - 1/3
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 40 : 150,
                                            ),
                                            color: AppColors.lightGrey,
                                            child: _buildSecuFrame(isMobile),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityText(bool isMobile) {
    final controller = Get.find<LandingController>();
    return Obx(() => Text(
      AppTranslations.AppTranslations.securityText(controller.currentLang),
      style: Get.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        height: 2.0,
        color: AppColors.black,
      ),
    ));
  }

  Widget _buildSecuFrame(bool isMobile) {
    return SvgPicture.asset(
      'assets/images/secu_frame.svg',
      width: isMobile ? 120 : null,
      height: isMobile ? 250 : null,
      fit: BoxFit.contain,
    );
  }
}
