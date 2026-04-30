# App Store Assets Configuration

## iOS (Apple App Store)

### App Icons
- 1024x1024 App Store icon
- 60x60@2x, 60x60@3x
- 58x58@2x, 87x87@3x
- 80x80@2x, 87x87@3x
- 167x167@2x (iPad Pro)

### Screenshots
- iPhone 8 (6.5-inch): 1242x2688
- iPhone 8 (5.5-inch): 1242x2208
- iPad Pro (12.9-inch): 2048x2732
- iPhone SE (4.7-inch): 1334x750

### App Store Connect Metadata
- App Name: Firefly Music Player
- Subtitle: Your Music, Anywhere
- Keywords: music, player, streaming, spotify, youtube
- Description: [See below]
- Privacy Policy: [See below]

### Required Assets
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Contents.json
├── Icon-App-20x20@1x.png
├── Icon-App-20x20@2x.png
├── Icon-App-20x20@3x.png
├── Icon-App-29x29@1x.png
├── Icon-App-29x29@2x.png
├── Icon-App-29x29@3x.png
├── Icon-App-40x40@1x.png
├── Icon-App-40x40@2x.png
├── Icon-App-40x40@3x.png
├── Icon-App-60x60@2x.png
├── Icon-App-60x60@3x.png
└── Icon-App-76x76@1x.png
```

## Android (Google Play Store)

### App Icons
- 48x48 (mdpi)
- 72x72 (hdpi)
- 96x96 (xhdpi)
- 144x144 (xxhdpi)
- 192x192 (xxxhdpi)

### Feature Graphics
- 1024x500 (recommended)

### Screenshots
- Phone: 1080x1920 (minimum)
- 7-inch tablet: 1280x720
- 10-inch tablet: 1280×800

### Play Store Listing
- App Name: Firefly Music Player
- Short Description: All your music in one place
- Full Description: [See below]
- Promo Video: [Optional]

### Required Assets
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

## Windows Store

### App Icons
- 150x150
- 44x44
- 50x50
- Small tile: 71x71

### Screenshots
- Minimum: 1366x768
- Recommended: 1920x1080

## macOS App Store

### App Icons
- 16x16@1x, 16x16@2x
- 32x32@1x, 32x32@2x
- 128x128@1x, 128x128@2x
- 256x256@1x, 256x256@2x
- 512x512@1x, 512x512@2x

### Screenshots
- 1280x800 (minimum)
- 2560x1600 (recommended)

## Web Store (PWA)

### Icons
- 192x192 (default)
- 512x512 (large)
- Favicon: 16x16, 32x32, 48x48

### Manifest
```json
{
  "name": "Firefly Music Player",
  "short_name": "Firefly",
  "theme_color": "#121212",
  "background_color": "#121212",
  "display": "standalone"
}
```
