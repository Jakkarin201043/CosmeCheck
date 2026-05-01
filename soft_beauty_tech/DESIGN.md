---
name: Soft Beauty-Tech
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e4e2e1'
  on-surface: '#1b1c1c'
  on-surface-variant: '#424845'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0f0'
  outline: '#727975'
  outline-variant: '#c2c8c4'
  surface-tint: '#4a645a'
  primary: '#4a645a'
  on-primary: '#ffffff'
  primary-container: '#d1ede1'
  on-primary-container: '#536c63'
  inverse-primary: '#b1cdc1'
  secondary: '#6a5b55'
  on-secondary: '#ffffff'
  secondary-container: '#efdcd4'
  on-secondary-container: '#6e605a'
  tertiary: '#5e5d6b'
  on-tertiary: '#ffffff'
  tertiary-container: '#e8e5f6'
  on-tertiary-container: '#676674'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cde9dd'
  primary-fixed-dim: '#b1cdc1'
  on-primary-fixed: '#062019'
  on-primary-fixed-variant: '#334c43'
  secondary-fixed: '#f2dfd7'
  secondary-fixed-dim: '#d5c3bb'
  on-secondary-fixed: '#231915'
  on-secondary-fixed-variant: '#51443e'
  tertiary-fixed: '#e3e0f1'
  tertiary-fixed-dim: '#c7c5d5'
  on-tertiary-fixed: '#1b1a26'
  on-tertiary-fixed-variant: '#464553'
  background: '#fcf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e1'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  caption:
    fontFamily: Plus Jakarta Sans
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
  unit: 8px
  container-padding: 24px
  stack-sm: 12px
  stack-md: 24px
  stack-lg: 40px
  gutter: 16px
---

## Brand & Style

This design system is built on the concept of "Scientific Softness"—a bridge between clinical skincare precision and the comforting ritual of self-care. It utilizes a refined **Minimalist** style with **Tonal Layering** to create an interface that feels organized yet gentle. 

The aesthetic avoids the coldness of traditional medical apps by leaning into organic softness, high-quality whitespace, and a rhythmic use of pastel accents. The goal is to evoke a sense of calm and clarity, ensuring users feel supported rather than overwhelmed by dermatological data. It prioritizes accessibility through high-contrast typography against a pristine canvas, while maintaining a premium feel through generous margins and subtle motion.

## Colors

The palette is anchored by a pure white background to maximize "breathability" and cleanliness. 

- **Primary (Pale Mint):** Used for success states, active tracking, and primary brand touchpoints. It represents growth and skin health.
- **Secondary (Soft Peach):** Used for lifestyle elements, gentle warnings, or highlighting skin-tone related features.
- **Tertiary (Light Lavender):** Reserved for night-time routines, soothing treatments, and premium informational callouts.
- **Text (Charcoal Grey):** #2D2D2D provides high legibility without the harshness of pure black, maintaining the "soft" visual hierarchy.

Accent colors should be used as washes (backgrounds for cards or chips) rather than for heavy structural elements.

## Typography

This design system utilizes **Plus Jakarta Sans** for its modern, friendly, and open counters which mirror the approachable nature of the brand. 

- **Headlines:** Set with slightly tighter letter-spacing and heavier weights to provide a confident architectural anchor for pages.
- **Body Text:** Uses a generous line height (1.5x) to ensure clinical information is easy to digest and scan.
- **Labels:** Employ a medium/semi-bold weight to distinguish interactive elements from static content.

Maintain a strict vertical rhythm by ensuring all text blocks align to an 8px baseline grid.

## Layout & Spacing

The layout follows a **fluid grid** model optimized for mobile-first consumption. 

- **Margins:** A standard 24px side margin ensures content does not feel "crowded" against the screen edges.
- **Rhythm:** Spacing follows an 8px linear scale. Use 24px (stack-md) for separating standard card elements and 40px (stack-lg) for defining new sections.
- **Negative Space:** Whitespace is treated as a functional element. High-density information (like ingredient lists) must be broken up with ample padding to prevent cognitive fatigue.

## Elevation & Depth

Visual hierarchy is achieved through **Ambient Shadows** and **Tonal Layering** rather than heavy borders.

- **Surface Layers:** The base is #FFFFFF. Primary cards utilize a very soft, diffused shadow: `0px 10px 30px rgba(0, 0, 0, 0.04)`.
- **Active States:** When an element is pressed or active, the shadow should slightly contract, and a subtle 1px border in a pale pastel (e.g., Mint) may appear to signal selection.
- **Depth:** Elements should never feel "stuck" to the background; they should appear to float gently above the surface, suggesting a tactile, premium physical object.

## Shapes

The shape language is defined by **heavily rounded corners** that evoke a sense of safety and organic flow.

- **Primary Radius:** Cards and large containers use a minimum of 16px (1rem).
- **Secondary Radius:** Buttons and input fields use a 24px or fully "Pill" radius to emphasize touchability.
- **Iconography:** Icons must be thin-line (1.5px stroke) with rounded terminals. Avoid sharp corners in any custom iconography or decorative elements to maintain the "Soft" aesthetic.

## Components

- **Buttons:** Primary buttons use the Mint (#D1EDE1) background with Charcoal text. They are pill-shaped with high internal padding (16px vertical, 32px horizontal).
- **Cards:** White backgrounds with the defined ambient shadow and 16px corner radius. If a card contains a category, a pastel wash (Peach or Lavender) should be applied to the background with 10% opacity.
- **Input Fields:** Soft grey backgrounds (#F5F5F5) with 16px rounded corners. The focus state uses a 1px Mint border.
- **Chips:** Small, pill-shaped tags used for "Skin Type" or "Ingredient" labels. These use the pastel palette with 50% opacity backgrounds and 100% opacity text for contrast.
- **Progress Bars:** For "Routine Completion," use a thick 8px track with fully rounded ends, utilizing the Mint accent color.
- **Lists:** Clean, borderless lists separated by 16px of vertical space, using subtle chevron icons for navigation.