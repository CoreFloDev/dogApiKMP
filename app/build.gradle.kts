plugins {
    alias(libs.plugins.androidApplication)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.ksp)
}

android {
    compileSdk = 34

    defaultConfig {
        applicationId = "io.coreflodev.dog"
        minSdk = 28
        targetSdk = 34
        versionCode = 2
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    signingConfigs {
        create("release") {
            storeFile = file("test.jks")
            storePassword = "testtest"
            keyAlias = "key0"
            keyPassword = "testtest"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs["release"]
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            packaging {
                resources.excludes.add("DebugProbesKt.bin")
            }
        }
    }
    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = libs.versions.compose.compiler.get()
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    namespace = "io.coreflodev.dog"
    file("../feature/").listFiles()?.forEach { sub -> dynamicFeatures += ":feature:" + sub.name }
}

dependencies {
    api(project(":common"))
    coreLibraryDesugaring(libs.desugar.jdk.libs)

    ksp(libs.kotlin.inject.compiler.ksp)
    implementation(libs.kotlin.inject.runtime)

    debugImplementation(libs.leakcanary.android)

    api(libs.ui)
    api(libs.material3)
    api(libs.ui.tooling.preview)
    debugImplementation(libs.ui.tooling)
    api(libs.activity.compose)

    implementation(libs.lifecycle.common.java8)

    implementation(libs.coil)
    implementation(libs.coil.compose)

    debugImplementation(libs.leakcanary.android)

    testImplementation(libs.junit)
    testImplementation(libs.turbine)
    testImplementation(libs.mockk)
    testImplementation(libs.kotlinx.coroutines.test)

    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}