---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
version: 1.0.0
author: vercel
source: https://github.com/vercel-labs/agent-skills
argument-hint: <file-or-pattern>
triggers:
  - review UI
  - check accessibility
  - audit design
  - review UX
  - best practices
  - a11y
  - WCAG
  - usability
  - dark mode
  - responsive
---

# Web Design Guidelines

**Version 1.0.0**
Vercel Engineering

> **Purpose:**
> UI code auditing against 100+ rules covering accessibility, performance, and UX.
> This skill performs compliance audits by evaluating code against web interface guidelines.

---

## How This Skill Works

1. **File Analysis**: Processes specified files or requests user input if none provided
2. **Rule Application**: Evaluates code against all guidelines below
3. **Output Format**: Reports findings using terse `file:line` notation

---

## Categories (13 total)

### 1. Accessibility

| Rule | Description |
|------|-------------|
| `aria-labels` | All interactive elements need accessible names |
| `semantic-html` | Use appropriate HTML5 semantic elements |
| `keyboard-support` | All functionality available via keyboard |
| `skip-links` | Provide skip navigation for keyboard users |
| `color-contrast` | Minimum 4.5:1 for normal text, 3:1 for large |
| `alt-text` | All images need descriptive alt attributes |
| `heading-hierarchy` | Use proper h1-h6 heading levels |
| `form-labels` | All form inputs need associated labels |
| `error-messages` | Form errors announced to screen readers |

### 2. Focus States

| Rule | Description |
|------|-------------|
| `visible-focus` | All focusable elements have visible focus indicators |
| `focus-visible` | Use `:focus-visible` for keyboard-only focus styles |
| `focus-order` | Tab order follows visual/logical order |
| `focus-trap` | Modals trap focus within themselves |
| `no-focus-loss` | Focus doesn't disappear when elements removed |

### 3. Forms

| Rule | Description |
|------|-------------|
| `autocomplete` | Use appropriate autocomplete attributes |
| `input-types` | Use correct input types (email, tel, url, etc.) |
| `label-association` | Labels properly associated with inputs |
| `validation-patterns` | Client-side validation with clear feedback |
| `required-fields` | Required fields clearly indicated |
| `error-prevention` | Confirmations for destructive actions |

### 4. Animation

| Rule | Description |
|------|-------------|
| `motion-preferences` | Respect `prefers-reduced-motion` |
| `compositor-properties` | Animate only transform/opacity for 60fps |
| `interruptibility` | Animations can be stopped/skipped |
| `no-flashing` | No content flashes more than 3x/second |
| `transition-duration` | Keep transitions under 400ms |

### 5. Typography

| Rule | Description |
|------|-------------|
| `proper-punctuation` | Use correct quotes, dashes, ellipses |
| `text-spacing` | Adequate line-height (1.5+) and letter-spacing |
| `numeric-formatting` | Use tabular figures for numbers in tables |
| `readable-font-size` | Minimum 16px for body text |
| `max-line-length` | Limit to 65-75 characters per line |

### 6. Content Handling

| Rule | Description |
|------|-------------|
| `text-truncation` | Truncate with ellipsis, provide full text access |
| `empty-states` | Meaningful empty states with actions |
| `long-input` | Handle unexpectedly long user input |
| `loading-states` | Show loading indicators for async operations |
| `error-states` | Clear error messaging with recovery options |

### 7. Images

| Rule | Description |
|------|-------------|
| `explicit-dimensions` | Set width/height to prevent layout shift |
| `lazy-loading` | Use `loading="lazy"` for below-fold images |
| `alt-text-quality` | Descriptive, not "image of" or filename |
| `responsive-images` | Use srcset for different screen sizes |
| `webp-fallback` | Provide WebP with fallback formats |

### 8. Performance

| Rule | Description |
|------|-------------|
| `virtualization` | Use virtual lists for 100+ items |
| `dom-batching` | Batch DOM mutations together |
| `preconnect` | Preconnect to required third-party origins |
| `font-loading` | Use font-display: swap or optional |
| `critical-css` | Inline critical CSS, defer rest |
| `image-optimization` | Compress and properly size images |

### 9. Navigation & State

| Rule | Description |
|------|-------------|
| `url-state` | Meaningful state reflected in URL |
| `deep-linking` | Support direct linking to states |
| `confirmation-patterns` | Confirm before destructive actions |
| `back-button` | Browser back works as expected |
| `breadcrumbs` | Provide location context in deep hierarchies |

### 10. Touch & Interaction

| Rule | Description |
|------|-------------|
| `tap-zones` | Minimum 44x44px touch targets |
| `selection-handling` | Text selection works appropriately |
| `safe-areas` | Respect device safe areas (notches, etc.) |
| `hover-alternatives` | Touch-friendly alternatives to hover |
| `scroll-behavior` | Smooth scrolling, respect preferences |

### 11. Dark Mode & Theming

| Rule | Description |
|------|-------------|
| `color-scheme` | Support `prefers-color-scheme` |
| `theme-meta-tag` | Set theme-color meta tag |
| `native-controls` | Style native controls for both themes |
| `image-adaptation` | Adjust images/icons for dark mode |
| `contrast-both-modes` | Maintain contrast in both themes |

### 12. Locale & i18n

| Rule | Description |
|------|-------------|
| `intl-dates` | Use Intl.DateTimeFormat for dates |
| `intl-numbers` | Use Intl.NumberFormat for numbers |
| `intl-currency` | Use Intl.NumberFormat for currency |
| `rtl-support` | Support right-to-left languages |
| `lang-attribute` | Set html lang attribute |

### 13. Hydration Safety

| Rule | Description |
|------|-------------|
| `controlled-inputs` | Consistent controlled vs uncontrolled |
| `rendering-guards` | Guard against SSR/client mismatches |
| `client-only-content` | Mark client-only content appropriately |
| `hydration-warnings` | No React hydration warnings |

---

## Anti-Patterns (DO NOT DO)

| Pattern | Problem |
|---------|---------|
| `div-soup` | Using divs instead of semantic elements |
| `mouse-only` | Interactions only work with mouse |
| `color-only-meaning` | Using color as only indicator |
| `auto-playing-media` | Media plays without user consent |
| `infinite-scroll-only` | No pagination alternative |
| `disabled-zoom` | Preventing user zoom on mobile |
| `placeholder-labels` | Using placeholder as label |
| `outline-none` | Removing focus outlines without replacement |
| `fixed-font-sizes` | Using px instead of rem/em |
| `layout-tables` | Using tables for layout |
| `autoplay-carousel` | Carousels that auto-advance |
| `captcha-only` | CAPTCHA without alternative |
| `time-limits` | Strict time limits without extension |

---

## Audit Output Format

When auditing, output findings as:

```
## Accessibility Issues

file.tsx:42 - Missing aria-label on button
file.tsx:87 - Color contrast ratio 3.2:1 (needs 4.5:1)

## Performance Issues

page.tsx:15 - Image missing explicit dimensions
layout.tsx:23 - No lazy loading on below-fold images

## UX Issues

form.tsx:56 - Required field not indicated
modal.tsx:12 - Focus not trapped in modal
```

---

## Quick Checklist

### Before Review, Check:

- [ ] All images have alt text
- [ ] All interactive elements are keyboard accessible
- [ ] Color contrast meets WCAG AA (4.5:1 / 3:1)
- [ ] Focus states are visible
- [ ] Form inputs have labels
- [ ] Error states provide clear guidance
- [ ] Loading states exist for async operations
- [ ] Dark mode respects system preference
- [ ] Touch targets are minimum 44x44px
- [ ] Animations respect reduced motion preference

---

## References

1. [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
2. [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
3. [Inclusive Components](https://inclusive-components.design/)
4. [A11y Project Checklist](https://www.a11yproject.com/checklist/)
5. [Vercel Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines)

---

**End of document**
