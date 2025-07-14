#!/usr/bin/env python3
"""
سكريبت لإنشاء أيقونة افتراضية للتطبيق
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_default_icon():
    """إنشاء أيقونة افتراضية للتطبيق"""
    
    # إنشاء مجلد الأيقونات إذا لم يكن موجوداً
    os.makedirs("assets/icon", exist_ok=True)
    
    # إنشاء صورة 1024x1024
    size = 1024
    image = Image.new('RGBA', (size, size), (52, 152, 219, 255))  # لون أزرق جميل
    
    # إنشاء كائن الرسم
    draw = ImageDraw.Draw(image)
    
    # إضافة دائرة بيضاء في المنتصف
    circle_center = size // 2
    circle_radius = size // 3
    draw.ellipse([
        circle_center - circle_radius,
        circle_center - circle_radius,
        circle_center + circle_radius,
        circle_center + circle_radius
    ], fill=(255, 255, 255, 255))
    
    # إضافة كرة سلة في المنتصف
    ball_radius = circle_radius // 2
    draw.ellipse([
        circle_center - ball_radius,
        circle_center - ball_radius,
        circle_center + ball_radius,
        circle_center + ball_radius
    ], fill=(255, 165, 0, 255))  # لون برتقالي للكرة
    
    # إضافة خطوط الكرة
    line_color = (139, 69, 19, 255)  # لون بني
    line_width = 8
    
    # خط أفقي
    draw.line([
        (circle_center - ball_radius + 20, circle_center),
        (circle_center + ball_radius - 20, circle_center)
    ], fill=line_color, width=line_width)
    
    # خط عمودي
    draw.line([
        (circle_center, circle_center - ball_radius + 20),
        (circle_center, circle_center + ball_radius - 20)
    ], fill=line_color, width=line_width)
    
    # حفظ الأيقونة
    icon_path = "assets/icon/app_icon.png"
    image.save(icon_path, "PNG")
    print(f"✅ تم إنشاء الأيقونة في: {icon_path}")
    print("📱 يمكنك الآن تشغيل: flutter pub run flutter_launcher_icons:main")

if __name__ == "__main__":
    try:
        create_default_icon()
    except ImportError:
        print("❌ يرجى تثبيت Pillow: pip install Pillow")
    except Exception as e:
        print(f"❌ خطأ: {e}") 