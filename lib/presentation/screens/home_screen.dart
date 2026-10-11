import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/exhibit_list_tile.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';
import 'package:musuem_guide_app_ui/provider/home_provider.dart';
import 'package:musuem_guide_app_ui/routing/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with TickerProviderStateMixin {
  static const _entranceDuration = Duration(milliseconds: 900);
  static const _fabPulseDuration = Duration(milliseconds: 1400);

  late final AnimationController _entrance = AnimationController(vsync: this, duration: _entranceDuration);
  late final AnimationController _fabPulse = AnimationController(vsync: this, duration: _fabPulseDuration);

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
      _fabPulse.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _fabPulse.dispose();
    super.dispose();
  }

  Animation<double> _section(double begin, double end) => CurvedAnimation(
    parent: _entrance,
    curve: Interval(begin, end, curve: Curves.easeOutCubic),
  );

  Widget _stagger({required Animation<double> animation, required Widget child}) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Consumer<HomeProvider>(
              builder: (context, provider, _) => CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: .fromLTRB(NumberConstant.horizontalPadding, 16, NumberConstant.horizontalPadding, 100),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            spacing: NumberConstant.contentGap,
                            crossAxisAlignment: .start,
                            children: [
                              _stagger(animation: _section(0, 0.28), child: _buildHeader()),
                              _stagger(
                                animation: _section(0.08, 0.36),
                                child: Text(StringConst.welcomeTitle, style: AppTextStyles.welcomeTitle,),
                              ),
                              _stagger(animation: _section(0.16, 0.44), child: _buildSearchField()),
                              _stagger(
                                animation: _section(0.24, 0.52),
                                child: Text(StringConst.nearBy, style: AppTextStyles.sectionTitle,),
                              ),
                              _stagger(
                                animation: _section(0.3, 0.62),
                                child: SizedBox(
                                  height: NumberConstant.nearbyCardHeight,
                                  child: ListView.separated(
                                    scrollDirection: .horizontal,
                                    itemCount: provider.nearbyExhibits.length,
                                    separatorBuilder: (_, _) => const SizedBox(width: NumberConstant.nearbyCardGap),
                                    itemBuilder: (context, index) => _buildNearbyCard(context, provider.nearbyExhibits[index]),
                                  ),
                                ),
                              ),
                              _stagger(
                                animation: _section(0.4, 0.7),
                                child: Text(StringConst.firstFloor, style: AppTextStyles.sectionTitle,),
                              ),
                            ],
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: NumberConstant.contentGap),),
                        SliverList.separated(
                          itemCount: provider.firstFloorExhibits.length,
                          separatorBuilder: (_, _) => const SizedBox(height: NumberConstant.listCardGap),
                          itemBuilder: (context, index) {
                            final exhibit = provider.firstFloorExhibits[index];
                            final begin = (0.45 + index * 0.06).clamp(0.0, 0.85);
                            final end = (begin + 0.2).clamp(0.0, 1.0);
                            return _stagger(
                              animation: _section(begin, end),
                              child: ExhibitListTile(
                                exhibit: exhibit,
                                onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: NumberConstant.horizontalPadding,
            bottom: MediaQuery.paddingOf(context).bottom + 24,
            child: _stagger(
              animation: _section(0.55, 0.9),
              child: _buildScannerFab(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      spacing: NumberConstant.contentGap,
      children: [
        SvgPicture.asset(AssetRes.icDrawer),
        Expanded(
          child: Container(
            padding: .symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: .circular(NumberConstant.cardRadius),
            ),
            child: Row(
              spacing: 5,
              children: [
                SvgPicture.asset(AssetRes.icLocationPin),
                Expanded(child: Text(StringConst.locationDefault, style: AppTextStyles.locationLabel,)),
                SvgPicture.asset(AssetRes.icDropdown)
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: .circular(NumberConstant.avatarRadius),
          child: Image.asset(AssetRes.profileAvatarImg, height: NumberConstant.avatarSize,)
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) => Container(
        height: NumberConstant.searchHeight,
        padding: .symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: .circular(NumberConstant.searchRadius),
        ),
        child: Row(
          spacing: NumberConstant.contentGap,
          children: [
            Expanded(
              child: TextField(
                onChanged: provider.updateQuery,
                style: AppTextStyles.searchHint,
                cursorColor: AppColors.textPrimary,
                decoration: InputDecoration(
                  isDense: true,
                  border: .none,
                  hintText: StringConst.searchHint,
                  hintStyle: AppTextStyles.searchHint,
                  contentPadding: .zero,
                ),
              ),
            ),
            SvgPicture.asset(AssetRes.icSearch)
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyCard(BuildContext context, ExhibitModel exhibit) {
    final metaIcon = exhibit.stepsAway != null ? AssetRes.icFootsteps : AssetRes.icTowardRight;
    final metaLabel = exhibit.stepsAway != null
        ? '${exhibit.stepsAway}${StringConst.stepsAwaySuffix}'
        : (exhibit.directionLabel ?? '');
    return _PressScale(
      onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
      child: SizedBox(
        width: NumberConstant.nearbyCardWidth,
        height: NumberConstant.nearbyCardHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: .circular(20),
                child: Image.asset(exhibit.imagePath, fit: .cover,)
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: GlassCard(
                padding: .all(12),
                child: Column(
                  spacing: 8,
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(child: Text(exhibit.title, style: AppTextStyles.cardTitle,)),
                        Text(exhibit.yearLabel, style: AppTextStyles.cardMeta,)
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 8,
                            children: [
                              SvgPicture.asset(metaIcon),
                              Flexible(child: Text(metaLabel,)),
                            ],
                          ),
                        ),
                        Container(
                          padding: .symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: .circular(NumberConstant.cardRadius),
                          ),
                          child: Text(StringConst.detail, style: AppTextStyles.detailButton,)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerFab(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return GestureDetector(
      onTap: () => context.push(NamedRoutes.scanning.routeName),
      child: AnimatedBuilder(
        animation: _fabPulse,
        builder: (context, child) {
          final t = reduceMotion ? 0.0 : Curves.easeInOut.transform(_fabPulse.value);
          final scale = 1 + 0.04 * t;
          final blur = 10 + 8 * t;
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: .all(21.5),
              decoration: BoxDecoration(
                color: AppColors.scannerDark,
                shape: .circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.scannerShadow,
                    blurRadius: blur,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(AssetRes.icScanner,),
      ),
    );
  }
}

class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressScale({required this.child, this.onTap});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
