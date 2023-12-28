enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")
@Suppress("DSL_SCOPE_VIOLATION")

pluginManagement {
    repositories {
        google()
        mavenCentral()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "dogApi"
include(":common")
include(":app")
// load all features module
file("./feature/").listFiles()?.forEach { sub -> include(":feature:" + sub.name) }