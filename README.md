# Omsk Seaty
Приложение для поиска лавочек в городе с использованием карты. Пользователи платформы могут смотреть и оценивать уже существующие или добавлять новые лавки.

Лавочки делятся на категории и организуется их ТОП на основе оценок пользователей.

Каждая новая лавочка проходит проверку модератором.

# Требования
- Минимальная версия Android: 5.0 Lolipop (SDK 21)
- Установленный Flutter SDK. [Инструкция](https://flutter.dev/docs/get-started/install)

# Как запустить
1. Склонируйте репозиторий.
2. Установите дополнение Flutter для [VSCode](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) или [Intellij IDEA](https://plugins.jetbrains.com/plugin/9212-flutter)
3. Для запуска наберите в консоли ```flutter run``` или в меню вашей IDE Run

# Архитектура
В качестве паттерна использовался [BLoC](https://bloclibrary.dev).

# Основные зависимости
Эти сторонние сервисы необходимы для работы приложения:

- [Google Maps API](https://developers.google.com/maps/documentation) для отрисовки карты на экране.
- [Firebase](https://firebase.google.com) для аналитики, отправки отчётов, отправки сборок и авторизации.
- [Fastlane](https://fastlane.tools/) для автоматизации сборки и их отправления в Firebase. 

# Скриншоты
![](https://raw.githubusercontent.com/Unchuris/omsk-seaty-mobile/develop/screenshots/screenshot1.png?token=AE3KWBGP5XUYPOULZWU72KK7JH246)
![](https://raw.githubusercontent.com/Unchuris/omsk-seaty-mobile/develop/screenshots/screenshot2.png?token=AE3KWBE727MW5ZZ6DQOK2HS7JH3BQ)
![](https://raw.githubusercontent.com/Unchuris/omsk-seaty-mobile/develop/screenshots/screenshot3.png?token=AE3KWBG74LN76BVIV7YFR227JH3CO)
![](https://raw.githubusercontent.com/Unchuris/omsk-seaty-mobile/develop/screenshots/screenshot4.png?token=AE3KWBF6OPXHJKFEEAJXEOS7JH3D6)
# Сопровождающие
Проект поддерживается силами этих людей:
- Владислав Унчурис (автор идеи)
- Андрей Краснов
- Максим Турчин
