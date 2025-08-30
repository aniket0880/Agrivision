plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase Google Services plugin
}

android {
    namespace = "com.example.agricplant.agriplant"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.agricplant.agriplant" // Must match Firebase console package name
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ helps if you use many Firebase libs
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BOM keeps all versions in sync
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // ✅ Add core Firebase libs you use
    implementation("com.google.firebase:firebase-analytics")
    // example: implementation("com.google.firebase:firebase-auth")
    // example: implementation("com.google.firebase:firebase-firestore")

    // Flutter plugins will auto-inject matching native deps, but including BOM here ensures version sync
}
