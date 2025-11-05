import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/translations.dart' as AppTranslations;
import '../../controllers/landing_controller.dart';

class ProtectionSection extends StatefulWidget {
  const ProtectionSection({super.key});

  @override
  State<ProtectionSection> createState() => _ProtectionSectionState();
}

class _ProtectionSectionState extends State<ProtectionSection>
    with TickerProviderStateMixin {
  late AnimationController _firstContainerController;
  late AnimationController _secondContainerController;
  late AnimationController _fourthContainerController;
  late AnimationController _firstContainerScaleController;
  late AnimationController _secondContainerScaleController;
  
  late Animation<Offset> _firstContainerAnimation;
  late Animation<double> _firstContainerScaleAnimation;
  late Animation<double> _secondContainerScaleAnimation;
  late Animation<Offset> _fourthContainerAnimation;
  
  // Animation values for second container position
  double _secondContainerTopValue = 0.4;

  final LandingController controller = Get.find<LandingController>();
  
  // Store the worker to cancel it in dispose
  Worker? _frameIndexWorker;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _firstContainerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _secondContainerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fourthContainerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _firstContainerScaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _secondContainerScaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animations
    _firstContainerAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _firstContainerController,
      curve: Curves.easeOutCubic,
    ));

    _firstContainerScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _firstContainerScaleController,
      curve: Curves.easeOutCubic,
    ));

    _secondContainerScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _secondContainerScaleController,
      curve: Curves.easeOutCubic,
    ));

    _fourthContainerAnimation = Tween<Offset>(
      begin: const Offset(0, 0.65), // Position basse relative (0.8 - 0.15)
      end: const Offset(0, 0.0), // Position superposée (même position que second container)
    ).animate(CurvedAnimation(
      parent: _fourthContainerController,
      curve: Curves.easeOutCubic,
    ));

    // Start initial animations
    _firstContainerController.forward();
    _secondContainerController.value = 1.0; // Set to end position immediately
    // Initialize scale controllers to start (scale = 1.0)
    _firstContainerScaleController.value = 0.0;
    _secondContainerScaleController.value = 0.0;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // Animate second container sliding up from bottom
        _secondContainerController.reset();
        _secondContainerController.forward();
      }
    });
    // Fourth container starts at bottom position
    _fourthContainerController.value = 0.0;

    // Listen to frame changes
    _frameIndexWorker = ever(controller.protectionFrameIndex, (index) {
      if (mounted) {
        _updateAnimations(index);
      }
    });
  }

  void _updateAnimations(int frameIndex) {
    if (!mounted) return;
    
    if (frameIndex == 1) {
      // Frame 2: Stack fourth container on top of second container (book effect)
      if (mounted) {
        // Animate fourth container stacking on second container first
        _fourthContainerController.forward();
        
        // Then reduce container sizes with delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            // Reduce first container size (scale animation goes from 1.0 to 0.85)
            _firstContainerScaleController.forward();
            // Reduce second container size (scale animation goes from 1.0 to 0.9)
            _secondContainerScaleController.forward();
          }
        });
      }
    } else {
      // Frame 1: Reset to initial state
      if (mounted) {
        // Reset scale animations to 1.0
        _firstContainerScaleController.reverse();
        _secondContainerScaleController.reverse();
        // Reset fourth container to bottom position
        _fourthContainerController.reset();
        setState(() {
          _secondContainerTopValue = 0.4;
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel the worker listener
    _frameIndexWorker?.dispose();
    _frameIndexWorker = null;
    
    // Dispose animation controllers
    _firstContainerController.dispose();
    _secondContainerController.dispose();
    _fourthContainerController.dispose();
    _firstContainerScaleController.dispose();
    _secondContainerScaleController.dispose();
    
    super.dispose();
  }

  void _handleTap() {
    if (controller.currentSectionIndex.value == 3) {
      // Only handle taps when we're on protection section
      if (controller.protectionFrameIndex.value < 1) {
        // Not at last frame, go to next frame
        controller.nextProtectionFrame();
      } else {
        // At last frame, move to next section
        controller.nextSection();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: size.width,
        height: size.height,
        color: AppColors.white,
        child: isMobile
            ? SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height,
                    maxHeight: size.height * 1.3, // Limite la hauteur pour éviter l'infini
                  ),
                  child: Stack(
                    children: [
            // Frame 1: First Container (visible on top, fades out in frame 2)
            Positioned(
                    top: isMobile ? 140 : size.height * 0.15,
                    left: isMobile ? 20 : size.width * 0.1,
                    right: isMobile ? 20 : size.width * 0.1,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: isMobile ? 800 : size.height * 0.5,
                      ),
                      child: SlideTransition(
                        position: _firstContainerAnimation,
                        child: Transform.scale(
                          scale: _firstContainerScaleAnimation.value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                            child: _buildFirstContainer(isMobile, size),
                          ),
                        ),
                      ),
                    ),
                  ),

            // Frame 1 & 2: Second Container (superposed, becomes main in frame 2)
            Positioned(
              top: -30,
              left: isMobile ? 15 : size.width * 0.08,
              right: isMobile ? 15 : size.width * 0.08,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1.5),
                  end: Offset(0, _secondContainerTopValue),
                ).animate(CurvedAnimation(
                  parent: _secondContainerController,
                  curve: Curves.easeOutCubic,
                )),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Prevent infinite height: limit the animated child's height
                    maxHeight: isMobile ? 1200 : size.height * 0.65,
                  ),
                  child: Transform.scale(
                    scale: _secondContainerScaleAnimation.value,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                      child: _buildSecondContainer(isMobile, size),
                    ),
                  ),
                ),
              ),
            ),
            // Frame 1 & 2: Fourth Container (stacks on second container with book effect)
            Obx(() => Positioned(
              top: controller.protectionFrameIndex.value == 0 ? size.height * 0.5 :  size.height * 0.4,
              left: isMobile ? 15 : size.width * 0.08,
              right: isMobile ? 15 : size.width * 0.08,
                              child: SlideTransition(
                position: _fourthContainerAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 0 : (controller.protectionFrameIndex.value == 0 ? 180.0 : 200.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? 800 : size.height * 0.65,
                      minHeight: controller.protectionFrameIndex.value == 1 
                          ? (isMobile ? 550.0 : 650.0)
                          : 0.0,
                    ),
                    child: Transform.scale(
                      scale: controller.protectionFrameIndex.value == 0 ? 1.0 : 1.05,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                        child: _buildFourthContainer(isMobile, size),
                      ),
                    ),
                  ),
                ),
              ),
            )),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
            // Frame 1: First Container (visible on top, fades out in frame 2)
            Positioned(
                    top: size.height * 0.15,
                    left: isMobile ? 20 : size.width * 0.1,
                    right: isMobile ? 20 : size.width * 0.1,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: isMobile ? size.height * 0.9 : size.height * 0.5,
                      ),
                      child: SlideTransition(
                        position: _firstContainerAnimation,
                        child: Transform.scale(
                          scale: _firstContainerScaleAnimation.value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 200),
                            child: _buildFirstContainer(isMobile, size),
                          ),
                        ),
                      ),
                    ),
                  ),

            // Frame 1 & 2: Second Container (superposed, becomes main in frame 2)
            Positioned(
              left: isMobile ? 15 : size.width * 0.08,
              right: isMobile ? 15 : size.width * 0.08,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1.5),
                  end: Offset(0, _secondContainerTopValue),
                ).animate(CurvedAnimation(
                  parent: _secondContainerController,
                  curve: Curves.easeOutCubic,
                )),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Prevent infinite height: limit the animated child's height
                    maxHeight: isMobile ? 1200 : size.height * 0.65,
                  ),
                  child: Transform.scale(
                    scale: _secondContainerScaleAnimation.value,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 200),
                      child: _buildSecondContainer(isMobile, size),
                    ),
                  ),
                ),
              ),
            ),
            // Frame 1 & 2: Fourth Container (stacks on second container with book effect)
            Obx(() => Positioned(
              top: controller.protectionFrameIndex.value == 0 ? size.height * 0.5 :  size.height * 0.4,
              left: isMobile ? 15 : size.width * 0.08,
              right: isMobile ? 15 : size.width * 0.08,
                              child: SlideTransition(
                position: _fourthContainerAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 0 : (controller.protectionFrameIndex.value == 0 ? 180.0 : 200.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? double.infinity : 950,
                      minHeight: controller.protectionFrameIndex.value == 1 
                          ? (isMobile ? 800.0 : 650.0)
                          : 0.0,
                    ),
                    child: Transform.scale(
                      scale: controller.protectionFrameIndex.value == 0 ? 1.0 : 1.05,
                      child: _buildFourthContainer(isMobile, size),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // First Container: Upper block with 2 compartments
  Widget _buildFirstContainer(bool isMobile, Size size) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Partie gauche (Light Purple)
                Container(
                  padding: EdgeInsets.all(isMobile ? 15 : 40),
                  color: AppColors.white,
                  child: Obx(() => Text(
      AppTranslations.AppTranslations.securityText(controller.currentLang),
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontSize: isMobile ? 13 : 16,
                      height: isMobile ? 1.6 : 1.8,
                      color: AppColors.black,
                    ),
                  )),
                ),
                // Partie droite (Very Light Grey)
                Container(
                  padding: EdgeInsets.all(isMobile ? 15 : 40),
                  color: AppColors.lightGrey,
                  child: Center(
                    child: _buildSecuFrame(isMobile),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left section (Light Purple) - 3/5
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 40),
                    color: AppColors.white,
                    child: Obx(() => Text(
      AppTranslations.AppTranslations.securityText(controller.currentLang),
                      style: Get.textTheme.bodyLarge?.copyWith(
                        fontSize: isMobile ? 14 : 23,
                        height: 1.8,
                        color: AppColors.black,
                      ),
                    )),
                  ),
                ),
                // Right section (Very Light Grey) - 2/5
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 40),
                    color: AppColors.lightGrey,
                    child: Center(
                      child: _buildSecuFrame(isMobile),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

    // Second Container: Main block with both compartments
  Widget _buildSecondContainer(bool isMobile, Size size) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 950,
        minHeight: isMobile ? 400 : 280,
        maxHeight: isMobile ? 1000 : 800,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: 
          // Upper part with 2 compartments
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Partie gauche (Light Purple)
                    Container(
                      padding: EdgeInsets.all(isMobile ? 15 : 40),
                      color: AppColors.secondary,
                      child: Obx(() => Text(
                        AppTranslations.AppTranslations.protectionText(controller.currentLang),
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontSize: isMobile ? 17 : 16,
                          height: isMobile ? 1.7 : 1.8,
                          color: AppColors.black,
                        ),
                      )),
                    ),
                    // Partie droite (Very Light Grey)
                    Container(
                                                padding: EdgeInsets.only(
                                              right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 60 : 150,
                                            ),
                      color: AppColors.lightGrey,
                      child: Center(
                        child: _buildProfileCard(isMobile),
                      ),
                    ),
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left section (Light Purple) - 3/5
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 20 : 40),
                          color: AppColors.secondary,
                          child: Obx(() => Text(
                            AppTranslations.AppTranslations.protectionText(controller.currentLang),
                            style: Get.textTheme.bodyLarge?.copyWith(
                              fontSize: isMobile ? 14 : 23,
                              height: 1.8,
                              color: AppColors.black,
                            ),
                          )),
                        ),
                      ),
                      // Right section (Very Light Grey) - 2/5
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(
                            right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 40 : 60,
                          ),
                          color: AppColors.lightGrey,
                          child: Center(
                            child: _buildProfileCard(isMobile),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
      ),
    );
  }

  // Fourth Container: Bottom container with 2 equal compartments
  Widget _buildFourthContainer(bool isMobile, Size size) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 950,
        minHeight: isMobile ? 400 : 280,
        maxHeight: isMobile ? 1000 : 800,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: 
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Partie gauche
                    Container(
                      padding: EdgeInsets.all(isMobile ? 15 : 40),
                      color: const Color(0xFF454545),
                      child: Obx(() => Text(
                        AppTranslations.AppTranslations.protectionText2(controller.currentLang),
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontSize: isMobile ? 16 : 16,
                          height: 1.8,
                          color: AppColors.white,
                        ),
                      )),
                    ),
                    // Partie droite
Container(
                                                padding: EdgeInsets.only(
                                              right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 60 : 150,
                                            ),
                          color: AppColors.lightGrey,
                          child: Center(
                            child: _buildSecondSecuFrame(isMobile),
                          ),
                        ),
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left section - 1/2
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 20 : 40),
                          color: const Color(0xFF454545),
                          child: Obx(() => Text(
                            AppTranslations.AppTranslations.protectionText2(controller.currentLang),
                            style: Get.textTheme.bodyLarge?.copyWith(
                              fontSize: isMobile ? 14 : 23,
                              height: 1.8,
                              color: AppColors.white,
                            ),
                          )),
                        ),
                      ),
                      // Right section - 1/2
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding:  EdgeInsets.only(
                            right : isMobile ? 30 : 50, left: isMobile ? 30 : 50, top: isMobile ? 40 : 60,
                          ),
                          color: AppColors.lightGrey,
                          child: Center(
                            child: _buildSecondSecuFrame(isMobile),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  // Profile Card with user info
  Widget _buildProfileCard(bool isMobile) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isMobile ? 150 : double.infinity,
        maxHeight: isMobile ? 300 : double.infinity,
      ),
      child: Image.asset(
        'assets/images/user_frame.png',
        fit: BoxFit.contain,
      ),
    );
  }
  Widget _buildSecuFrame(bool isMobile) {
    return SizedBox(
      width: isMobile ? 180 : 200,
      height: isMobile ? 170 : 250,
      child: SvgPicture.asset(
        'assets/images/secu_frame.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSecondSecuFrame(bool isMobile) {
    return Image.asset(
      'assets/images/secu_frame(1).png',
      fit: BoxFit.contain,
    );
  }
}
