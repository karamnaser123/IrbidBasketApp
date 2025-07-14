#!/bin/bash

echo "🚀 بدء إعداد تطبيق iOS للتصدير..."

# تنظيف البناء السابق
echo "🧹 تنظيف البناء السابق..."
flutter clean

# الحصول على التبعيات
echo "📦 تثبيت التبعيات..."
flutter pub get

# إنشاء الأيقونات
echo "🎨 إنشاء الأيقونات..."
dart run flutter_launcher_icons

echo "✅ تم إعداد التطبيق بنجاح!"
echo ""
echo "📱 الخطوات التالية:"
echo "1. افتح المشروع في Xcode:"
echo "   open ios/Runner.xcworkspace"
echo ""
echo "2. في Xcode:"
echo "   - اختر Bundle Identifier فريد"
echo "   - اختر Team الخاص بك"
echo "   - اختر Any iOS Device (arm64)"
echo "   - اذهب إلى Product > Archive"
echo ""
echo "3. في Organizer:"
echo "   - اختر Distribute App"
echo "   - اختر App Store Connect"
echo "   - اتبع الخطوات لإرسال التطبيق" 