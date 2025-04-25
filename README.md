
<h1 align="center">🧢 Pokédex iOS App</h1>
<p align="center">A modern Pokédex for iOS built with UIKit — Fully native, clean architecture, and refined UI.</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.0%2B-blue" />
  <img src="https://img.shields.io/badge/Swift-5-orange" />
  <img src="https://img.shields.io/badge/Deep--Linking-Supported-green" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
</p>

---

## ✨ Features

> Explore the Pokémon universe with a fully native iOS experience — no third-party dependencies required.

## 📱 General Navigation
- Splash screen.
- Tab bar with:
  - Pokémons
  - Moves
  - Items

## 🧾 Pokémon List
- Infinite scroll (`UICollectionViewDataSourcePrefetching`).
- Real-time search.
- Colored type icons.
- Haptic Touch support.
- Tap to view details.

## 📘 Detail View
- Name, type and sprite.
- Visual base stats.
- Type weaknesses and resistances.
- Abilities, description, breeding, and capture info.
- Normal and shiny sprites.
- Evolution chain (including mega evolutions).
- Tab switcher: **Stats**, **Evolutions**, **Moves**.

## ⚔️ Moves
- Filterable list by type.
- Detail view with:
  - Type
  - Base Power
  - Accuracy
  - PP
  - Description

## 🎒 Items
- Poké Balls list.
- Detail with price, usage, and info.

## 📩 Push Notification + Deep Link Integration

- Navigate directly into the app through push notifications containing a **deep link**.
- Supports opening tabs like Pokémon, Moves, or Items directly.

#### 🔗 Deep Link Examples

| Action | URL Example |
|:---|:---|
| Open a move detail (Hyper Beam) | `dexperience://tab/moves/hyper-beam` |
| Open a Pokémon detail (Charizard) | `dexperience://tab/pokemons/charizard` |
| Open an item detail (Poké Ball) | `dexperience://tab/items/poke-ball` |

How to Test Deep Links Locally

You can manually trigger a deep link on a simulator or physical device using:

- Safari:
```bash
dexperience://tab/moves/hyper-beam
```

- Terminal
```bash
xcrun simctl openurl booted dexperience://tab/pokemons/charizard
```

> Replace the URL with any valid deep link.

#### 🛎️ Sample Push Notification Payload

```json
{
  "aps": {
    "alert": {
      "title": "Dexperience",
      "body": "Check out the details for the move: Hyper Beam!"
    },
    "sound": "default"
  },
  "deep_link": "dexperience://tab/moves/hyper-beam"
}
```

How to Simulate Push Notifications
> Use Xcode or xcrun simctl push to simulate a push notification with a deep link.

1. Save the JSON above into a file called push.apns.
2. Run the following command in Terminal:

```bash
xcrun simctl push booted com.your.bundle.id push.apns
```
 > Replace com.your.bundle.id with your actual app’s bundle identifier.

> ℹ️ **Note:**  
> If the app is closed, tapping the notification will launch the app and automatically navigate.  
> If the app is open, it will immediately handle the deep link navigation.
 
## 🧪 Technologies Used

- `UIKit` + `UICollectionViewCompositionalLayout`
- `DiffableDataSource`
- `Auto Layout` + `UIStackView`
- `MVVM` with reusable handlers
- Native infinite scroll
- Router-based navigation
- Deep link routing
- Native push notification handling
- Full Dark Mode support 🌙

## 🎨 Design Inspiration

Based on the free design:  
👉 [Pokedex App Sketch Freebie](https://www.sketchappsources.com/free-source/3989-pokedex-app-sketch-freebie-resource.html)

## 📽 Demo (GIF)

<p align="center">
  <img src="Demo/demo.gif" alt="App Demo" width="400"/>
</p>

## 🚀 Installation & Setup

Clone the repository:

```bash
git clone https://github.com/Jmejia-24/Dexperience.git
cd Dexperience
```

Open the project:
```bash
xed Dexperience.xcodeproj
```
Requirements:

- Xcode 16 or higher
- iOS 18.0+ deployment target
- Swift 5+

Then simply Run the project (⌘ + R) in your simulator or device.
