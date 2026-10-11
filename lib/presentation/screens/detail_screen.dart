import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_data.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';

class DetailScreen extends StatefulWidget {
  static const _designWidth = 428.0;
  static const _designHeight = 926.0;

  final String exhibitId;

  const DetailScreen({super.key, required this.exhibitId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {
  static const _entranceDuration = Duration(milliseconds: 750);
  static const _rotateDuration = Duration(milliseconds: 2200);
  static const _swipeDuration = Duration(milliseconds: 1200);
  static const _audioPulseDuration = Duration(milliseconds: 1400);

  late final AnimationController _entrance = AnimationController(vsync: this, duration: _entranceDuration);
  late final AnimationController _rotateHint = AnimationController(vsync: this, duration: _rotateDuration);
  late final AnimationController _swipeHint = AnimationController(vsync: this, duration: _swipeDuration);
  late final AnimationController _audioPulse = AnimationController(vsync: this, duration: _audioPulseDuration);

  late final Animation<double> _sceneFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0, 0.45, curve: Curves.easeOut),
  );
  late final Animation<double> _chromeFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
  );
  late final Animation<double> _cardFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
  );
  late final Animation<Offset> _cardSlide = Tween<Offset>(
    begin: const Offset(0, 0.22),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
  ));

  bool _swipeHintStopped = false;
  bool _audioPlaying = false;
  bool _audioPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _entrance.value = 1;
        return;
      }
      _entrance.forward();
      _rotateHint.repeat(reverse: true);
      _swipeHint.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _rotateHint.dispose();
    _swipeHint.dispose();
    _audioPulse.dispose();
    super.dispose();
  }

  void _stopSwipeHint() {
    if (_swipeHintStopped) return;
    _swipeHintStopped = true;
    _swipeHint.stop();
    _swipeHint.value = 0;
    setState(() {});
  }

  void _toggleAudio() {
    setState(() => _audioPlaying = !_audioPlaying);
    if (MediaQuery.disableAnimationsOf(context)) return;
    if (_audioPlaying) {
      _audioPulse.repeat(reverse: true);
    } else {
      _audioPulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exhibit = AppData.exhibitById(widget.exhibitId) ?? AppData.dioskouroi;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFFBFBFBF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scaleX = constraints.maxWidth / DetailScreen._designWidth;
          final scaleY = constraints.maxHeight / DetailScreen._designHeight;
          return Listener(
            onPointerMove: (event) {
              if (!_swipeHintStopped && event.delta.dy.abs() > 2) _stopSwipeHint();
            },
            child: Stack(
              fit: .expand,
              children: [
                FadeTransition(
                  opacity: _sceneFade,
                  child: Image.asset(AssetRes.detailPageImg, fit: .cover,),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 207 * scaleY,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: .topCenter,
                          end: .bottomCenter,
                          colors: [
                            AppColors.overlayBlack.withValues(alpha: 0.6),
                            AppColors.overlayBlack.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 494 * scaleY,
                  height: 432 * scaleY,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: .topCenter,
                          end: .bottomCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0),
                            AppColors.background,
                          ],
                          stops: const [0.63, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 79 * scaleX,
                  top: 365 * scaleY,
                  child: FadeTransition(
                    opacity: _chromeFade,
                    child: AnimatedBuilder(
                      animation: _rotateHint,
                      builder: (context, child) {
                        final t = reduceMotion ? 0.5 : Curves.easeInOut.transform(_rotateHint.value);
                        final angle = (t - 0.5) * 0.4;
                        return Opacity(
                          opacity: reduceMotion ? 1 : 0.65 + 0.35 * t,
                          child: Transform.rotate(angle: angle, child: child),
                        );
                      },
                      child: Transform.scale(
                        scale: scaleX,
                        alignment: .topLeft,
                        child: SvgPicture.asset(AssetRes.icRotate,),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 203 * scaleX,
                  top: 690 * scaleY,
                  child: FadeTransition(
                    opacity: _chromeFade,
                    child: AnimatedBuilder(
                      animation: _swipeHint,
                      builder: (context, child) {
                        final t = (reduceMotion || _swipeHintStopped)
                            ? 0.0
                            : Curves.easeInOut.transform(_swipeHint.value);
                        return Transform.translate(offset: Offset(0, -12 * t), child: child);
                      },
                      child: Transform.scale(
                        scale: scaleX,
                        alignment: .topLeft,
                        child: SvgPicture.asset(AssetRes.icSwipeUp,),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: NumberConstant.horizontalPadding * scaleX,
                  bottom: 0,
                  width: (DetailScreen._designWidth - NumberConstant.horizontalPadding * 2) * scaleX,
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: _buildInfoCard(exhibit),
                    ),
                  ),
                ),
                Positioned(
                  left: 338 * scaleX,
                  top: 700 * scaleY,
                  child: FadeTransition(
                    opacity: _chromeFade,
                    child: _buildAudioButton(reduceMotion),
                  ),
                ),
                Positioned(
                  left: NumberConstant.horizontalPadding * scaleX,
                  top: 40 * scaleY,
                  child: FadeTransition(
                    opacity: _chromeFade,
                    child: AppIconButton.back(
                      iconPath: AssetRes.icArrowBackLight,
                      onTap: () => context.pop(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAudioButton(bool reduceMotion) {
    return Listener(
      onPointerDown: (_) => setState(() => _audioPressed = true),
      onPointerUp: (_) => setState(() => _audioPressed = false),
      onPointerCancel: (_) => setState(() => _audioPressed = false),
      child: AnimatedBuilder(
        animation: _audioPulse,
        builder: (context, child) {
          final pulse = (!reduceMotion && _audioPlaying)
              ? Curves.easeInOut.transform(_audioPulse.value)
              : 0.0;
          final scale = (_audioPressed ? 0.94 : 1) + 0.05 * pulse;
          return Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: .circle,
                boxShadow: _audioPlaying
                    ? [
                        BoxShadow(
                          color: AppColors.white.withValues(alpha: 0.35 + 0.25 * pulse),
                          blurRadius: 10 + 8 * pulse,
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          );
        },
        child: AppIconButton.audio(
          iconPath: AssetRes.icHeadphones,
          onTap: _toggleAudio,
        ),
      ),
    );
  }

  Widget _buildInfoCard(ExhibitModel exhibit) {
    return GlassCard(
      height: NumberConstant.detailSheetHeight,
      padding: .fromLTRB(17, 17, 17, 12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: [
          Text(exhibit.title, style: AppTextStyles.detailTitle,),
          Text('${StringConst.yearPrefix}${exhibit.yearLabel}', style: AppTextStyles.detailYear,),
          Expanded(
            child: ShaderMask(
              blendMode: .dstIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [
                  AppColors.white,
                  AppColors.white,
                  AppColors.white.withValues(alpha: 0),
                ],
                stops: const [0, 0.72, 1],
              ).createShader(bounds),
              child: Text(exhibit.description, style: AppTextStyles.bodyDescription, overflow: .clip,),
            ),
          ),
        ],
      ),
    );
  }
}
