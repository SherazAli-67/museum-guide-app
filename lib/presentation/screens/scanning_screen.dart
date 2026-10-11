import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';
import 'package:musuem_guide_app_ui/provider/scanning_provider.dart';
import 'package:musuem_guide_app_ui/routing/router.dart';

class ScanningScreen extends StatelessWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanningProvider(),
      child: const _ScanningView(),
    );
  }
}

class _ScanningView extends StatefulWidget {
  const _ScanningView();

  @override
  State<_ScanningView> createState() => _ScanningViewState();
}

class _ScanningViewState extends State<_ScanningView> with TickerProviderStateMixin {
  static const _entranceDuration = Duration(milliseconds: 650);
  static const _pulseDuration = Duration(milliseconds: 1200);
  static const _selectionDuration = Duration(milliseconds: 320);

  late final AnimationController _entrance = AnimationController(vsync: this, duration: _entranceDuration);
  late final AnimationController _pulse = AnimationController(vsync: this, duration: _pulseDuration);
  late final AnimationController _selectPop = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));

  late final Animation<double> _sceneFade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
  late final Animation<double> _hotspotsFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.15, 0.7, curve: Curves.easeOut),
  );
  late final Animation<double> _cardFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.35, 1, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _selectScale = Tween<double>(begin: 0.92, end: 1).animate(
    CurvedAnimation(parent: _selectPop, curve: Curves.easeOutCubic),
  );

  int? _lastSelectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _entrance.value = 1;
        _selectPop.value = 1;
        return;
      }
      _entrance.forward();
      _pulse.repeat(reverse: true);
      _selectPop.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _selectPop.dispose();
    super.dispose();
  }

  void _syncSelection(int selectedIndex) {
    if (_lastSelectedIndex == null) {
      _lastSelectedIndex = selectedIndex;
      return;
    }
    if (_lastSelectedIndex == selectedIndex) return;
    _lastSelectedIndex = selectedIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _selectPop.value = 1;
        return;
      }
      _selectPop
        ..value = 0
        ..forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final moveDuration = reduceMotion ? Duration.zero : _selectionDuration;
    return Scaffold(
      backgroundColor: AppColors.overlayBlack,
      body: Consumer<ScanningProvider>(
        builder: (context, provider, _) {
          _syncSelection(provider.selectedIndex);
          return LayoutBuilder(
            builder: (context, constraints) {
              final scaleX = constraints.maxWidth / ScanningProvider.designWidth;
              final scaleY = constraints.maxHeight / ScanningProvider.designHeight;
              final hotspot = provider.selectedHotspot;
              final isDefaultActive = provider.selectedIndex == 3;
              final cardLeft = isDefaultActive ? 96.0 : (hotspot.left - 180).clamp(24.0, 96.0);
              final cardTop = isDefaultActive ? 656.68 : (hotspot.top + 83.68).clamp(0.0, ScanningProvider.designHeight - 160);
              final connectorLeft = isDefaultActive ? 327.06 : hotspot.left;
              final connectorTop = isDefaultActive ? 573.0 : hotspot.top;
              return Stack(
                fit: .expand,
                children: [
                  FadeTransition(
                    opacity: _sceneFade,
                    child: Image.asset(AssetRes.scanningHallImg, fit: .cover,),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 174 * scaleY,
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
                    bottom: 0,
                    height: 408 * scaleY,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              AppColors.overlayBlack.withValues(alpha: 0),
                              AppColors.overlayBlack.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _hotspotsFade,
                    child: Stack(
                      children: [
                        for (var i = 0; i < ScanningProvider.hotspots.length; i++)
                          if (i != provider.selectedIndex)
                            Positioned(
                              left: ScanningProvider.hotspots[i].left * scaleX,
                              top: ScanningProvider.hotspots[i].top * scaleY,
                              child: _PulsingHotspot(
                                animation: _pulse,
                                scale: scaleX,
                                reduceMotion: reduceMotion,
                                onTap: () => provider.selectHotspot(i),
                              ),
                            ),
                      ],
                    ),
                  ),
                  FadeTransition(
                    opacity: _cardFade,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: moveDuration,
                          curve: Curves.easeOutCubic,
                          left: connectorLeft * scaleX,
                          top: connectorTop * scaleY,
                          child: ScaleTransition(
                            scale: _selectScale,
                            alignment: .topLeft,
                            child: GestureDetector(
                              onTap: () {},
                              child: Transform.scale(
                                scale: scaleX,
                                alignment: .topLeft,
                                child: Transform.flip(
                                  flipY: true,
                                  child: SvgPicture.asset(AssetRes.icHotspotConnector,),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: moveDuration,
                          curve: Curves.easeOutCubic,
                          left: cardLeft * scaleX,
                          top: cardTop * scaleY,
                          width: NumberConstant.scanningCardWidth * scaleX,
                          child: ScaleTransition(
                            scale: _selectScale,
                            child: AnimatedSwitcher(
                              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(animation),
                                  child: child,
                                ),
                              ),
                              child: _buildExhibitCard(
                                context,
                                provider,
                                key: ValueKey(provider.selectedIndex),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40 * scaleY,
                    left: NumberConstant.horizontalPadding * scaleX,
                    right: NumberConstant.horizontalPadding * scaleX,
                    child: FadeTransition(
                      opacity: _sceneFade,
                      child: SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: .center,
                          children: [
                            Text(StringConst.scanning, style: AppTextStyles.scanningTitle,),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                AppIconButton.back(
                                  iconPath: AssetRes.icArrowBackLight,
                                  onTap: () => context.pop(),
                                ),
                                const _ScanningSpinner(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildExhibitCard(BuildContext context, ScanningProvider provider, {required Key key}) {
    final exhibit = provider.selectedExhibit;
    return GlassCard(
      key: key,
      height: NumberConstant.scanningCardHeight,
      padding: .fromLTRB(12, 12, 16, 12),
      child: Row(
        spacing: 12,
        children: [
          ClipRRect(
            borderRadius: .circular(8),
            child: Image.asset(
              AssetRes.scanningHallImg,
              width: NumberConstant.scanningThumbWidth,
              height: NumberConstant.scanningThumbHeight,
              fit: .cover,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: .start,
              mainAxisAlignment: .start,
              children: [
                Text(exhibit.title, style: AppTextStyles.detailTitle, maxLines: 1, overflow: .ellipsis,),
                Text(exhibit.displayShortYear, style: AppTextStyles.scanningYear,),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
                  child: Container(
                    width: 84,
                    alignment: .center,
                    padding: .symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: .circular(NumberConstant.cardRadius),
                    ),
                    child: Text(StringConst.detail, style: AppTextStyles.detailButton,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingHotspot extends StatelessWidget {
  final Animation<double> animation;
  final double scale;
  final bool reduceMotion;
  final VoidCallback onTap;

  const _PulsingHotspot({
    required this.animation,
    required this.scale,
    required this.reduceMotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final t = reduceMotion ? 1.0 : Curves.easeInOut.transform(animation.value);
          return Opacity(
            opacity: 0.55 + 0.45 * t,
            child: Transform.scale(scale: 0.88 + 0.12 * t, child: child),
          );
        },
        child: SizedBox(
          width: 43 * scale,
          height: 43 * scale,
          child: SvgPicture.asset(AssetRes.hotspotDot),
        ),
      ),
    );
  }
}

class _ScanningSpinner extends StatefulWidget {
  const _ScanningSpinner();

  @override
  State<_ScanningSpinner> createState() => _ScanningSpinnerState();
}

class _ScanningSpinnerState extends State<_ScanningSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return SvgPicture.asset(AssetRes.icLoading,);
    return RotationTransition(turns: _controller, child: SvgPicture.asset(AssetRes.icLoading,),);
  }
}
