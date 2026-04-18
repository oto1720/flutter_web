# Flutter Web ポートフォリオサイト 実装ガイド

## 概要

Flutter公式推奨の構成でポートフォリオサイトを実装し、Firebase Hosting にデプロイするまでの手順。

---

## 1. ディレクトリ構成（Flutter公式推奨）

```
flutter_web/
├── lib/
│   ├── main.dart                  # エントリーポイント
│   ├── app.dart                   # MaterialApp の設定
│   ├── router/
│   │   └── app_router.dart        # go_router によるルーティング
│   ├── features/
│   │   ├── home/
│   │   │   └── home_page.dart     # トップページ
│   │   ├── about/
│   │   │   └── about_page.dart    # 自己紹介ページ
│   │   ├── works/
│   │   │   └── works_page.dart    # 制作物一覧ページ
│   │   └── contact/
│   │       └── contact_page.dart  # お問い合わせページ
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── nav_bar.dart       # ナビゲーションバー
│   │   │   └── footer.dart        # フッター
│   │   └── theme/
│   │       └── app_theme.dart     # テーマ定義
│   └── data/
│       └── portfolio_data.dart    # ポートフォリオのデータ定義
├── web/
│   ├── index.html                 # HTML エントリーポイント
│   ├── manifest.json              # PWA マニフェスト
│   └── favicon.png
├── assets/
│   └── images/                    # 画像素材
├── pubspec.yaml
└── PORTFOLIO_GUIDE.md
```

---

## 2. 使用パッケージ

`pubspec.yaml` の `dependencies` に追加：

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0        # Web向けURL対応ルーティング（公式推奨）
  url_launcher: ^6.3.0      # 外部リンクを開く
  google_fonts: ^6.2.1      # Googleフォント

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

パッケージ取得：
```bash
flutter pub get
```

---

## 3. 各ファイルの実装

### lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const PortfolioApp());
}
```

### lib/app.dart
```dart
import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'shared/theme/app_theme.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Portfolio',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### lib/router/app_router.dart
```dart
import 'package:go_router/go_router.dart';
import '../features/home/home_page.dart';
import '../features/about/about_page.dart';
import '../features/works/works_page.dart';
import '../features/contact/contact_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',       builder: (_, __) => const HomePage()),
    GoRoute(path: '/about',  builder: (_, __) => const AboutPage()),
    GoRoute(path: '/works',  builder: (_, __) => const WorksPage()),
    GoRoute(path: '/contact',builder: (_, __) => const ContactPage()),
  ],
);
```

### lib/shared/theme/app_theme.dart
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6CDF)),
    textTheme: GoogleFonts.notoSansJpTextTheme(),
    useMaterial3: true,
  );
}
```

### lib/shared/widgets/nav_bar.dart
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Portfolio'),
      actions: [
        TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
        TextButton(onPressed: () => context.go('/about'), child: const Text('About')),
        TextButton(onPressed: () => context.go('/works'), child: const Text('Works')),
        TextButton(onPressed: () => context.go('/contact'), child: const Text('Contact')),
        const SizedBox(width: 16),
      ],
    );
  }
}
```

### lib/features/home/home_page.dart
```dart
import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi, I\'m [Your Name]',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Flutter Developer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. レスポンシブ対応（LayoutBuilder）

Flutter Webではウィンドウ幅に応じてレイアウトを切り替える：

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= 900) {
      return const DesktopLayout();
    } else if (constraints.maxWidth >= 600) {
      return const TabletLayout();
    } else {
      return const MobileLayout();
    }
  },
)
```

公式ブレークポイントの目安：
| デバイス | 幅 |
|---|---|
| Mobile | < 600px |
| Tablet | 600px〜899px |
| Desktop | ≥ 900px |

---

## 5. ビルド

```bash
# Webビルド（本番用）
flutter build web --release

# 出力先: build/web/
```

### renderer の選択（任意）

```bash
# HTML renderer（互換性重視）
flutter build web --web-renderer html

# CanvasKit renderer（高品質・デフォルト）
flutter build web --web-renderer canvaskit
```

ポートフォリオサイトは `canvaskit`（デフォルト）で問題なし。

---

## 6. デプロイ — Firebase Hosting（推奨）

### 6-1. Firebase CLI のセットアップ

```bash
# Firebase CLI インストール
npm install -g firebase-tools

# ログイン
firebase login

# プロジェクト初期化（flutter_web ディレクトリで実行）
firebase init hosting
```

`firebase init hosting` の設定：
```
? What do you want to use as your public directory? build/web
? Configure as a single-page app (rewrite all urls to /index.html)? Yes
? Set up automatic builds and deploys with GitHub? No
```

### 6-2. firebase.json の確認

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

`rewrites` の設定が **go_router の URL直打ち対応** に必要（これがないと404になる）。

### 6-3. ビルド＆デプロイ

```bash
flutter build web --release && firebase deploy
```

デプロイ完了後、ターミナルに `Hosting URL: https://xxx.web.app` が表示される。

---

## 7. デプロイ — GitHub Pages（無料）

```bash
# gh-pages パッケージ（任意）
flutter build web --release --base-href "/リポジトリ名/"

# build/web を gh-pages ブランチに push
```

**注意:** GitHub Pages は SPA のリダイレクト対応が Firebase より手間がかかるため、Firebase Hosting 推奨。

---

## 8. 実装チェックリスト

- [ ] `go_router` でルーティング設定
- [ ] `NavBar` ウィジェットを全ページに適用
- [ ] `LayoutBuilder` でレスポンシブ対応
- [ ] `web/index.html` のタイトル・OGP を更新
- [ ] `web/manifest.json` のアプリ名・テーマカラーを更新
- [ ] `flutter build web --release` でビルド確認
- [ ] `firebase deploy` でデプロイ

---

## 9. よくあるハマりポイント

| 問題 | 原因 | 解決 |
|---|---|---|
| URL直打ちで404 | SPA rewrite未設定 | `firebase.json` に rewrites を追加 |
| 日本語フォントが遅い | CanvasKit がフォント全量ロード | `google_fonts` で必要フォントのみ指定 |
| 画像が表示されない | assets 未登録 | `pubspec.yaml` の `assets` セクションに追加 |
| ローカルで動くのに本番で崩れる | renderer の差異 | `--web-renderer` を明示的に指定 |

---

## 参考リンク

- [Flutter Web 公式ドキュメント](https://docs.flutter.dev/platform-integration/web)
- [go_router 公式](https://pub.dev/packages/go_router)
- [Firebase Hosting 公式](https://firebase.google.com/docs/hosting)
- [Flutter Web デプロイガイド](https://docs.flutter.dev/deployment/web)
