import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/referral_banner.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _descriptionController;
  late AnimationController _imageController;
  late AnimationController _subtitleController;

  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _descriptionFadeAnimation;
  late Animation<Offset> _descriptionSlideAnimation;
  late Animation<double> _imageFadeAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<Offset> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation pour le titre principal (commence en premier)
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );

    // Animation pour la description (commence après le titre)
    _descriptionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _descriptionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _descriptionController, curve: Curves.easeOut),
    );
    _descriptionSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _descriptionController, curve: Curves.easeOut),
    );

    // Animation pour l'image (commence après la description)
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );

    // Animation pour le sous-titre (commence en dernier)
    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
    );
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
    );

    // Démarrer les animations séquentiellement après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _startAnimations() {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    
    if (isMobile) {
      // Ordre pour mobile : sous-titre → titre → description → image
      _subtitleController.forward();
      
      // Titre après 200ms
      Future.delayed(const Duration(milliseconds: 200), () {
        _titleController.forward();
      });
      
      // Description après 400ms
      Future.delayed(const Duration(milliseconds: 400), () {
        _descriptionController.forward();
      });
      
      // Image après 600ms
      Future.delayed(const Duration(milliseconds: 600), () {
        _imageController.forward();
      });
    } else {
      // Ordre pour desktop : titre → description → image → sous-titre
      _titleController.forward();
      
      // Description après 200ms
      Future.delayed(const Duration(milliseconds: 200), () {
        _descriptionController.forward();
      });
      
      // Image après 400ms
      Future.delayed(const Duration(milliseconds: 400), () {
        _imageController.forward();
      });
      
      // Sous-titre en dernier après 600ms
      Future.delayed(const Duration(milliseconds: 600), () {
        _subtitleController.forward();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.find<LandingController>();
    final isMobile = size.width < 600;

    return SizedBox(
      width: size.width,
      height: size.height, // prend toute la hauteur de l'écran
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // Bandeau violet (Referral Banner)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ReferralBanner(),
            ),
        
            // Header (logo, bouton, langue)
            Positioned(
              top: isMobile ? 80 : 50,
              left: 0,
              right: 0,
              child: const AppHeader(),
            ),
        
            // Contenu principal centré
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: isMobile ? 10 : 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isMobile ? 120 : 100),
        
                      // Sous-titre (animé en premier pour mobile)
                      SlideTransition(
                        position: _subtitleSlideAnimation,
                        child: FadeTransition(
                          opacity: _subtitleFadeAnimation,
                          child: Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  )),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              AppTranslations.AppTranslations.heroSubtitle(controller.currentLang),
                              key: ValueKey<String>(controller.currentLang),
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: isMobile ? 13 : 15,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ),
                      ),
                      SizedBox(height: isMobile ? 15 : 25),
        
                      // Titre principal (animé en deuxième pour mobile)
                      SlideTransition(
                        position: _titleSlideAnimation,
                        child: FadeTransition(
                          opacity: _titleFadeAnimation,
                          child: Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  )),
                                  child: child,
                                ),
                              );
                            },
                            child: RichText(
                              key: ValueKey<String>(controller.currentLang),
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: Get.textTheme.displayLarge?.copyWith(
                                  fontSize: isMobile ? 36 : 68,
                                  height: isMobile ? 1.1 : 1.2,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: isMobile 
                                        ? (controller.currentLang == AppTranslations.AppTranslations.en 
                                            ? "Wespee — Everything you need, in one app, " 
                                            : "Wespee — tout ton univers dans une app, ")
                                        : AppTranslations.AppTranslations.heroTitle1(controller.currentLang),
                                  ),
                                  TextSpan(
                                    text: "it's your world.",
                                    style: Get.textTheme.displayLarge?.copyWith(
                                      fontSize: isMobile ? 36 : 68,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      height: isMobile ? 1.1 : 1.2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ),
                      ),
                      SizedBox(height: isMobile ? 15 : 20),
        
                      // Description (animée en troisième pour mobile)
                      SlideTransition(
                        position: _descriptionSlideAnimation,
                        child: FadeTransition(
                          opacity: _descriptionFadeAnimation,
                          child: Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  )),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              isMobile 
                                  ? (controller.currentLang == AppTranslations.AppTranslations.en
                                      ? "Your money, reimagined. Made better.\nWith Wespee: send, pay, enjoy."
                                      : "Ton argent, autrement. En mieux.\nAvec Wespee : envoie, paye, profite.")
                                  : AppTranslations.AppTranslations.heroDescription(controller.currentLang),
                              key: ValueKey<String>(controller.currentLang),
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyLarge?.copyWith(
                                fontSize: isMobile ? 14 : 16,
                                height: isMobile ? 1.5 : 1.5,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ),
                      ),
                      SizedBox(height: isMobile ? 25 : 45),
        
                      // Image SVG centrée (animée en quatrième pour mobile)
                      SlideTransition(
                        position: _imageSlideAnimation,
                        child: FadeTransition(
                          opacity: _imageFadeAnimation,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isMobile ? size.width * 0.95 : size.width * 0.6,
                              maxHeight: isMobile ? size.height * 0.35 : size.height * 0.4,
                            ),
                            child: Image.asset(
                              'assets/images/phone&group.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 0),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
