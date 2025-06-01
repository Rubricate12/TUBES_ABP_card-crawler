# Card Crawler

Card Crawler is a card game, built with Flutter. In this game, there are 4 types of cards: Weapon, Accessory, Consumable, and Monster. Each card can have different effects that will activate when their conditions are met. The player is considered to have won the game if all the cards in the deck have been used up and the player still has remaining health (more than 0).

## Screenshots:

<img src="https://github.com/user-attachments/assets/bb087549-2d71-4090-bc20-77ae6fc8b341">
<img src="https://github.com/user-attachments/assets/e39b031a-f69a-4fce-8e7a-7b7d705fc8ff">

## Features:

* **Save & Continue**
* **Leaderboard**
* **Achievements**

## Technologies Used:

### Languages:
* **Dart**

### Frameworks:
* **Flutter**

### State Management:
* **Provider**

## How to Run:

**Prerequisites:**

* Flutter SDK installed (Follow instructions at [flutter.dev](https://flutter.dev/docs/get-started/install)).
* An editor (Android Studio with Flutter plugin, or VS Code with Flutter extension).
* To run the app on a specific platform (iOS, Android, web, desktop), ensure you have the necessary development tools and SDKs for that platform installed. Please refer to the official Flutter documentation for detailed platform-specific setup: [Build and release for different platforms](https://docs.flutter.dev/deployment).

**Backend Server Setup (For Certain Features):**

* This application can run without connecting to the backend server, but some features that require server communication will not function.
* For these features to work, the [Laravel Backend](https://github.com/Rubricate12/API_cardcrawler) should be set up and running. (Please refer to the backend repository for its specific setup instructions).
* If running the backend locally:
    * The device hosting the backend server **must be configured with the IP address `127.168.0.99`**.
    * The device or emulator running this app **must be on the same Wi-Fi network** as the device hosting the backend server.

**Steps:**

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/maruffirdaus/card-crawler.git
    ```
2.  **Navigate into the directory:**
    ```bash
    cd card-crawler
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **(Optional) Prepare backend:** If you intend to use features that require the backend, ensure your Laravel backend is running, the IP of the device hosting the backend is set to `127.168.0.99`, and your app device is on the same Wi-Fi.
5.  **Run the app:**
    ```bash
    flutter run
    ```
