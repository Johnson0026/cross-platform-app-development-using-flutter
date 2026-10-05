# MindLog — Figma UI/UX Design Specification

Author: **Johnson Pillai** (Roll No: 150096724110)  
Course: **B.Tech CSE & AI — Major Project Specification**  
Target Platform: Mobile (iOS/Android 390x844px), Web/Desktop (Responsive 1280x832px)

---

## 🎨 1. Global Color Palette

### Light Mode Palette
| Color Role | Hex Code | Usage / Notes |
| :--- | :--- | :--- |
| **Primary Brand (Teal)** | `#007A78` | App header, primary buttons, active indicators |
| **Primary Container** | `#CCEBEA` | Progress badge background, soft highlight cards |
| **Secondary Accent (Lavender)** | `#8A76A6` | Secondary badges, progress step 2 cue |
| **Background (Scaffold)** | `#F2F7F7` | Calming overall background tint |
| **Surface / Cards** | `#FFFFFF` | Elevation cards, input containers |
| **On Surface Text** | `#192323` | High-contrast body & heading text |
| **Secondary Text** | `#5C6B6B` | Subtitles, date labels, placeholders |

### Dark Mode Palette
| Color Role | Hex Code | Usage / Notes |
| :--- | :--- | :--- |
| **Primary Brand (Teal)** | `#4DB6AC` | High visibility primary accents on dark |
| **Primary Container** | `#004D40` | Dark mode step badge background |
| **Secondary Accent (Lavender)** | `#B39DDB` | Soft purple accents |
| **Background (Scaffold)** | `#111717` | Deep calming dark backdrop |
| **Surface / Cards** | `#1E2A2A` | Elevated dark surface cards |
| **On Surface Text** | `#E1E8E8` | Light crisp body & heading text |
| **Secondary Text** | `#90A0A0` | Dimmed captions and timestamps |

### Mood Accent Colors
| Mood Category | Emoji | Accent Hex Code | Visual Meaning |
| :--- | :---: | :--- | :--- |
| **Great** | 😄 | `#2E7D32` | Vibrant Soothing Green |
| **Good** | 🙂 | `#00796B` | Calming Teal |
| **Okay** | 😐 | `#F57F17` | Gentle Warm Amber |
| **Low** | 😔 | `#7E57C2` | Soft Lavender Purple |
| **Awful** | 😢 | `#C62828` | Soft Muted Red |

---

## 🔤 2. Typography & Hierarchy

Font Family: **Roboto / SF Pro Display / Inter**

| Style Name | Font Size | Weight | Line Height | Application |
| :--- | :--- | :--- | :--- | :--- |
| **Display Header** | 24px | Bold (700) | 32px | Screen Main Titles ("How are you feeling today?") |
| **AppBar Title** | 20px | SemiBold (600) | 26px | Top Navigation Bar Title ("MindLog") |
| **Section Title** | 18px | Bold (700) | 24px | Form section headers, Mood labels in details |
| **Card Title / Mood Label**| 15px | SemiBold (600) | 20px | Mood chip title text under emoji |
| **Body Regular** | 15px | Regular (400) | 22px | Multiline journal note body text |
| **Caption / Timestamp** | 12px | Medium (500) | 16px | Date group headers, timestamps, char counts |
| **Step Badge Text** | 12px | Bold (700) | 14px | UPPERCASE progress badge labels ("STEP 1 OF 3") |

---

## 📐 3. Spacing, Grids & Component Anatomy

- **Screen Padding**: 20px Horizontal, 16px Vertical.
- **Card Radius**: 16px to 20px rounded corners.
- **Grid Layout**: 2-column grid on mobile (min-width 140px per chip), 3-column grid on web (>600px width).
- **Elevation**: Elevation 2 (soft drop shadow `y=4, blur=12, opacity=0.04`).

---

## 📱 4. Frame-by-Frame Figma Screen Specs

### Frame 1: Splash / Welcome Screen (Frame Size: 390x844px)
- **Top Bar**: Clean empty status bar.
- **Center Hero Graphic**: Large circular icon (90x90px) `#007A78` with white smiling icon.
- **Title**: "MindLog" (32px Bold), Subtitle: "Track your mood. Nurture your mind." (16px Medium).
- **Bottom CTA**: "Get Started" Primary Filled Button (350x52px, Radius 14px).
- **Flow Trigger**: Tapping "Get Started" navigates to **Frame 2 (Mood Picker)**.

### Frame 2: Mood Picker Screen (Step 1 of 3) (Frame Size: 390x844px)
- **AppBar**: Title "MindLog", Right Actions: Dark/Light Mode Switch Icon + History Book Icon.
- **Top Badge**: Pill Badge `#CCEBEA` -> Text: "STEP 1 OF 3 • MOOD SELECTION" (12px Bold UPPERCASE).
- **Prompt Header**: "How are you feeling today?" (24px Bold, Centered).
- **Instruction**: "Select an emoji that best describes your current emotional state." (14px Regular).
- **Grid Container**: 5 Tappable Cards arranged in 2x3 grid:
  1. Card 1: 😄 Great
  2. Card 2: 🙂 Good
  3. Card 3: 😐 Okay
  4. Card 4: 😔 Low
  5. Card 5: 😢 Awful
- **Interaction Animation**: Card selection triggers 1.22x scale up + 50% opacity fade animation (300ms duration).
- **Bottom Button**: "View Journal History" Outlined Button (350x48px).
- **Flow Trigger**: Tapping any Mood Card transitions automatically to **Frame 3 (Journal Entry)**.

### Frame 3: Journal Entry Screen (Step 2 of 3) (Frame Size: 390x844px)
- **AppBar**: Title "MindLog Note", Back Button, Theme Switch Icon.
- **Top Badge**: Pill Badge `#E1D5E7` -> Text: "STEP 2 OF 3 • JOURNAL NOTE" (12px Bold).
- **Selected Mood Banner**: Card with 1.5px border matching selected mood color. Left: 40px Emoji, Middle: "Feeling Great" + Today's Date ("Sunday, Oct 4, 2026"), Right: "Change" TextButton.
- **Form Section**:
  - Title: "What's on your mind today?" (18px Bold).
  - Multiline Input Field (Height 160px, Radius 14px, Grey Fill `#FFFFFF`, Border `#E0E0E0`).
  - Placeholder: "Write a few lines about your day, feelings, achievements..."
  - Counter: "42 / 500 characters" aligned to bottom right.
- **Action Buttons**:
  - "Save Journal Entry" Filled Primary Button (Height 52px).
  - "Back to Mood Picker" Outlined Button (Height 48px).
- **Flow Trigger**: Tapping "Save Journal Entry" executes validation check, saves entry, displays SnackBar, and navigates to **Frame 4 (Entry History)**.

### Frame 4: Entry History Screen (Step 3 of 3) (Frame Size: 390x844px)
- **AppBar**: Title "Journal History", Actions: Theme Toggle + Plus Add Button.
- **Top Badge**: Pill Badge -> Text: "STEP 3 OF 3 • JOURNAL HISTORY" (12px Bold).
- **List Container**: Grouped `ListView`:
  - Section Header 1: "TODAY" (12px Bold Teal).
  - Item 1 Card: Circular Emoji Icon (52x52px), Mood Badge ("Great"), Time ("2:30 PM"), Note preview truncated at 2 lines ("Had a wonderful time building...").
  - Section Header 2: "YESTERDAY" (12px Bold Teal).
  - Item 2 Card: 🙂 Good (10:15 AM).
- **Swipe Action**: Swiping an item left reveals Red Delete Background ("Swipe to Delete" + Trash Icon).
- **Empty State (Alternative View)**: Book Icon (90x90px), "No Journal Entries Yet", "Pick Today's Mood" Primary Button.
- **Floating Action Button**: "+ Log Today" Extended FAB at bottom right.
- **Flow Trigger**: Tapping any history tile opens **Frame 5 (Entry Detail)**.

### Frame 5: Entry Detail Screen (Frame Size: 390x844px)
- **AppBar**: Title "Entry Detail", Actions: Edit Icon, Delete Icon (Red), Theme Switcher Icon.
- **Header Card**: Large Mood Emoji Circle (64x64px), Mood Label ("Great" 22px Bold), Date ("Sunday, Oct 4, 2026"), Time ("Logged at 2:30 PM").
- **Content Section**:
  - Section Header: "Journal Reflection" (18px Bold).
  - White Paper Container (Full width, Padding 20px, Radius 16px): Full journal note text rendered with line height 1.5.
- **Bottom Action Bar**:
  - Left: "Edit Note" Outlined Button.
  - Right: "Delete" Filled Red Button (triggers confirmation modal dialog).

---

## 🔗 5. Figma Prototype Connections & Flow Arrows

```text
[Frame 1: Splash] 
      └──(Tap "Get Started")──> [Frame 2: Mood Picker] ──(Tap Mood Card)──> [Frame 3: Journal Entry]
                                      │                                              │
                               (Tap "History")                                 (Tap "Save")
                                      │                                              │
                                      ▼                                              ▼
                               [Frame 5: Entry Detail] <──(Tap Entry Tile)── [Frame 4: Entry History]
                                      │
                               (Tap "Edit Note") ──> [Frame 3: Journal Entry]
```

### Prototype Interaction Details:
1. **Transition from Frame 2 to Frame 3**: `Smart Animate` or `Push Right` (Duration: 300ms, Ease Out).
2. **Mood Selection Feedback**: Instant scale animation (1.0 -> 1.22 -> 1.0) on the tapped card.
3. **Transition from Frame 3 to Frame 4**: `Slide Up` / `Fade` with Floating SnackBar notification.
4. **Swipe-to-Delete Interaction in Frame 4**: `Drag Left` revealing confirmation dialog overlay.
