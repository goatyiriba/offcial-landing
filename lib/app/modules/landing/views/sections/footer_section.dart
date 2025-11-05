import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with TickerProviderStateMixin {
  late AnimationController _wespeeTitleController;
  late AnimationController _worldTitleController;
  late AnimationController _downloadTextController;

  late Animation<double> _wespeeTitleFadeAnimation;
  late Animation<double> _worldTitleFadeAnimation;
  late Animation<double> _downloadTextFadeAnimation;

  bool _hasAnimated = false;
  Worker? _sectionIndexWorker;
  final LandingController controller = Get.find<LandingController>();

  @override
  void initState() {
    super.initState();

    // Animation fade in pour "Wespee"
    _wespeeTitleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _wespeeTitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _wespeeTitleController, curve: Curves.easeOut),
    );

    // Animation fade in pour "it's your world."
    _worldTitleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _worldTitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _worldTitleController, curve: Curves.easeOut),
    );

    // Animation fade in pour "Télécharger l'application Wespee"
    _downloadTextController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _downloadTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _downloadTextController, curve: Curves.easeOut),
    );

    // Écouter les changements de section
    _listenToSectionChanges();
  }

  void _listenToSectionChanges() {
    final controller = Get.find<LandingController>();
    _sectionIndexWorker = ever(controller.currentSectionIndex, (int index) {
      if (index == 6 && mounted) {
        // Section footer est active (index 6)
        if (_hasAnimated) {
          // S'assurer que les animations restent à leur état final
          if (_wespeeTitleController.value != 1.0) {
            _wespeeTitleController.value = 1.0;
          }
          if (_worldTitleController.value != 1.0) {
            _worldTitleController.value = 1.0;
          }
          if (_downloadTextController.value != 1.0) {
            _downloadTextController.value = 1.0;
          }
        } else {
          // Démarrer les animations
          _startAnimations();
        }
      }
    });

    // Vérifier si on est déjà sur cette section au chargement initial
    if (controller.currentSectionIndex.value == 6) {
      if (!_hasAnimated) {
        _startAnimations();
      }
    }
  }

  void _startAnimations() {
    if (!_hasAnimated && mounted) {
      _hasAnimated = true;
      // Premier texte : "Wespee"
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _wespeeTitleController.forward();
        }
      });
      // Deuxième texte : "it's your world." après 300ms
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          _worldTitleController.forward();
        }
      });
      // Troisième texte : "Télécharger l'application Wespee" après 600ms
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _downloadTextController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _sectionIndexWorker?.dispose();
    _sectionIndexWorker = null;
    _wespeeTitleController.dispose();
    _worldTitleController.dispose();
    _downloadTextController.dispose();
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
            vertical: isMobile ? 40 : 30,
            horizontal: isMobile ? 20 : 40,
          ),
          child: Column(
            children: [
              // Logo
              SizedBox(
                width: isMobile ? 50 : 60,
                height: isMobile ? 50 : 60,
                child: SvgPicture.asset(
                  'assets/images/logo1.svg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: isMobile ? 30 : 20),
              
              // Texte "Wespee" animé
              FadeTransition(
                opacity: _wespeeTitleFadeAnimation,
                child: Obx(() => Text(
                  AppTranslations.AppTranslations.footerWespeeTitle(controller.currentLang),
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontSize: isMobile ? 40 : 70,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
              SizedBox(height: isMobile ? 5 : 10),
              
              // Texte "it's your world." animé
              FadeTransition(
                opacity: _worldTitleFadeAnimation,
                child: Obx(() => Text(
                  AppTranslations.AppTranslations.footerWorldTitle(controller.currentLang),
                  style: Get.textTheme.headlineLarge?.copyWith(
                    fontSize: isMobile ? 40 : 70,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
              SizedBox(height: isMobile ? 40 : 30),
              
              // Bouton "Télécharger l'application" (mobile) ou QR Code (desktop)
              if (isMobile)
GestureDetector(
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
                          )
              else
                Column(
                  children: [
                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/qr-code.svg',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Texte "Télécharger l'application Wespee" animé
                    FadeTransition(
                      opacity: _downloadTextFadeAnimation,
                      child: Obx(() => Text(
                        AppTranslations.AppTranslations.footerDownload(controller.currentLang),
                        style: Get.textTheme.bodyMedium,
                      )),
                    ),
                  ],
                ),
              SizedBox(height: isMobile ? 40 : 50),
              
              // Footer Grid
              _buildFooterGrid(size),
              SizedBox(height: isMobile ? 40 : 80),
              
              // Bloc de texte - Conditions générales
              SizedBox(
                child: _buildTermsBlock(isMobile),
              ),
              SizedBox(height: isMobile ? 40 : 30),
              
              // Footer Links
              _buildFooterLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsBlock(bool isMobile) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTermItem(
            '1',
            AppTranslations.AppTranslations.term1(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '2',
            AppTranslations.AppTranslations.term2(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '3',
            AppTranslations.AppTranslations.term3(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '4',
            AppTranslations.AppTranslations.term4(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '5',
            AppTranslations.AppTranslations.term5(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '6',
            AppTranslations.AppTranslations.term6(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '7',
            AppTranslations.AppTranslations.term7(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '8',
            AppTranslations.AppTranslations.term8(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '9',
            AppTranslations.AppTranslations.term9(controller.currentLang),
            isMobile,
          ),
          _buildTermItem(
            '10',
            AppTranslations.AppTranslations.term10(controller.currentLang),
            isMobile,
          ),
        ],
      ),
    ));
  }

  Widget _buildTermItem(String number, String content, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number.',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: _buildRichText(content, isMobile),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String text, bool isMobile) {
    final controller = Get.find<LandingController>();
    // Mots/phrases à mettre en gras selon le design
    final boldWords = controller.currentLang == AppTranslations.AppTranslations.fr
        ? AppTranslations.AppTranslations.getBoldWordsFr()
        : AppTranslations.AppTranslations.getBoldWordsEn();

    final textStyle = Get.textTheme.bodyMedium?.copyWith(
      fontSize: isMobile ? 12 : 14,
      height: 1.5,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

    final boldStyle = Get.textTheme.bodyMedium?.copyWith(
      fontSize: isMobile ? 12 : 14,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    Set<int> boldIndices = {};

    // Trouver tous les indices à mettre en gras
    for (final boldWord in boldWords) {
      int index = 0;
      while ((index = text.indexOf(boldWord, index)) != -1) {
        for (int i = 0; i < boldWord.length; i++) {
          boldIndices.add(index + i);
        }
        index += boldWord.length;
      }
    }

    // Construire les segments
    List<TextSpan> spans = [];
    int currentIndex = 0;
    bool currentlyBold = false;

    for (int i = 0; i <= text.length; i++) {
      bool shouldBeBold = boldIndices.contains(i);
      
      if (i == text.length || shouldBeBold != currentlyBold) {
        if (i > currentIndex) {
          spans.add(TextSpan(
            text: text.substring(currentIndex, i),
            style: currentlyBold ? boldStyle : textStyle,
          ));
        }
        currentIndex = i;
        currentlyBold = shouldBeBold;
      }
    }

    // Si pas de texte en gras trouvé, retourner le texte normal
    if (spans.isEmpty) {
      return Text(text, style: textStyle);
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildFooterLinks() {
    final size = MediaQuery.of(Get.context!).size;
    final isMobile = size.width < 600;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 40),
      child: Column(
        children: [
          // Top row: Logo + Links
          isMobile
              ? Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 180,
                          child: SvgPicture.asset(
                            'assets/images/logo_blanc_noir.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => GestureDetector(
                              onTap: () {},
                              child: Text(
                                AppTranslations.AppTranslations.footerPrivacy(controller.currentLang),
                                style: const TextStyle(fontSize: 12),
                              ),
                            )),
                            const SizedBox(height: 8),
                            Obx(() => GestureDetector(
                              onTap: () {},
                              child: Text(
                                AppTranslations.AppTranslations.footerTerms(controller.currentLang),
                                style: const TextStyle(fontSize: 12),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                ],
              )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 150,
                      child: SvgPicture.asset(
                        'assets/images/logo_blanc_noir.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => GestureDetector(
                          onTap: () {},
                          child: Text(
                            AppTranslations.AppTranslations.footerPrivacy(controller.currentLang),
                          ),
                        )),
                        const SizedBox(width: 30),
                        Obx(() => GestureDetector(
                          onTap: () {},
                          child: Text(
                            AppTranslations.AppTranslations.footerTerms(controller.currentLang),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 8 : 20),
          // Bottom row: Copyright + Social Icons
          isMobile
              ? Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: AppTranslations.AppTranslations.footerCopyright(controller.currentLang),
                                style: const TextStyle(fontSize: 12),
                              ),
                              TextSpan(
                                text: AppTranslations.AppTranslations.footerCompanyName(controller.currentLang),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildSocialIcon('assets/icons/youtube_icon.svg', () {}, isMobile),
                            const SizedBox(width: 12),
                            _buildSocialIcon('assets/icons/x_icon.svg', () {}, isMobile),
                            const SizedBox(width: 12),
                            _buildSocialIcon('assets/icons/fb_icon.svg', () {}, isMobile),
                            const SizedBox(width: 12),
                            _buildSocialIcon('assets/icons/linkedin_icon.svg', () {}, isMobile),
                            const SizedBox(width: 12),
                            _buildSocialIcon('assets/icons/insta_icon.svg', () {}, isMobile),
                            const SizedBox(width: 12),
                            _buildSocialIcon('assets/icons/tiktok_icon.svg', () {}, isMobile),
                          ],
                        ),
                      ],
                    ),
                ],
              )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: AppTranslations.AppTranslations.footerCopyright(controller.currentLang),
                          ),
                          TextSpan(
                            text: AppTranslations.AppTranslations.footerCompanyName(controller.currentLang),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                    Row(
                      children: [
                        _buildSocialIcon('assets/icons/youtube_icon.svg', () {}, isMobile),
                        SizedBox(width: isMobile ? 12 : 16),
                        _buildSocialIcon('assets/icons/x_icon.svg', () {}, isMobile),
                        SizedBox(width: isMobile ? 12 : 16),
                        _buildSocialIcon('assets/icons/fb_icon.svg', () {}, isMobile),
                        SizedBox(width: isMobile ? 12 : 16),
                        _buildSocialIcon('assets/icons/linkedin_icon.svg', () {}, isMobile),
                        SizedBox(width: isMobile ? 12 : 16),
                        _buildSocialIcon('assets/icons/insta_icon.svg', () {}, isMobile),
                        SizedBox(width: isMobile ? 12 : 16),
                        _buildSocialIcon('assets/icons/tiktok_icon.svg', () {}, isMobile),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, VoidCallback onTap, bool isMobile) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: isMobile ? 24 : 32,
        height: isMobile ? 24 : 32,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 4 : 6),
          child: SvgPicture.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterGrid(Size size) {
    final isMobile = size.width < 600;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          // Version mobile: grille 3x3 simplifiée
          final spacing = 8.0;
          final gridWidth = constraints.maxWidth;
          final totalSpacing = spacing * 2; // 2 espaces entre 3 colonnes
          final availableWidth = gridWidth - totalSpacing;
          final cellWidth = availableWidth / 3;
          final cellHeight = cellWidth * 1.2;
          
          return Column(
            children: [
              // Ligne 1
              Row(
                children: [
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person4.jpg', span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFFFD4A3), span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFE8E8FF), span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // Ligne 2
              Row(
                children: [
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFE8E8FF), span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/family.jpg', span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person2.jpg', span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // Ligne 3
              Row(
                children: [
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/group1.jpg', span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person3.jpg', span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFF9EB6E), span: GridSpan(row: 1, col: 1)),
                      cellWidth,
                      cellHeight,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Version desktop: grille complexe originale
          final spacing = 20.0;
          final gridWidth = constraints.maxWidth;
          final totalSpacing = spacing * 4;
          final availableWidth = gridWidth - totalSpacing;
          final baseWidth = availableWidth / 5;
          final baseHeight = baseWidth;

          return Row(
            children: [
              // Colonne 1
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person4.jpg', span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                    SizedBox(height: spacing),
                    _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFE8E8FF), span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing),
              // Colonne 2
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(height: baseHeight * 0.3),
                    _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFFF7F0F), span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                    SizedBox(height: spacing),
                    _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/group1.jpg', span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing),
              // Colonne 3
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFE8E8FF), span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                    SizedBox(height: spacing),
                    _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person3.jpg', span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing),
              // Colonne 4
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(height: baseHeight * 0.3),
                    _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/family.jpg', span: GridSpan(row: 2, col: 2)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                    SizedBox(height: spacing),
                    _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFD7FFDF), span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing),
              // Colonne 5
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildGridCell(
                      GridItem(type: GridItemType.image, imageUrl: 'assets/images/person2.jpg', span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                    SizedBox(height: spacing),
                    _buildGridCell(
                      GridItem(type: GridItemType.color, color: const Color(0xFFF9EB6E), span: GridSpan(row: 1, col: 1)),
                      baseWidth,
                      baseHeight * 1.3,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildGridCell(GridItem item, double width, double height) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      decoration: BoxDecoration(
        color: item.color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: item.type == GridItemType.image
          ? Image.asset(
              item.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error_outline, color: Colors.grey),
              ),
            )
          : null,
    );
  }
}

class GridItem {
  final GridItemType type;
  final String? imageUrl;
  final Color? color;
  final GridSpan span;

  GridItem({
    required this.type,
    this.imageUrl,
    this.color,
    required this.span,
  });
}

enum GridItemType { image, color }

class GridSpan {
  final int row;
  final int col;

  GridSpan({required this.row, required this.col});
}