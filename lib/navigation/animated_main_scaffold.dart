// lib/navigation/animated_main_scaffold.dart
import 'package:deepex/navigation/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimatedMainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const AnimatedMainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<AnimatedMainScaffold> createState() => _AnimatedMainScaffoldState();
}

class _AnimatedMainScaffoldState extends State<AnimatedMainScaffold>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Store the current page
  late int _currentIndex;

  // And the previously displayed page
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex;
    _currentPage = widget.child;

    // Setup fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Setup slide animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedMainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the index changed, animate the transition
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Determine slide direction
      final slideDirection = widget.currentIndex > oldWidget.currentIndex
          ? const Offset(1.0, 0.0)
          : const Offset(-1.0, 0.0);

      // Set current page as the old page we're transitioning from
      setState(() {
        _currentPage = oldWidget.child;
      });

      // Animate the old page out
      _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
      );

      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: -slideDirection, // Slide in opposite direction of new page
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
      );

      _fadeController.forward(from: 0.0);
      _slideController.forward(from: 0.0).then((_) {
        // When animation completes, update to the new page
        setState(() {
          _currentPage = widget.child;
          _currentIndex = widget.currentIndex;

          // Reset animations for the next transition
          _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
          );

          _slideAnimation = Tween<Offset>(
            begin: slideDirection, // New page comes from the opposite side
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
                parent: _slideController, curve: Curves.easeOutCubic),
          );
        });

        // Animate the new page in
        _fadeController.forward(from: 0.0);
        _slideController.forward(from: 0.0);
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/transactions');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _currentPage,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
