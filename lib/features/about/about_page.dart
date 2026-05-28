import 'package:flutter/material.dart';
import '../../shared/widgets/fade_in_on_scroll.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/nav_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          return SingleChildScrollView(
            child: Column(
              children: [
                FadeInOnScroll(
                  child: _AboutSection(isDesktop: isDesktop),
                ),
                FadeInOnScroll(
                  delay: const Duration(milliseconds: 200),
                  child: _ExperienceSection(isDesktop: isDesktop),
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

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.isDesktop});
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
            'About Me',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Flutter を使ったモバイル・Web アプリケーション開発を行っています。\n'
            'ユーザー体験を大切にしたプロダクト作りが好きです。',
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

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({required this.isDesktop});
  final bool isDesktop;

  static const _experiences = [
    (title: 'Flutter アプリ開発', period: '2023 - 現在', desc: 'モバイル・Web アプリの設計と実装'),
    (title: 'Firebase 構築', period: '2023 - 現在', desc: 'バックエンド・インフラの設計と運用'),
    (title: 'UI/UX デザイン', period: '2022 - 現在', desc: 'Material Design に基づく UI 設計'),
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
      child: Column(
        children: [
          Text(
            'Experience',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          ..._experiences.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  title: Text(
                    e.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(e.desc),
                  trailing: Text(
                    e.period,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

