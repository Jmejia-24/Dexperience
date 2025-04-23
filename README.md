
<h1 align="center">🧢 Pokédex iOS App</h1>
<p align="center">A modern Pokédex for iOS built with UIKit — Fully native, clean architecture, and refined UI.</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.0%2B-blue" />
  <img src="https://img.shields.io/badge/Swift-5-orange" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
</p>

---

### ✨ Features

> Explore the Pokémon universe with a fully native iOS experience — no third-party dependencies required.

#### 📱 General Navigation
- Splash screen.
- Tab bar with:
  - Pokémons
  - Moves
  - Items

#### 🧾 Pokémon List
- Infinite scroll (`UICollectionViewDataSourcePrefetching`).
- Real-time search.
- Colored type icons.
- Haptic Touch support.
- Tap to view details.

#### 📘 Detail View
- Name, type and sprite.
- Visual base stats.
- Type weaknesses and resistances.
- Abilities, description, breeding, and capture info.
- Normal and shiny sprites.
- Evolution chain (including mega evolutions).
- Tab switcher: **Stats**, **Evolutions**, **Moves**.

#### ⚔️ Moves
- Filterable list by type.
- Detail view with:
  - Type
  - Base Power
  - Accuracy
  - PP
  - Description

#### 🎒 Items
- Poké Balls list.
- Detail with price, usage, and info.

### 🧪 Technologies Used

- `UIKit` + `UICollectionViewCompositionalLayout`
- `DiffableDataSource`
- `Auto Layout` + `UIStackView`
- `MVVM` with reusable handlers
- Native infinite scroll
- Router-based navigation
- Full Dark Mode support 🌙

### 🎨 Design Inspiration

Based on the free design:  
👉 [Pokedex App Sketch Freebie](https://www.sketchappsources.com/free-source/3989-pokedex-app-sketch-freebie-resource.html)

### 📽 Demo (GIF)

👉 [Click here to view the full demo GIF](Demo/demo.gif)
