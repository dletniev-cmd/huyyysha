# Bot Flow Builder (Flutter)

## Сборка APK через GitHub Actions
1. Создать пустой репозиторий на GitHub.
2. Залить содержимое этого архива в корень.
3. Перейти в Actions → Build APK → дождаться завершения.
4. Скачать артефакт `app-release-apk`.

## Что в этой версии
- Прозрачный statusbar (edge-to-edge).
- Бесконечный canvas с сеткой, pan + pinch zoom.
- Топ-бар с логотипом и двумя стеклянными iOS-кнопками (fullscreen, upload).
- FAB-капсула с **двумя** кнопками: сообщение и заметка. Эффект iOS-стекла (BackdropFilter blur 20).
- Иконки — Solar (вшиты как SVG в `assets/icons/`).
