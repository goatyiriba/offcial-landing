import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class ConnectedSection extends StatefulWidget {
  const ConnectedSection({super.key});

  @override
  State<ConnectedSection> createState() => _ConnectedSectionState();
}

class _ConnectedSectionState extends State<ConnectedSection>
    with TickerProviderStateMixin {
  late AnimationController _textsFadeController;
  late AnimationController _imageMorphingController;

  late Animation<double> _textsFadeAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageOpacityAnimation;

  bool _hasAnimated = false;
  Worker? _sectionIndexWorker;

  @override
  void initState() {
    super.initState();

    // Animation fade in pour les textes
    _textsFadeController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _textsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textsFadeController, curve: Curves.easeOut),
    );

    // Animation de morphing pour l'image group.jpg
    _imageMorphingController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _imageScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageMorphingController,
        curve: Curves.easeOut,
      ),
    );
    _imageOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageMorphingController,
        curve: Curves.easeIn,
      ),
    );

    // Écouter les changements de section
    _listenToSectionChanges();
  }

  void _listenToSectionChanges() {
    final controller = Get.find<LandingController>();
    _sectionIndexWorker = ever(controller.currentSectionIndex, (int index) {
      if (index == 5 && mounted) {
        // Section connected est active (index 5)
        if (_hasAnimated) {
          // S'assurer que les animations restent à leur état final
          if (_textsFadeController.value != 1.0) {
            _textsFadeController.value = 1.0;
          }
          if (_imageMorphingController.value != 1.0) {
            _imageMorphingController.value = 1.0;
          }
        } else {
          // Démarrer les animations
          _startAnimations();
        }
      }
    });

    // Vérifier si on est déjà sur cette section au chargement initial
    if (controller.currentSectionIndex.value == 5) {
      if (!_hasAnimated) {
        _startAnimations();
      }
    }
  }

  void _startAnimations() {
    if (!_hasAnimated && mounted) {
      _hasAnimated = true;
      // D'abord, fade in des textes
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _textsFadeController.forward();
        }
      });
      // Puis, après la fin de l'animation des textes, démarrer le morphing de l'image
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          _imageMorphingController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _sectionIndexWorker?.dispose();
    _sectionIndexWorker = null;
    _textsFadeController.dispose();
    _imageMorphingController.dispose();
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 400,
            vertical: isMobile ? 20 : 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - (isMobile ? 40 : 80),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: isMobile
                  ? [
                      // Version mobile : Subtitle + Title, puis Image, puis Description
                      // 1. Subtitle + Title (animée en fade in)
                      FadeTransition(
                        opacity: _textsFadeAnimation,
                        child: _buildMobileHeaderSection(),
                      ),
                      SizedBox(height: isMobile ? 20 : 30),
                      // 2. Image de groupe (animée en morphing)
                      _buildConnectedImage(isMobile, size),
                      SizedBox(height: isMobile ? 20 : 30),
                      // 3. Description (animée en fade in, sans sauts de ligne)
                      FadeTransition(
                        opacity: _textsFadeAnimation,
                        child: _buildMobileDescriptionSection(),
                      ),
                    ]
                  : [
                      // Version desktop : structure originale
                      FadeTransition(
                        opacity: _textsFadeAnimation,
                        child: _buildTextSection(),
                      ),
                      SizedBox(height: isMobile ? 20 : 30),
                      _buildConnectedImage(isMobile, size),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    final controller = Get.find<LandingController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne de gauche
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                AppTranslations.AppTranslations.connectedSubtitle(controller.currentLang),
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
              )),
              const SizedBox(height: 20),
              Obx(() => Text(
                AppTranslations.AppTranslations.connectedTitle(controller.currentLang),
                style: Get.textTheme.displayMedium?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              )),
            ],
          ),
        ),
        
        const SizedBox(width: 80),
        
        // Colonne de droite
        Expanded(
          flex: 1,
          child: Obx(() => Text(
            AppTranslations.AppTranslations.connectedDescription(controller.currentLang),
            style: Get.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.8,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildMobileHeaderSection() {
    final controller = Get.find<LandingController>();
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
              AppTranslations.AppTranslations.connectedSubtitle(controller.currentLang),
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
            )),
            const SizedBox(height: 12),
            Obx(() => Text(
              AppTranslations.AppTranslations.connectedTitle(controller.currentLang),
              style: Get.textTheme.displayMedium?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
              textAlign: TextAlign.start,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileDescriptionSection() {
    final controller = Get.find<LandingController>();
    return Obx(() => Text(
      AppTranslations.AppTranslations.connectedDescription(controller.currentLang)
          .replaceAll('\n', ' '),
      style: Get.textTheme.bodyLarge?.copyWith(
        fontSize: 14,
        height: 1.6,
      ),
    ));
  }

  Widget _buildConnectedImage(bool isMobile, Size size) {
    final maxImageHeight = isMobile 
        ? (size.height * 0.8).clamp(200.0, 400.0)
        : (size.height * 0.5).clamp(400.0, 600.0);
    
    return AnimatedBuilder(
      animation: _imageMorphingController,
      builder: (context, child) {
        return Transform.scale(
          scale: _imageScaleAnimation.value,
          alignment: Alignment.center,
          child: Opacity(
            opacity: _imageOpacityAnimation.value,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: maxImageHeight,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/group.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: maxImageHeight,
                      color: AppColors.lightGrey,
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: AppColors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}