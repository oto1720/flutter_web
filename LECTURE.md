# Flutter Web ポートフォリオサイト デプロイ講座

## 概要

Flutter Web でポートフォリオサイトを作り、Firebase Hosting に公開するまでの手順を解説します。

**完成イメージ**
- Hero セクション（自己紹介）
- Skills セクション（スキル一覧）
- レスポンシブ対応（PC / スマホ自動切り替え）

**使用技術**
- Flutter 3.x（Web対応）
- go_router（URLルーティング）
- google_fonts（日本語フォント）
- Firebase Hosting（無料デプロイ）

---

## 事前準備

- Flutter SDK インストール済み
- Firebase アカウント作成済み（Google アカウントで OK）
- Firebase CLI インストール

```bash
npm install -g firebase-tools
```

---

## Step 1: プロジェクト作成

```bash
flutter create my_portfolio
cd my_portfolio
```

> **注意:** プロジェクト名に `web` は使わない。`package:web`（Flutterの内部パッケージ）と名前が衝突してビルドエラーになります。

---

## Step 2: ディレクトリ構成

Flutter 公式推奨の構成に整理します。

```
lib/
├── main.dart                      # エントリーポイント
├── app.dart                       # MaterialApp の設定
├── router/
│   └── app_router.dart            # ルーティング定義
├── features/
│   └── home/
│       └── home_page.dart         # ホームページ
└── shared/
    ├── theme/
    │   └── app_theme.dart         # テーマ定義
    └── widgets/
        └── nav_bar.dart           # ナビゲーションバー
```

---

## Step 3: パッケージ追加

`pubspec.yaml` の `dependencies` を以下に更新：

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^14.0.0      # Web向けURLルーティング（公式推奨）
  google_fonts: ^6.2.1    # Googleフォント
  url_launcher: ^6.3.0    # 外部リンクを開く
```

```bash
flutter pub get
```

---

## Step 4: 実装

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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
```

### lib/shared/theme/app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6CDF),
          brightness: Brightness.light,
        ),
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
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Text(
          'Portfolio',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}
```

### lib/features/home/home_page.dart

`LayoutBuilder` でデスクトップ（幅 900px 以上）とモバイルのレイアウトを自動切り替えします。

```dart
import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                _HeroSection(isDesktop: isDesktop),
                _SkillsSection(isDesktop: isDesktop),
                const _Footer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

（Hero / Skills / Footer の実装は省略。完成コードを参照。）

---

## Step 5: ローカル確認

```bash
flutter run -d chrome
```

---

## Step 6: Firebase プロジェクト作成

1. [Firebase コンソール](https://console.firebase.google.com/) を開く
2. 「プロジェクトを追加」→ プロジェクト名を入力 → 作成
3. 左メニューの「構築」→「Hosting」→「始める」をクリック

---

## Step 7: Firebase Hosting 初期化

```bash
# ログイン（ブラウザが開いてGoogle認証）
firebase login

# プロジェクトディレクトリで初期化
firebase init hosting
```

対話形式で以下を設定：

```
? Which Firebase project do you want to associate as default?
→ 作成したプロジェクトを選択

? What do you want to use as your public directory?
→ build/web  ← ここを必ず変更する（デフォルトの "public" のままにしない）

? Configure as a single-page app (rewrite all urls to /index.html)?
→ Yes

? Set up automatic builds and deploys with GitHub?
→ No（今回は手動デプロイ）
```

> **ハマりポイント:** `public directory` の入力を間違えると `firebase.json` が `"public": "public"` になり、Flutter のビルド成果物が配信されません。

---

## Step 8: firebase.json の確認

`firebase init hosting` 後に生成される `firebase.json` が以下になっていることを確認：

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

`rewrites` がない場合は手動で追加してください。URL 直打ちしたときに 404 にならないために必要です。

---

## Step 9: ビルド＆デプロイ

```bash
flutter build web --release && firebase deploy
```

成功すると以下が表示されます：

```
i  hosting[your-project]: found 32 files in build/web
✔  hosting[your-project]: file upload complete
✔  Deploy complete!

Hosting URL: https://your-project.web.app
```

---

## 更新方法

コードを修正したら同じコマンドを再実行するだけです：

```bash
flutter build web --release && firebase deploy
```

---

## セキュリティ注意事項

**コミットしてOKなファイル**

| ファイル | 理由 |
|---|---|
| `firebase.json` | ホスティング設定のみ |
| `.firebaserc` | プロジェクトIDは公開情報 |
| `lib/firebase_options.dart` | Web向けAPIキーは公開前提の設計 |

**絶対にコミットしないファイル**

| ファイル | 理由 |
|---|---|
| `serviceAccountKey.json` | Firebase Admin の秘密鍵 |
| `.env` | 環境変数ファイル |

`.gitignore` に以下を追加しておく：

```
serviceAccountKey.json
*-serviceAccountKey.json
.env
.env.*
```

---

## よくあるエラーと対処法

| エラー | 原因 | 対処 |
|---|---|---|
| `Invalid project id: YOUR_FIREBASE_PROJECT_ID` | `.firebaserc` にプレースホルダーが残っている | `.firebaserc` を削除して `firebase init hosting` を再実行 |
| `found 2 files in public` | `firebase.json` の `public` が `build/web` になっていない | `firebase.json` を修正して再デプロイ |
| ビルドエラー（`package:web` 衝突） | プロジェクト名が `web` になっている | `pubspec.yaml` の `name` を変更して `flutter clean && flutter pub get` |
| URL 直打ちで 404 | `rewrites` 未設定 | `firebase.json` に `rewrites` を追加 |
