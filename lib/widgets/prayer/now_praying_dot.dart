part of 'prayer_card.dart';

class _NowPrayingDot extends StatefulWidget {
  const _NowPrayingDot();

  @override
  State<_NowPrayingDot> createState() => _NowPrayingDotState();
}

class _NowPrayingDotState extends State<_NowPrayingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glow = Tween<double>(
      begin: 0.55,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x99D4AF37).withValues(alpha: _glow.value),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Color(
                    0x55D4AF37,
                  ).withValues(alpha: 0.55 * _glow.value),
                  blurRadius: 6,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
