# Jup Split Wise

A Flutter application for managing group expenses, splitting bills, and tracking payments among friends or groups — inspired by apps like Splitwise — but powered by Solana and Jupiter for seamless token-based settlements.

---

## 🧩 Problem Statement

Traditional expense-splitting apps assume all users deal in the same currency or payment method. But in the crypto world, users often hold different tokens across different wallets.

**Jup Split Wise solves this** by enabling:
- Group members to **contribute using any Solana token** (e.g., BONK, JUP, SOL)
- The system to **auto-swap contributions into a preferred token** (like USDC) using Jupiter Swap API
- The bill creator to **receive full payment in their chosen token**, no matter what tokens friends contribute

**Example:**
> Rent bill = ₹15,000 (~180 USDC)  
> Friend A pays 500,000 BONK  
> Friend B pays 2 JUP  
> → All are auto-swapped and settled to 180 USDC into the bill owner's wallet.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Main Models](#main-models)
- [Main Screens](#main-screens)
- [Dependencies](#dependencies)

---

## Features

- **User Authentication**: Secure login and authentication flow.
- **Group Management**: Create, join, and manage groups for splitting expenses.
- **Expense Tracking**: Add, split, and track expenses within groups.
- **Auto Token Swap via Jupiter**: Contributions in any SPL token, auto-swapped to target token (e.g., USDC).
- **Payment Settlement**: Record payments made to settle balances.
- **Profile Management**: Manage user profile and view transaction history.

---

## 🧰 Tech Stack

- **Flutter** – Cross-platform UI toolkit
- **GetX** – State management, routing, and DI
- **Supabase** – Backend-as-a-service (PostgreSQL DB + Auth)
- **Solana** – Blockchain for token transfers
- **Jupiter Aggregator API** – Token swap engine
- **Solana Web3 SDK (Go + JS)** – Transaction generation and signing
- **Material Design** – UI Components

---

## Screenshots

> _Add screenshots of your application here for better presentation._

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart >= 2.17.0
- A device or emulator to run the app

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/dontaskit28/jup-split-wise.git
   cd jup-split-wise
   
2. **Fetch dependencies:**
   
sh
   flutter pub get


3. **Run the app:**
   
sh
   flutter run


## Project Structure

lib/
  controllers/    # Business logic and state management (e.g., AuthController)
  models/         # Data models (e.g., Group, Member, Expense)
  routes/         # App routing and navigation
  screens/        # UI screens for all app features
  services/       # API/services integration
  main.dart       # App entry point


## Main Models

- [coins_data.dart](lib/models/coins_data.dart): Manages supported coins/currencies for splitting.
- [expense_model.dart](lib/models/expense_model.dart): Represents an expense, with details like amount, payer, and group.
- [group_model.dart](lib/models/group_model.dart): Represents a group, including members and expenses.
- [member_model.dart](lib/models/member_model.dart): Represents a group member.
- [split_model.dart](lib/models/split_model.dart): Handles the logic for splitting expenses.

## Main Screens

- [login_screen.dart](lib/screens/login_screen.dart): User authentication and login UI.
- [home_screen.dart](lib/screens/home_screen.dart): Main dashboard displaying groups and actions.
- [group_screen.dart](lib/screens/group_screen.dart): Lists all groups a user is part of.
- [group_detailed.dart](lib/screens/group_detailed.dart): Detailed view of a group, including expenses and balances.
- [group_info_screen.dart](lib/screens/group_info_screen.dart): Shows group information and member list.
- [join_group_screen.dart](lib/screens/join_group_screen.dart): UI for joining a new group.
- [pay_expense_screen.dart](lib/screens/pay_expense_screen.dart): Screen for settling debts/payments.
- [profile_screen.dart](lib/screens/profile_screen.dart): User profile management.

Each screen is modular and managed via [GetX](https://pub.dev/packages/get) for routing and state management.

## App Entry Point

The app initializes in [main.dart](lib/main.dart):

dart
void main() {
  runApp(const BillSplitApp());
}


- Uses GetMaterialApp for navigation.
- AuthController is injected for global access.
- Initial navigation is set to the login screen.

## Dependencies

- **Flutter**: UI toolkit for building natively compiled apps.
- **GetX**: State management, routing, and dependency injection.
- **Material Design**: Standard Flutter material widgets.

_See pubspec.yaml for the full list of dependencies._

