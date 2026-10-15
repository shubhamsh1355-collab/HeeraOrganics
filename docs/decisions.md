# Heera Organics — Architecture Decision Records (ADR)

**Document ID:** HO-ADR-001  
**Last Updated:** 2026-10-15  

---

### ADR-01: Framework Selection
- **Decision:** Flutter + Dart for Android and iOS.
- **Context:** Supersedes earlier exploratory mentions of Next.js, React Native, or PWA for the grocery customer app. A cross-platform native Flutter client provides 60fps animations, rich typography, smooth carousels, and responsive touch fidelity matching Google Stitch specifications.
- **Status:** Approved.

### ADR-02: State Management & Dependency Injection
- **Decision:** `flutter_riverpod` (v2.6+).
- **Context:** Compile-safe, test-friendly, decoupled from `BuildContext`, and enables straightforward swapping of mock repositories with live Odoo HTTP repositories.
- **Status:** Approved.

### ADR-03: Declarative Navigation
- **Decision:** `go_router` (v14+).
- **Context:** Supports deep linking, route parameters (e.g. `/product/:id`, `/order/:id`), and nested `ShellRoute` for fixed bottom navigation (Home, Categories, Search, Orders, Profile).
- **Status:** Approved.

### ADR-04: Visual Design Authority
- **Decision:** Google Stitch reference pack (`screen.png`, `code.html`, and `03_STITCH_DESIGN_SYSTEM.txt`).
- **Context:** Approved color palette (`#FFF8F1`, `#234C36`, `#DBF5D1`, `#EDE0A5`), serif typography (Literata + Source Serif 4), and warm naturalism. No heavy shadows, neon accents, or unapproved template designs.
- **Status:** Approved.

### ADR-05: Backend & Data Boundary
- **Decision:** 100% Mock Repositories during Frontend Phase; Odoo Community + PostgreSQL later.
- **Context:** Customer app will never query PostgreSQL directly. All future operations will be mediated by custom Odoo HTTP controllers.
- **Status:** Approved.
