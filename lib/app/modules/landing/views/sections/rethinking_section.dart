import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class RethinkingSection extends StatefulWidget {
  const RethinkingSection({super.key});

  @override
  State<RethinkingSection> createState() => _RethinkingSectionState();
}

class _RethinkingSectionState extends State<RethinkingSection>
    with TickerProviderStateMixin {
  late AnimationController _morphingController;
  late AnimationController _firstTextController;
  late AnimationController _secondTextController;

  late Animation<double> _morphingScaleAnimation;
  late Animation<double> _firstTextFadeAnimation;
  late Animation<Offset> _firstTextSlideAnimation;
  late Animation<double> _secondTextFadeAnimation;
  late Animation<Offset> _secondTextSlideAnimation;

  bool _hasAnimated = false;
  bool _morphingStarted = false;
  Worker? _sectionIndexWorker;

  @override
  void initState() {
    super.initState();

    // Animation pour le morphing de l'image
    // Commence à une petite taille (comme dans hero_section) et s'agrandit pour remplir l'écran
    _morphingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Scale de ~0.3-0.4 (taille initiale) à 2.0+ pour remplir tout l'écran
    _morphingScaleAnimation = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(
        parent: _morphingController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation pour le premier texte
    _firstTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _firstTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _firstTextController, curve: Curves.easeOut),
    );
    _firstTextSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _firstTextController, curve: Curves.easeOut),
    );

    // Animation pour le second texte
    _secondTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _secondTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondTextController, curve: Curves.easeOut),
    );
    _secondTextSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _secondTextController, curve: Curves.easeOut),
    );

    // Écouter les changements de section pour déclencher l'animation
    _listenToSectionChanges();
  }

  void _listenToSectionChanges() {
    final controller = Get.find<LandingController>();
    _sectionIndexWorker = ever(controller.currentSectionIndex, (int index) {
      if (index == 1 && mounted) {
        // Section rethinking est active (index 1)
        // Si l'animation de morphing est déjà complète, s'assurer qu'elle reste à la fin
        if (_morphingStarted && _morphingController.isCompleted) {
          // Animation déjà complète, s'assurer qu'elle reste à 1.0
          if (_morphingController.value != 1.0) {
            _morphingController.value = 1.0;
          }
        } else if (!_morphingStarted) {
          // Démarrer l'animation de morphing
          _morphingStarted = true;
          _morphingController.forward();
        }
        
        // Si les animations des textes sont déjà complètes, s'assurer qu'elles restent à la fin
        if (_hasAnimated) {
          if (_firstTextController.value != 1.0) {
            _firstTextController.value = 1.0;
          }
          if (_secondTextController.value != 1.0) {
            _secondTextController.value = 1.0;
          }
        } else {
          // Démarrer les animations des textes après le morphing
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted && !_hasAnimated) {
              _hasAnimated = true;
              _firstTextController.forward();
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) {
                  _secondTextController.forward();
                }
              });
            }
          });
        }
      }
      // Ne pas réinitialiser quand on quitte la section pour conserver l'état
    });

    // Vérifier si on est déjà sur cette section au chargement initial
    if (controller.currentSectionIndex.value == 1) {
      if (!_morphingStarted) {
        _morphingStarted = true;
        _morphingController.forward();
      }
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && !_hasAnimated) {
          _hasAnimated = true;
          _firstTextController.forward();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              _secondTextController.forward();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _sectionIndexWorker?.dispose();
    _sectionIndexWorker = null;
    _morphingController.dispose();
    _firstTextController.dispose();
    _secondTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.find<LandingController>();
    
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image de background avec animation de morphing
          AnimatedBuilder(
            animation: _morphingController,
            builder: (context, child) {
              return ClipRect(
                child: Center(
                  child: Transform.scale(
                    scale: _morphingScaleAnimation.value,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Image.asset(
                        'assets/images/bg_people_group.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Overlay sombre qui s'intensifie avec le morphing
          AnimatedBuilder(
            animation: _morphingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.3 + (0.2 * _morphingScaleAnimation.value / 2.0),
                  ),
                ),
              );
            },
          ),
          
          // Contenu avec les textes animés
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width < 600 ? 30 : 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premier texte
                  SlideTransition(
                    position: _firstTextSlideAnimation,
                    child: FadeTransition(
                      opacity: _firstTextFadeAnimation,
                      child: Obx(() => Text(
                        AppTranslations.AppTranslations.rethinkingText1(controller.currentLang),
                        textAlign: TextAlign.start,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Second texte
                  SlideTransition(
                    position: _secondTextSlideAnimation,
                    child: FadeTransition(
                      opacity: _secondTextFadeAnimation,
                      child: Obx(() => Text(
                        AppTranslations.AppTranslations.rethinkingText2(controller.currentLang),
                        textAlign: TextAlign.start,
                        style: Get.textTheme.displayMedium?.copyWith(
                          fontSize: size.width < 600 ? 30 : 64,
                          color: AppColors.white,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}