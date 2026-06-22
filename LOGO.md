# Ease Your Finance - Brand Guidelines

**Your money, simplified.**

## Brand Identity

### Logo Design
The logo represents a **shield** (symbolizing privacy and security) with:
- **Teal gradient** (#1A5C4F to #2A9D8F) - matches the app's Material 3 theme
- **Wallet icon** - representing financial management
- **Upward trend line** - symbolizing financial growth and progress
- **Dollar sign** - representing money/currency
- **Company name** - "Ease Your Finance" in clean, modern typography
- **Tagline** - "Your money, simplified" reinforcing the app's mission

The shield shape emphasizes the app's **offline-first, privacy-focused** approach where all data stays on your device.

### Color Palette
| Color | Hex | Usage |
|-------|-----|-------|
| Primary Dark | `#1A5C4F` | Main brand color, headers, accents |
| Primary Mid | `#2A9D8F` | Secondary elements, gradients |
| Background Light | `#E9F5F2` | Light mode backgrounds |
| Text Dark | `#1A5C4F` | Primary text on light backgrounds |
| Text Gray | `#6B7280` | Secondary text, descriptions |

### Typography
- **Primary Font**: Inter (Google Fonts)
- **Headings**: Bold (700 weight)
- **Body**: Regular (400 weight)
- **Captions**: Light (300 weight)

## Files

### Logo Files
- `assets/logo.svg` - Primary SVG logo with company name and tagline
- `assets/logo_*.png` - PNG versions at various sizes (48px to 512px)
- `web/public/favicon.svg` - Web favicon (shield icon only)

### Configuration Files
- `flutter_launcher_icons.yaml` - Flutter icon generation config
- `web/manifest.json` - Web app manifest

## Updating the Logo

### For Web
1. Replace `web/public/favicon.svg` with your new logo
2. Update `web/manifest.json` if needed
3. Clear browser cache to see changes

### For Mobile Apps
After updating the PNG assets:
```bash
flutter pub run flutter_launcher_icons
```

This will regenerate app icons for Android and iOS.

### Creating High-Quality PNGs
The current PNG files are simple placeholders. To create proper icons:

1. Use the SVG file as reference
2. Create a high-resolution PNG (512x512 or larger)
3. Use an online tool like https://svgtopng.com or Figma/Adobe Illustrator
4. Replace the PNG files in `assets/`
5. Run `flutter pub run flutter_launcher_icons`

## Usage in Code

### Flutter
```dart
// Full logo with text
Image.asset('assets/logo.svg')

// Icon only (favicon)
Image.asset('assets/logo_48x48.png')
```

### React (Web)
```tsx
// Full logo with text
<img src="/favicon.svg" alt="Ease Your Finance" />

// In sidebar component
<img src="/favicon.svg" alt="Ease Your Finance" className="w-8 h-8" />
```

## Brand Guidelines

### Do's
- Always use the full company name "Ease Your Finance" (not abbreviated)
- The tagline "Your money, simplified" should appear below the company name
- Maintain the teal color scheme for consistency
- The shield icon can be used independently for favicons and app icons
- Use proper spacing and alignment

### Don'ts
- Don't abbreviate to "EYF" or "Ease Finance"
- Don't change the color palette
- Don't stretch or distort the logo
- Don't add effects like shadows or outlines to the logo
- Don't use the logo on busy backgrounds without proper contrast

## App Names by Platform

| Platform | Display Name |
|----------|--------------|
| Android | Ease Your Finance |
| iOS | Ease Your Finance |
| Web | Ease Your Finance |
| Package Name | `com.raylabs.expense_manager` |

## Contact Information

- **Email**: support@easeyourfinance.app
- **GitHub**: github.com/easeyourfinance
- **Twitter**: @EaseYourFinance

## Version History

- **1.0.0** - Initial release with full branding
