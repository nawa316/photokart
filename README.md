# 📸 PhotoKart

PhotoKart adalah aplikasi mobile berbasis **Flutter** yang dirancang sebagai platform **jual-beli photocard** secara terintegrasi. Aplikasi ini menghubungkan **buyer (kolektor)** dan **seller** dalam satu ekosistem yang menyediakan katalog produk, transaksi, chat real-time, serta sistem review dan rating untuk meningkatkan transparansi dan kenyamanan transaksi.

Backend aplikasi ini menggunakan **Supabase (Backend as a Service)** yang menangani autentikasi, database PostgreSQL, storage, dan real-time data.

---

## 🚀 Deskripsi Proyek

PhotoKart hadir untuk mengatasi permasalahan transaksi photocard yang sebelumnya dilakukan secara manual dan tersebar di berbagai platform media sosial. Dengan PhotoKart, seluruh proses mulai dari:

* Autentikasi pengguna
* Pengelolaan profil
* Manajemen produk
* Transaksi pembelian
* Sistem chat real-time
* Review dan rating produk

dapat dilakukan dalam **satu aplikasi terstruktur dan terintegrasi**.

Teknologi utama yang digunakan:

* **Flutter** → Frontend (Mobile & Web)
* **Supabase** → Backend (Auth, Database, Storage, Real-time)

---

## ⚙️ Cara Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/nawa316/photokart.git
cd photokart
```

### 2. Install Dependencies Flutter

Pastikan Flutter sudah terpasang, lalu jalankan:

```bash
flutter pub get
```

### 3. Konfigurasi Environment

Buat file `.env` di root project:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

> 🔑 Nilai `SUPABASE_URL` dan `SUPABASE_ANON_KEY` didapat dari dashboard Supabase.

### 4. Pastikan Supabase Terinisialisasi

Supabase diinisialisasi pada `main.dart` menggunakan package `supabase_flutter` dan `flutter_dotenv`.

---

## ▶️ Cara Menjalankan Aplikasi

### Menjalankan di Android / Emulator

```bash
flutter run
```

### Menjalankan di Web

```bash
flutter run -d chrome
```

### Build APK (Release)

```bash
flutter build apk --release
```

### Build Web

```bash
flutter build web
```

---

## 📂 Struktur Folder

Berikut gambaran struktur utama project PhotoKart:
```
photokart
├─ 📁.dart_tool
├─ 📁.vscode
│  └─ 📄settings.json
├─ 📁android
│  ├─ 📁app
│  │  ├─ 📁src
│  │  │  ├─ 📁debug
│  │  │  │  └─ 📄AndroidManifest.xml
│  │  │  ├─ 📁main
│  │  │  │  ├─ 📁java
│  │  │  │  │  └─ 📁io
│  │  │  │  │     └─ 📁flutter
│  │  │  │  │        └─ 📁plugins
│  │  │  │  │           └─ 📄GeneratedPluginRegistrant.java
│  │  │  │  ├─ 📁kotlin
│  │  │  │  │  └─ 📁com
│  │  │  │  │     └─ 📁example
│  │  │  │  │        └─ 📁photokart
│  │  │  │  │           └─ 📄MainActivity.kt
│  │  │  │  ├─ 📁res
│  │  │  │  │  ├─ 📁drawable
│  │  │  │  │  │  └─ 📄launch_background.xml
│  │  │  │  │  ├─ 📁drawable-v21
│  │  │  │  │  │  └─ 📄launch_background.xml
│  │  │  │  │  ├─ 📁mipmap-hdpi
│  │  │  │  │  │  └─ 📄ic_launcher.png
│  │  │  │  │  ├─ 📁mipmap-mdpi
│  │  │  │  │  │  └─ 📄ic_launcher.png
│  │  │  │  │  ├─ 📁mipmap-xhdpi
│  │  │  │  │  │  └─ 📄ic_launcher.png
│  │  │  │  │  ├─ 📁mipmap-xxhdpi
│  │  │  │  │  │  └─ 📄ic_launcher.png
│  │  │  │  │  ├─ 📁mipmap-xxxhdpi
│  │  │  │  │  │  └─ 📄ic_launcher.png
│  │  │  │  │  ├─ 📁values
│  │  │  │  │  │  └─ 📄styles.xml
│  │  │  │  │  └─ 📁values-night
│  │  │  │  │     └─ 📄styles.xml
│  │  │  │  └─ 📄AndroidManifest.xml
│  │  │  └─ 📁profile
│  │  │     └─ 📄AndroidManifest.xml
│  │  └─ 📄build.gradle.kts
│  ├─ 📁gradle
│  │  └─ 📁wrapper
│  │     └─ 📄gradle-wrapper.properties
│  ├─ 📄.gitignore
│  ├─ 📄build.gradle.kts
│  ├─ 📄gradle.properties
│  ├─ 📄local.properties
│  └─ 📄settings.gradle.kts
├─ 📁assets
│  ├─ 📁fonts
│  │  ├─ 📄Poppins-Black.ttf
│  │  ├─ 📄Poppins-BlackItalic.ttf
│  │  ├─ 📄Poppins-Bold.ttf
│  │  ├─ 📄Poppins-BoldItalic.ttf
│  │  ├─ 📄Poppins-ExtraBold.ttf
│  │  ├─ 📄Poppins-ExtraBoldItalic.ttf
│  │  ├─ 📄Poppins-ExtraLight.ttf
│  │  ├─ 📄Poppins-ExtraLightItalic.ttf
│  │  ├─ 📄Poppins-Italic.ttf
│  │  ├─ 📄Poppins-Light.ttf
│  │  ├─ 📄Poppins-LightItalic.ttf
│  │  ├─ 📄Poppins-Medium.ttf
│  │  ├─ 📄Poppins-MediumItalic.ttf
│  │  ├─ 📄Poppins-Regular.ttf
│  │  ├─ 📄Poppins-SemiBold.ttf
│  │  ├─ 📄Poppins-SemiBoldItalic.ttf
│  │  ├─ 📄Poppins-Thin.ttf
│  │  └─ 📄Poppins-ThinItalic.ttf
│  └─ 📁images
│     ├─ 📄bag.png
│     ├─ 📄bag_clicked.png
│     ├─ 📄cart.png
│     ├─ 📄cart_clicked.png
│     ├─ 📄center.png
│     ├─ 📄center_clicked.png
│     ├─ 📄chat.png
│     ├─ 📄chat_clicked.png
│     ├─ 📄google.png
│     ├─ 📄icon.png
│     ├─ 📄logo.png
│     ├─ 📄online_shopping.png
│     ├─ 📄profile.jpg
│     ├─ 📄profile.png
│     ├─ 📄profile_clicked.png
│     └─ 📄wanita_keranjang.png
├─ 📁build
├─ 📁ios
│  ├─ 📁Flutter
│  │  ├─ 📁ephemeral
│  │  │  ├─ 📄flutter_lldbinit
│  │  │  └─ 📄flutter_lldb_helper.py
│  │  ├─ 📄AppFrameworkInfo.plist
│  │  ├─ 📄Debug.xcconfig
│  │  ├─ 📄flutter_export_environment.sh
│  │  ├─ 📄Generated.xcconfig
│  │  └─ 📄Release.xcconfig
│  ├─ 📁Runner
│  │  ├─ 📁Assets.xcassets
│  │  │  ├─ 📁AppIcon.appiconset
│  │  │  │  ├─ 📄Contents.json
│  │  │  │  ├─ 📄Icon-App-1024x1024@1x.png
│  │  │  │  ├─ 📄Icon-App-20x20@1x.png
│  │  │  │  ├─ 📄Icon-App-20x20@2x.png
│  │  │  │  ├─ 📄Icon-App-20x20@3x.png
│  │  │  │  ├─ 📄Icon-App-29x29@1x.png
│  │  │  │  ├─ 📄Icon-App-29x29@2x.png
│  │  │  │  ├─ 📄Icon-App-29x29@3x.png
│  │  │  │  ├─ 📄Icon-App-40x40@1x.png
│  │  │  │  ├─ 📄Icon-App-40x40@2x.png
│  │  │  │  ├─ 📄Icon-App-40x40@3x.png
│  │  │  │  ├─ 📄Icon-App-60x60@2x.png
│  │  │  │  ├─ 📄Icon-App-60x60@3x.png
│  │  │  │  ├─ 📄Icon-App-76x76@1x.png
│  │  │  │  ├─ 📄Icon-App-76x76@2x.png
│  │  │  │  └─ 📄Icon-App-83.5x83.5@2x.png
│  │  │  └─ 📁LaunchImage.imageset
│  │  │     ├─ 📄Contents.json
│  │  │     ├─ 📄LaunchImage.png
│  │  │     ├─ 📄LaunchImage@2x.png
│  │  │     ├─ 📄LaunchImage@3x.png
│  │  │     └─ 📄README.md
│  │  ├─ 📁Base.lproj
│  │  │  ├─ 📄LaunchScreen.storyboard
│  │  │  └─ 📄Main.storyboard
│  │  ├─ 📄AppDelegate.swift
│  │  ├─ 📄GeneratedPluginRegistrant.h
│  │  ├─ 📄GeneratedPluginRegistrant.m
│  │  ├─ 📄Info.plist
│  │  └─ 📄Runner-Bridging-Header.h
│  ├─ 📁Runner.xcodeproj
│  │  ├─ 📁project.xcworkspace
│  │  │  ├─ 📁xcshareddata
│  │  │  │  ├─ 📄IDEWorkspaceChecks.plist
│  │  │  │  └─ 📄WorkspaceSettings.xcsettings
│  │  │  └─ 📄contents.xcworkspacedata
│  │  ├─ 📁xcshareddata
│  │  │  └─ 📁xcschemes
│  │  │     └─ 📄Runner.xcscheme
│  │  └─ 📄project.pbxproj
│  ├─ 📁Runner.xcworkspace
│  │  ├─ 📁xcshareddata
│  │  │  ├─ 📄IDEWorkspaceChecks.plist
│  │  │  └─ 📄WorkspaceSettings.xcsettings
│  │  └─ 📄contents.xcworkspacedata
│  ├─ 📁RunnerTests
│  │  └─ 📄RunnerTests.swift
│  ├─ 📄.gitignore
│  └─ 📄Podfile
├─ 📁lib
│  ├─ 📁core
│  │  ├─ 📁constant
│  │  │  └─ 📄supabase_constants.dart
│  │  ├─ 📁errors
│  │  │  └─ 📄failures.dart
│  │  ├─ 📁services
│  │  │  └─ 📄supabase_service.dart
│  │  └─ 📁widgets
│  │     ├─ 📄app_header.dart
│  │     ├─ 📄bottom_navbar.dart
│  │     └─ 📄search_bar_widget.dart
│  ├─ 📁features
│  │  ├─ 📁auth
│  │  │  ├─ 📁data
│  │  │  │  ├─ 📁datasources
│  │  │  │  │  └─ 📄auth_api.dart
│  │  │  │  └─ 📁repositories
│  │  │  │     └─ 📄auth_repository_impl.dart
│  │  │  ├─ 📁domain
│  │  │  │  ├─ 📁entities
│  │  │  │  │  └─ 📄user_model.dart
│  │  │  │  └─ 📁repositories
│  │  │  │     └─ 📄auth_repository.dart
│  │  │  └─ 📁presentation
│  │  │     └─ 📁pages
│  │  │        ├─ 📄email_verification_page.dart
│  │  │        ├─ 📄login_page.dart
│  │  │        ├─ 📄onboarding_page.dart
│  │  │        └─ 📄register_page.dart
│  │  ├─ 📁chat
│  │  │  ├─ 📁data
│  │  │  │  ├─ 📁datasources
│  │  │  │  │  └─ 📄chat_remote_datasource.dart
│  │  │  │  ├─ 📁models
│  │  │  │  │  ├─ 📄conversation_model.dart
│  │  │  │  │  └─ 📄message_model.dart
│  │  │  │  └─ 📁repositories
│  │  │  │     └─ 📄chat_repository_impl.dart
│  │  │  ├─ 📁domain
│  │  │  │  ├─ 📁entities
│  │  │  │  │  ├─ 📄conversation.dart
│  │  │  │  │  └─ 📄message.dart
│  │  │  │  └─ 📁repositories
│  │  │  │     └─ 📄chat_repository.dart
│  │  │  └─ 📁presentation
│  │  │     ├─ 📁pages
│  │  │     │  ├─ 📄chat_detail_page.dart
│  │  │     │  └─ 📄chat_overview.dart
│  │  │     └─ 📁widgets
│  │  │        └─ 📄chat_search_widget.dart
│  │  ├─ 📁home
│  │  │  ├─ 📁data
│  │  │  │  └─ 📄home_repository.dart
│  │  │  ├─ 📁domain
│  │  │  │  └─ 📄home_view_model.dart
│  │  │  └─ 📁presentation
│  │  │     ├─ 📁pages
│  │  │     │  └─ 📄homepage.dart
│  │  │     └─ 📁widget
│  │  │        ├─ 📄featured_card.dart
│  │  │        ├─ 📄small_product_card.dart
│  │  │        ├─ 📄top_sales_header.dart
│  │  │        └─ 📄top_sales_list.dart
│  │  ├─ 📁order
│  │  │  ├─ 📁data
│  │  │  │  ├─ 📁datasources
│  │  │  │  │  └─ 📄transaction_remote_datasource.dart
│  │  │  │  ├─ 📁models
│  │  │  │  │  └─ 📄transaction_model.dart
│  │  │  │  └─ 📁repositories
│  │  │  │     └─ 📄transaction_repository_impl.dart
│  │  │  ├─ 📁domain
│  │  │  │  ├─ 📁entities
│  │  │  │  │  └─ 📄transaction.dart
│  │  │  │  ├─ 📁repositories
│  │  │  │  │  └─ 📄transaction_repository.dart
│  │  │  │  └─ 📁usecases
│  │  │  │     └─ 📄get_user_transactions.dart
│  │  │  └─ 📁presentation
│  │  │     ├─ 📁pages
│  │  │     │  ├─ 📄order_detail_page.dart
│  │  │     │  ├─ 📄order_list_page.dart
│  │  │     │  └─ 📄order_view_page.dart
│  │  │     └─ 📁providers
│  │  │        └─ 📄order_list_provider.dart
│  │  ├─ 📁product
│  │  │  ├─ 📁data
│  │  │  │  ├─ 📄product_api.dart
│  │  │  │  ├─ 📄product_repository.dart
│  │  │  │  ├─ 📄product_storage.dart
│  │  │  │  └─ 📄top_rating_repository.dart
│  │  │  ├─ 📁domain
│  │  │  │  ├─ 📄product_model.dart
│  │  │  │  └─ 📄top_rating_view_model.dart
│  │  │  └─ 📁presentation
│  │  │     ├─ 📁pages
│  │  │     │  ├─ 📄buyer_product_detail_page.dart
│  │  │     │  ├─ 📄edit_product_wrapper.dart
│  │  │     │  ├─ 📄productpage.dart
│  │  │     │  ├─ 📄product_detail_wrapper.dart
│  │  │     │  ├─ 📄seller_addproduct.dart
│  │  │     │  ├─ 📄seller_edit_product.dart
│  │  │     │  ├─ 📄seller_product_detail_page.dart
│  │  │     │  └─ 📄top_sales.dart
│  │  │     └─ 📁widgets
│  │  │        ├─ 📄custom_popup.dart
│  │  │        ├─ 📄product_add_header.dart
│  │  │        └─ 📄product_card_model.dart
│  │  ├─ 📁profile
│  │  │  └─ 📁presentation
│  │  │     └─ 📁pages
│  │  │        ├─ 📄edit_profile_page.dart
│  │  │        ├─ 📄profile_page.dart
│  │  │        └─ 📄user_profile.dart
│  │  ├─ 📁revenue
│  │  │  └─ 📁presentation
│  │  │     └─ 📁pages
│  │  │        └─ 📄revenue_page.dart
│  │  └─ 📁review
│  │     ├─ 📁data
│  │     │  ├─ 📁datasources
│  │     │  │  └─ 📄review_remote_datasource.dart
│  │     │  └─ 📁repositories
│  │     │     └─ 📄review_repository.dart
│  │     ├─ 📁domain
│  │     │  └─ 📁entities
│  │     │     └─ 📄review.dart
│  │     └─ 📁presentation
│  │        ├─ 📁pages
│  │        │  ├─ 📄add_review_page.dart
│  │        │  └─ 📄reviewpage.dart
│  │        └─ 📁widgets
│  │           ├─ 📄rating_header.dart
│  │           ├─ 📄rating_summary_card.dart
│  │           └─ 📄review_card.dart
│  ├─ 📁router
│  │  └─ 📄app_router.dart
│  ├─ 📄app.dart
│  └─ 📄main.dart
├─ 📁linux
│  ├─ 📁flutter
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄generated_plugins.cmake
│  │  ├─ 📄generated_plugin_registrant.cc
│  │  └─ 📄generated_plugin_registrant.h
│  ├─ 📁runner
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄main.cc
│  │  ├─ 📄my_application.cc
│  │  └─ 📄my_application.h
│  ├─ 📄.gitignore
│  └─ 📄CMakeLists.txt
├─ 📁macos
│  ├─ 📁Flutter
│  │  ├─ 📁ephemeral
│  │  │  ├─ 📄Flutter-Generated.xcconfig
│  │  │  └─ 📄flutter_export_environment.sh
│  │  ├─ 📄Flutter-Debug.xcconfig
│  │  ├─ 📄Flutter-Release.xcconfig
│  │  └─ 📄GeneratedPluginRegistrant.swift
│  ├─ 📁Runner
│  │  ├─ 📁Assets.xcassets
│  │  │  └─ 📁AppIcon.appiconset
│  │  │     ├─ 📄app_icon_1024.png
│  │  │     ├─ 📄app_icon_128.png
│  │  │     ├─ 📄app_icon_16.png
│  │  │     ├─ 📄app_icon_256.png
│  │  │     ├─ 📄app_icon_32.png
│  │  │     ├─ 📄app_icon_512.png
│  │  │     ├─ 📄app_icon_64.png
│  │  │     └─ 📄Contents.json
│  │  ├─ 📁Base.lproj
│  │  │  └─ 📄MainMenu.xib
│  │  ├─ 📁Configs
│  │  │  ├─ 📄AppInfo.xcconfig
│  │  │  ├─ 📄Debug.xcconfig
│  │  │  ├─ 📄Release.xcconfig
│  │  │  └─ 📄Warnings.xcconfig
│  │  ├─ 📄AppDelegate.swift
│  │  ├─ 📄DebugProfile.entitlements
│  │  ├─ 📄Info.plist
│  │  ├─ 📄MainFlutterWindow.swift
│  │  └─ 📄Release.entitlements
│  ├─ 📁Runner.xcodeproj
│  │  ├─ 📁project.xcworkspace
│  │  │  └─ 📁xcshareddata
│  │  │     └─ 📄IDEWorkspaceChecks.plist
│  │  ├─ 📁xcshareddata
│  │  │  └─ 📁xcschemes
│  │  │     └─ 📄Runner.xcscheme
│  │  └─ 📄project.pbxproj
│  ├─ 📁Runner.xcworkspace
│  │  ├─ 📁xcshareddata
│  │  │  └─ 📄IDEWorkspaceChecks.plist
│  │  └─ 📄contents.xcworkspacedata
│  ├─ 📁RunnerTests
│  │  └─ 📄RunnerTests.swift
│  ├─ 📄.gitignore
│  └─ 📄Podfile
├─ 📁scripts
│  └─ 📄setup_flutter.sh
├─ 📁test
│  └─ 📄widget_test.dart
├─ 📁web
│  ├─ 📁icons
│  │  ├─ 📄Icon-192.png
│  │  ├─ 📄Icon-512.png
│  │  ├─ 📄Icon-maskable-192.png
│  │  └─ 📄Icon-maskable-512.png
│  ├─ 📄favicon.png
│  ├─ 📄index.html
│  └─ 📄manifest.json
├─ 📁windows
│  ├─ 📁flutter
│  │  ├─ 📁ephemeral
│  │  │  └─ 📁.plugin_symlinks
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄generated_plugins.cmake
│  │  ├─ 📄generated_plugin_registrant.cc
│  │  └─ 📄generated_plugin_registrant.h
│  ├─ 📁runner
│  │  ├─ 📁resources
│  │  │  └─ 📄app_icon.ico
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄flutter_window.cpp
│  │  ├─ 📄flutter_window.h
│  │  ├─ 📄main.cpp
│  │  ├─ 📄resource.h
│  │  ├─ 📄runner.exe.manifest
│  │  ├─ 📄Runner.rc
│  │  ├─ 📄utils.cpp
│  │  ├─ 📄utils.h
│  │  ├─ 📄win32_window.cpp
│  │  └─ 📄win32_window.h
│  ├─ 📄.gitignore
│  └─ 📄CMakeLists.txt
├─ 📄.gitignore
├─ 📄.metadata
├─ 📄analysis_options.yaml
├─ 📄FILE_STRUCTURE_OVERVIEW.md
├─ 📄FINAL_SUMMARY.md
├─ 📄pubspec.lock
├─ 📄pubspec.yaml
├─ 📄README.md
├─ 📄START_HERE.md
└─ 📄vercel.json
```

### Penjelasan Singkat

* **core/** → Infrastruktur utama (Supabase, error handling)
* **features/** → Struktur modular per fitur (Clean Architecture)
* **data** → Model, datasource, repository implementation
* **domain** → Entity & use case
* **presentation** → UI, state management, dan logic tampilan
* **shared/** → Widget dan theme yang digunakan bersama

---

## 🔗 Link Terkait

* **Repository GitHub**:
  [https://github.com/nawa316/photokart](https://github.com/nawa316/photokart)
* **Demo Web (Vercel)**:
  [https://photokart-agzj.vercel.app/](https://photokart-agzj.vercel.app/)

---
