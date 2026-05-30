import 'package:flutter/material.dart';
import '../../shared/utils/breakpoints.dart';
import '../../shared/widgets/fade_in_on_scroll.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/nav_bar.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.isDesktop;
          return SingleChildScrollView(
            child: Column(
              children: [
                FadeInOnScroll(
                  child: _WorkHeader(isDesktop: isDesktop),
                ),
                FadeInOnScroll(
                  delay: const Duration(milliseconds: 200),
                  child: _WorkGrid(isDesktop: isDesktop),
                ),
                const Footer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WorkHeader extends StatelessWidget {
  const _WorkHeader({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 24,
        vertical: isDesktop ? 80 : 48,
      ),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'これまでに取り組んだプロジェクトの一覧です。',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkGrid extends StatelessWidget {
  const _WorkGrid({required this.isDesktop});
  final bool isDesktop;

  static const _projects = [
    (
      title: 'ポートフォリオサイト',
      desc: 'Flutter Web で構築した自己紹介サイト。レスポンシブ対応、アニメーション付き。',
      icon: Icons.web_rounded,
      tags: ['Flutter', 'Web', 'Firebase'],
    ),
    (
      title: 'タスク管理アプリ',
      desc: 'Firestore をバックエンドに使ったリアルタイム同期のタスク管理アプリ。',
      icon: Icons.check_circle_outline_rounded,
      tags: ['Flutter', 'Firestore', 'Auth'],
    ),
    (
      title: 'チャットアプリ',
      desc: 'リアルタイムメッセージング機能を備えたチャットアプリ。プッシュ通知対応。',
      icon: Icons.chat_bubble_outline_rounded,
      tags: ['Flutter', 'Firebase', 'FCM'],
    ),
    (
      title: 'EC サイト UI',
      desc: '商品一覧・カート・決済フローを含む EC アプリの UI プロトタイプ。',
      icon: Icons.shopping_bag_outlined,
      tags: ['Flutter', 'UI/UX', 'Stripe'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 24,
        vertical: 80,
      ),
      color: theme.colorScheme.surfaceContainerLowest,
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: _projects
            .map((p) => _WorkCard(
                  title: p.title,
                  desc: p.desc,
                  icon: p.icon,
                  tags: p.tags,
                  isDesktop: isDesktop,
                ))
            .toList(),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({
    required this.title,
    required this.desc,
    required this.icon,
    required this.tags,
    required this.isDesktop,
  });

  final String title;
  final String desc;
  final IconData icon;
  final List<String> tags;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: SizedBox(
        width: isDesktop ? 340 : double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map((tag) => Chip(
                          label: Text(
                            tag,
                            style: theme.textTheme.labelSmall,
                          ),
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

