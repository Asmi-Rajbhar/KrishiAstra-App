import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:math' as math;
import 'l10n/app_localizations.dart'; // 1. Import this!

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  // Note: splashData removed from here because it needs 'context' for translation

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // We need to pass splashData length here, but we can't access context easily in simple functions.
  // So we will modify _onNext slightly to check against 2 (since you have 3 slides: 0, 1, 2)
  void _onNext() {
    if (_currentPage == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 2. Initialize Localization
    final l10n = AppLocalizations.of(context)!;

    // 3. Define splashData INSIDE build to access translations
    final List<Map<String, dynamic>> splashData = [
      {
        "image": "assets/images/splash1.png",
        "title": l10n.appTitle, // "KRISHIASTRA" or "कृषीअस्त्र"
        "text": l10n.splashTitle1,
        "subtitle": l10n.splashSubtitle1,
        "color": const Color(0xFF28A745),
        "gradient": [const Color(0xFF28A745), const Color(0xFF20c997)],
      },
      {
        "image": "assets/images/splash2.png",
        "title": l10n.appTitle,
        "text": l10n.splashTitle2,
        "subtitle": l10n.splashSubtitle2,
        "color": const Color(0xFF20c997),
        "gradient": [const Color(0xFF20c997), const Color(0xFF17a2b8)],
      },
      {
        "image": "assets/images/splash3.png",
        "title": l10n.appTitle,
        "text": l10n.splashTitle3,
        "subtitle": l10n.splashSubtitle3,
        "color": const Color(0xFF28A745),
        "gradient": [const Color(0xFF28A745), const Color(0xFF34ce57)],
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF0FFF4),
              Colors.white,
              const Color(0xFFE6FFFA),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated Background Circles
              ...List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Positioned(
                      top:
                          screenHeight * (0.1 + index * 0.3) +
                          _floatAnimation.value,
                      right: screenWidth * (index.isEven ? -0.15 : 0.8),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              splashData[_currentPage]["color"].withOpacity(
                                0.15,
                              ),
                              splashData[_currentPage]["color"].withOpacity(
                                0.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              // Main Content
              Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        AnimatedOpacity(
                          opacity: _currentPage > 0 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: splashData[_currentPage]["color"]
                                      .withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                              ),
                              color: splashData[_currentPage]["color"],
                              onPressed: _currentPage > 0 ? _onBack : null,
                            ),
                          ),
                        ),
                        // Skip Button
                        if (_currentPage < splashData.length - 1)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: splashData[_currentPage]["gradient"],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: splashData[_currentPage]["color"]
                                      .withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _onSkip,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    l10n.skip, // 4. Translated Skip
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // PageView Content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: splashData.length,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                        _fadeController.reset();
                        _scaleController.reset();
                        _fadeController.forward();
                        _scaleController.forward();
                      },
                      itemBuilder:
                          (context, index) => FadeTransition(
                            opacity: _fadeAnimation,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: screenHeight * 0.02),

                                    // Animated Brand Badge
                                    ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors:
                                                splashData[index]["gradient"],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: splashData[index]["color"]
                                                  .withOpacity(0.4),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.eco,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              splashData[index]["title"]!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.04),

                                    // Animated Image
                                    ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: AnimatedBuilder(
                                        animation: _floatController,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              0,
                                              _floatAnimation.value * 0.5,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        splashData[index]["color"]
                                                            .withOpacity(0.3),
                                                    blurRadius: 40,
                                                    spreadRadius: 5,
                                                    offset: const Offset(0, 15),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                child: Container(
                                                  color: Colors.white,
                                                  padding: const EdgeInsets.all(
                                                    20,
                                                  ),
                                                  child: Image.asset(
                                                    splashData[index]["image"]!,
                                                    height: screenHeight * 0.28,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.04),

                                    // Main Text
                                    ShaderMask(
                                      shaderCallback:
                                          (bounds) => LinearGradient(
                                            colors:
                                                splashData[index]["gradient"],
                                          ).createShader(bounds),
                                      child: Text(
                                        splashData[index]["text"]!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1.3,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Subtitle
                                    Text(
                                      splashData[index]["subtitle"]!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                        height: 1.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),

                  // Bottom Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 10,
                              width: _currentPage == index ? 40 : 10,
                              decoration: BoxDecoration(
                                gradient:
                                    _currentPage == index
                                        ? LinearGradient(
                                          colors:
                                              splashData[_currentPage]["gradient"],
                                        )
                                        : null,
                                color:
                                    _currentPage != index
                                        ? Colors.grey.shade300
                                        : null,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow:
                                    _currentPage == index
                                        ? [
                                          BoxShadow(
                                            color:
                                                splashData[_currentPage]["color"]
                                                    .withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                        : null,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Button
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: splashData[_currentPage]["gradient"],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: splashData[_currentPage]["color"]
                                    .withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // 5. Translated Button Logic
                                  _currentPage == splashData.length - 1
                                      ? l10n.getStarted
                                      : l10n.continueBtn,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _currentPage == splashData.length - 1
                                        ? Icons.rocket_launch_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
