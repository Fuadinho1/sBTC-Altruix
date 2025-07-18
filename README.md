
#  sBTC-Altruix Relief Smart Contract

## Overview

The **sBTC Donation Relief** smart contract is a decentralized and secure system for managing charitable donations using the Stacks blockchain. It supports donation intake, fund allocation to verified recipients, withdrawal control through cooldowns, and administrative oversight.

> 🛡️ Designed with security and transparency in mind, the contract features admin controls, withdrawal cooldowns, emergency shutdown, refund support, and event logging.

---

## 🚀 Features

* ✅ **Users can:**

  * Donate STX to the contract
  * Request refunds (within 24 hours)
  * View personal donation and withdrawal history

* 👨‍💼 **Administrators can:**

  * Add, update, or remove recipients
  * Adjust donation limits
  * Transfer admin role
  * Pause/resume the contract
  * Shutdown the contract in emergencies

* 📥 **Recipients can:**

  * Withdraw allocated funds (respecting cooldown period)

---

## 📦 Data Structures

### Constants

```clojure
ERR_UNAUTHORIZED       ;; (err u1)
ERR_INVALID_AMOUNT     ;; (err u2)
ERR_INSUFFICIENT_FUNDS ;; (err u3)
ERR_RECIPIENT_NOT_FOUND;; (err u4)
ERR_RECIPIENT_EXISTS   ;; (err u5)
ERR_NOT_CONFIRMED      ;; (err u8)
ERR_UNCHANGED_STATE    ;; (err u9)
withdrawal-cooldown    ;; 86400 (24 hours)
```

### Data Variables

| Variable       | Type        | Description                    |
| -------------- | ----------- | ------------------------------ |
| `total-funds`  | `uint`      | Total STX donated              |
| `admin`        | `principal` | Current contract administrator |
| `min-donation` | `uint`      | Minimum allowed donation       |
| `max-donation` | `uint`      | Maximum allowed donation       |
| `paused`       | `bool`      | Paused state of the contract   |

### Maps

| Map               | Key         | Value  | Description                            |
| ----------------- | ----------- | ------ | -------------------------------------- |
| `donations`       | `principal` | `uint` | Total donation by a user               |
| `recipients`      | `principal` | `uint` | STX allocation to recipient            |
| `last-withdrawal` | `principal` | `uint` | Timestamp of last recipient withdrawal |

---

## 🔧 Functions

### 👥 User Functions

#### `donate(amount)`

Donate STX to the pool. Must respect min/max limits and contract must not be paused.

#### `request-refund(amount)`

Refund donation if within cooldown period (24 hours from donation).

#### `get-donation(user)`

Returns total donation amount by a user.

#### `get-user-history(user)`

Returns user's donation and last withdrawal info.

---

### 🏦 Recipient Functions

#### `withdraw(amount)`

Withdraw allocated funds. Requires:

* Not paused
* Sufficient allocation
* At least 24 hours since last withdrawal

#### `get-recipient-allocation(recipient)`

Check current allocation for a recipient.

---

### 🔐 Admin Functions

#### `add-recipient(principal, allocation)`

Add a new recipient and allocate funds. Recipient must not already exist.

#### `update-recipient-allocation(principal, new-allocation)`

Update an existing recipient's allocation.

#### `remove-recipient(principal)`

Remove a recipient immediately (no confirmation required).

#### `confirm-remove-recipient(principal, confirm)`

Remove recipient with confirmation flag.

#### `set-admin(new-admin)`

Transfer admin rights to another principal.

#### `set-donation-limits(min, max)`

Update the donation min/max boundaries.

#### `set-paused(new-paused-state)`

Pause or resume contract operations. Prevents donations and withdrawals.

#### `emergency-shutdown()`

Immediately pauses the contract for emergency intervention.

#### `log-audit(action-type, actor)`

Log custom actions (placeholder; currently only returns `true`).

#### `get-admin()`

Returns current admin principal.

---

## 📝 Events (via `print`)

The contract prints events for better indexing and transparency:

* `donation` – user donations
* `recipient-added` – when new recipient is added
* `withdrawal` – on recipient withdrawals
* `recipient-removed` – when recipient is removed
* `contract-pause-changed` – when pause state is toggled
* `donation-limits-updated` – on min/max change
* `emergency-shutdown` – when contract is halted

---

## 🧪 Example Usage

### Donate:

```clojure
(donate u1000000) ;; Donate 1 STX (assuming 6 decimals)
```

### Admin adds recipient:

```clojure
(add-recipient 'SPXYZ...ABC u5000000)
```

### Recipient withdraws:

```clojure
(withdraw u1000000)
```

---
