# EasyPoll - Anonymous Live Q&A and Audience Polling Web Application

A full-stack, mobile-first web application for anonymous live polling and audience Q&A, rebranded as **EasyPoll** with a soft Neumorphic UI.

---

## 🚀 Live Demo & Quick Start (Zero Setup Needed)

Because EasyPoll is built with pure, modular **HTML5, CSS3, and Vanilla JavaScript**, it requires **zero build steps** and works immediately in any web browser!

1. **Unified Login & Portal:** Open `login.html` in your browser.
   - Switch easily between **🛡️ Admin** and **👤 Participant**.
   - **Admin Credentials:** `admin` / `password123`.
2. **Host Dashboard:** Open `host.html` directly to manage questions, share sessions, and evaluate real-time responses.
3. **Audience / Participant View:** Open `index.html` (or `index.html?poll=poll-topic-selection`) to vote with **zero login required** and **100% strict anonymity**.

> 💡 **Cross-Tab Real-Time Sync:** Open `host.html` in one browser tab and `index.html` in another tab. As you tap options or submit paragraph answers as a participant, the host dashboard updates **live in real-time**!

---

## 🎨 Design & Interface Details

### 1. Neumorphic Welcome & Login Screen (`login.html`)
- **Aesthetic:** Soft 3D Neumorphic / Glassmorphism UI with inset shadows, subtle ambient floating spheres, and dark mode moon toggle.
- **Brand Logo:** Modern 3D glossy wave emblem for **EasyPoll** (the previous triangle/ACCURATE logo has been removed).
- **Authentication & Credential Editing:**
  - Username or Email input with prefix user icon.
  - Password input with lock icon and an interactive **Show / Hide** eye toggle.
  - **Edit Admin Username & Password:** Click **"Change Username / Password"** on the login screen or go to **Settings > Admin Credentials** in the host dashboard. Requires verifying the **Old Password** to set a new username and new password!
  - Custom blue **"Remember Me"** checkbox + **"Forgot Password?"** (loads active credentials).
  - Glowing blue pill button: **"Login →"**.
  - **No Google or Facebook Logins:** As requested, third-party social logins have been cleanly removed.
- **Dual-Role Access:** Segmented tabs allow instant switching between **Admin Login** and **Participant Access** (join session anonymously with zero passwords).

### 2. Quizzes & Polls Host Dashboard (`host.html`)
- **Deep Navy Sidebar:** Gradient wave background, EasyPoll branding, and active blue pill navigation.
- **KPI Summary Cards:**
  - `Quizzes: 12`
  - `Polls: 8`
  - `+ Create` gradient dropdown menu (*Create Quiz* / *Create Poll*).
- **Filter Tabs & Data Table:** Tabs for `All (20)`, `Quizzes (12)`, and `Polls (8)` with status badges (`Active` / `Closed`) and 3-dots action menus (`⋮`).

### 3. Poll Creator Studio (`host.html`)
- Breadcrumbs (`Polls > Create Poll`), blue gradient banner, and `Poll Title` input.
- Drag handle `:::`, circular question badges, question type dropdowns (**Multiple Choice** vs. **Short Answer / Paragraph**), duplicate, and delete actions.
- Customizable MCQ options grid with emoji/icon picker, `+ Add Option`, and a right-hand sticky question summary navigator.

### 4. Real-Time Evaluation & Analytics Dashboard (`host.html`)
- **Left Column (MCQ Results & Rates):** Displays per-question response rates (e.g., *"Question 1: 92% answered (46/50 participants)"*), visual gradient progress bars, percentages (e.g., *"57%"*), and exact member vote counts (e.g., *"26 members"*).
- **Right Column (Paragraph Responses):** Dedicated column displaying anonymous response cards with timestamps, quote bubbles, and live pulse animations.
- **QR Code & Share Modal:** Automatically generates a high-resolution scannable QR code with a one-click **"Copy Link"** button and direct **"Open As Participant"** launcher.

### 5. Participant Mobile-First Interface (`index.html`)
- **Built Specifically for Smartphones:**
  - **Zero Desktop Clutter:** Confusing top headers/admin login links removed from the mobile screen.
  - **Mobile App Bar:** Sleek EasyPoll 3D wave emblem with real-time green live pulse indicator (`🟢 Live Session`).
  - **Instant Visual Security:** Prominent badge assuring `🔒 100% Anonymous • No Login Required`.
  - **Thumb-Friendly Touch Targets:** Large 54px-tall option cards with option letters (`A`, `B`, `C`, `D`), instant active press feedback (`scale(0.985)`), and animated checkmark radio circles.
  - **Descriptive Q&A on Mobile:** `font-size: 16px` on textareas (strictly prevents annoying iOS Safari auto-zoom), live word and character counters (`0 words • 0 / 2000 chars`).
  - **Vibrant Submit Button:** Prominent, full-width thumb button with loading spinner and smooth auto-scroll.
  - **Instant Reassurance Screen:** Celebratory green checkmark with live synchronization confirmation.
  - **Waiting Screen:** Real-time radar wave animation that automatically displays questions the second the presenter asks them on the spot!
  - **Safe Area Insets:** Full support for `viewport-fit=cover` on iPhones with notches and Android punch-hole displays.

---

## 🔒 Strict, Unlinkable Anonymity Guarantee

To protect audience privacy and encourage honest feedback:
- **No Identifiable Columns in Database:** The `responses` table records **only**:
  - `poll_id`
  - `question_id`
  - `option_id` (for MCQ)
  - `answer_text` (for open-ended questions)
  - `created_at` (timestamp)
- **No IP addresses, user IDs, emails, device fingerprints, or cookies** are ever stored in the database.
- The presenter/host can **never** trace a response back to an individual.

---

## 🗄️ Supabase Cloud Database Connection

1. Open your [Supabase Dashboard](https://supabase.com) and go to the **SQL Editor**.
2. Run the script in `schema.sql`.
3. Under **Project Settings > API**, copy your **Project URL** and **Anon Key**.
4. In `host.html`, click **"Config"** in the bottom-left sidebar, paste your credentials, and click **Save & Connect**. The indicator dot will turn green (`Supabase Live`).
