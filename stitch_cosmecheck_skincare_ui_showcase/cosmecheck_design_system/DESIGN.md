---
name: CosmeCheck Design System
colors:
  surface: '#f5fafa'
  surface-dim: '#d5dbda'
  surface-bright: '#f5fafa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff5f4'
  surface-container: '#e9efee'
  surface-container-high: '#e4e9e8'
  surface-container-highest: '#dee4e3'
  on-surface: '#171d1c'
  on-surface-variant: '#3d4949'
  inverse-surface: '#2c3231'
  inverse-on-surface: '#ecf2f1'
  outline: '#6d7a79'
  outline-variant: '#bcc9c8'
  surface-tint: '#006a6a'
  primary: '#006a6a'
  on-primary: '#ffffff'
  primary-container: '#10a7a7'
  on-primary-container: '#003535'
  inverse-primary: '#5dd9d8'
  secondary: '#005cba'
  on-secondary: '#ffffff'
  secondary-container: '#448ffd'
  on-secondary-container: '#002959'
  tertiary: '#495f82'
  on-tertiary: '#ffffff'
  tertiary-container: '#8197bd'
  on-tertiary-container: '#172f4f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#7cf5f5'
  primary-fixed-dim: '#5dd9d8'
  on-primary-fixed: '#002020'
  on-primary-fixed-variant: '#004f50'
  secondary-fixed: '#d7e3ff'
  secondary-fixed-dim: '#abc7ff'
  on-secondary-fixed: '#001b3f'
  on-secondary-fixed-variant: '#00458e'
  tertiary-fixed: '#d5e3ff'
  tertiary-fixed-dim: '#b1c7f0'
  on-tertiary-fixed: '#001c3b'
  on-tertiary-fixed-variant: '#314769'
  background: '#f5fafa'
  on-background: '#171d1c'
  surface-variant: '#dee4e3'
typography:
  headline-xl:
    fontFamily: Manrope
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: IBM Plex Sans Thai
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: IBM Plex Sans Thai
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: IBM Plex Sans Thai
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: IBM Plex Sans Thai
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: IBM Plex Sans Thai
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  margin-mobile: 20px
  gutter-mobile: 16px
---

## Brand & Style

The design system is engineered to feel like a high-end clinical assistant—reliable, precise, yet deeply approachable. It balances the sterile authority of medical technology with the soft, lifestyle-oriented nature of skincare. 

The aesthetic follows a **Modern Corporate** style infused with **Soft Minimalism**. It prioritizes extreme clarity and legibility to reduce cognitive load when users analyze complex chemical ingredients. The emotional response should be one of "Clinical Safety": users must feel that the information provided is scientifically backed and that the app is a protective partner in their wellness journey. High-quality imagery, generous whitespace, and a focus on content over decorative elements define this system.

## Colors

The palette is rooted in "Medical Teal" and "Scientific Blue," colors traditionally associated with hygiene and trust. 

- **Primary Teal (#10A7A7):** Used for primary actions, success states, and brand identifiers. It provides a refreshing, clean energy.
- **Secondary Blue (#2F80ED):** Used for supporting information, links, and secondary interactive elements.
- **Text Navy (#0B2545):** This deep, low-vibrancy navy ensures maximum contrast against the light background while appearing more premium and less harsh than pure black.
- **Background (#F6FBFF):** A very cool, tinted white that eliminates screen glare and reinforces the clinical atmosphere.
- **Semantic Colors:** Warning Coral (#FF6B6B) is reserved strictly for hazardous ingredients or high-risk alerts, while Success Green (#27AE60) denotes safety and "clean" ingredient matches.

## Typography

The typography system utilizes a dual-font approach to maximize both premium feel and functional readability. 

**Manrope** is used for headlines to provide a modern, geometric, and confident look. Its open counters and clean lines pair perfectly with the medical tech aesthetic.

**IBM Plex Sans Thai** is the workhorse for body and label text. It is a modern sans-serif that treats Thai characters with equal weight and clarity to Latin characters, ensuring that ingredient names and medical descriptions remain highly legible even at smaller sizes.

A strict hierarchy is maintained: larger weights are used for ingredient titles and risk levels, while body text uses generous line heights (1.5x - 1.6x) to ensure users can comfortably read long lists of chemical components.

## Layout & Spacing

The layout philosophy follows a **Fluid Grid** model with a focus on generous internal padding. 

- **Mobile Layout:** 4-column grid with 20px side margins and 16px gutters.
- **Spacing Rhythm:** An 8pt spatial system is used for most structural elements, with a 4pt scale used for micro-adjustments within components like chips or icons.
- **Whitespace:** Extra "breathing room" (24px - 32px) is used between major sections to prevent the UI from feeling cluttered with technical data. Vertical stacks of cards should use a minimum of 16px spacing to maintain a clear visual separation of distinct data points.

## Elevation & Depth

This design system uses **Ambient Shadows** and **Tonal Layering** to create a sense of organized hierarchy without relying on heavy lines.

- **Base Layer:** The light blue background (#F6FBFF) acts as the canvas.
- **Card Layer:** White surfaces (#FFFFFF) sit on top of the base. They use a very subtle, diffused shadow: `0px 4px 20px rgba(11, 37, 69, 0.05)`. This creates a soft lift that suggests the cards are floating and interactable.
- **Active States:** Buttons and active selections may increase shadow depth to `0px 8px 24px rgba(16, 167, 167, 0.15)`, using a slight tint of the primary color to suggest glow and vitality.
- **Dividers:** Hairline borders (1px) in a very light grey-blue are used only when absolutely necessary to separate items within a single white card.

## Shapes

The shape language is defined by **Soft Roundedness**.

- **Standard Cards:** 16px corner radius.
- **Large Container/Banners:** 24px corner radius for a more friendly, welcoming feel.
- **Buttons & Chips:** 12px or fully pill-shaped (rounded-full) depending on the context. Pill shapes are preferred for "Ingredient Chips" to make them feel like individual, tactile objects.
- **Input Fields:** 12px corner radius to balance the professional look with the overall softness of the app.

## Components

### Buttons
- **Primary:** Large (56px height), solid Teal (#10A7A7) with white text. Use 16px or pill-shaped corners.
- **Secondary:** White background with Teal border and text.
- **Ghost:** Navy text with no background, used for "See All" or "Dismiss" actions.

### Ingredient Chips
- High-contrast badges for risk levels. 
- **Safe:** Light green tint background with Success Green text.
- **Warning:** Light coral tint background with Warning Coral text.
- **Neutral:** Light blue tint with Navy text.

### Safety Badges
- Circular or pill-shaped icons with a "Seal of Approval" visual metaphor. Use subtle gradients of Teal and Blue to indicate premium/verified status.

### Input Fields
- Clean, 56px height containers with a subtle 1px border in a muted navy-grey. Focus states should transition the border to Primary Teal and add a subtle inner glow.

### Cards
- The primary vehicle for content. Every card must have a 16px-24px radius, white background, and a soft ambient shadow. Internal padding should be a minimum of 16px.

### Progress Indicators
- For "Skin Analysis" or "Product Scanning," use thin, fluid circular or linear loaders in Primary Teal to maintain the high-tech feel.