# Bot Flow Builder — Flutter (Android)

Это перенос HTML-приложения Bot Flow Builder на Flutter.
Текущая стадия: первый экран (canvas с сеткой, pan/zoom, прозрачный statusbar, top bar, FAB-меню, индикатор зума) — 1-в-1 по дизайну.

Дальше будут добавлены ноды, связи, bottom-sheet редактор, таймер и т.д.

## Сборка APK через GitHub Actions

1. Создай новый репозиторий на GitHub.
2. Залей содержимое этого архива в репозиторий (через `git push` или drag-and-drop в веб-интерфейсе).
3. Перейди во вкладку **Actions** репозитория — workflow `Build APK` запустится автоматически на push (или запусти вручную: Actions → Build APK → Run workflow).
4. Когда workflow завершится (зелёная галочка, ~5–8 минут), открой запуск и скачай артефакт `bot-flow-builder-apk` — внутри `app-release.apk`.
5. Перекинь APK на Android-устройство и установи (нужно разрешить установку из неизвестных источников).

> Папки `android/` и `ios/` в архиве НЕ включены — их сгенерирует `flutter create .` прямо в CI (это стандартная практика, экономит мегабайты в репозитории и гарантирует совместимость с текущим Flutter SDK).

## Локальный запуск (опционально)

```bash
flutter create --platforms=android,ios --org com.botflow --project-name bot_flow_builder .
flutter pub get
flutter run
```

## Структура

```
lib/
  main.dart                  — entry, тема, прозрачный statusbar
  theme/app_colors.dart      — палитра 1-в-1 из HTML (--bg, --accent, и т.д.)
  screens/builder_screen.dart— главный экран
  widgets/
    top_bar.dart             — верхняя панель (логотип + 2 круглые кнопки)
    canvas_view.dart         — canvas с сеткой, pan + pinch zoom
    fab_menu.dart            — раскрывающаяся капсула слева снизу
```
