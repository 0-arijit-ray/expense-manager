# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# flutter_local_notifications (uses Gson + reflection)
-keep class com.dexterous.** { *; }
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep generic type info used by Gson TypeToken
-keep class * extends com.google.gson.reflect.TypeToken

# sqlite3 / drift native bindings
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**
