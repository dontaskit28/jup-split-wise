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
