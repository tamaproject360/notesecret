allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        val androidExtension = project.extensions.findByName("android")
        if (androidExtension != null) {
            try {
                // Access 'android' extension dynamically to avoid classpath issues
                val getNamespace = androidExtension.javaClass.getMethod("getNamespace")
                val setNamespace = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                
                val currentNamespace = getNamespace.invoke(androidExtension) as String?
                
                // For isar_flutter_libs, use its original package name
                if (project.name == "isar_flutter_libs" && currentNamespace == null) {
                    setNamespace.invoke(androidExtension, "dev.isar.isar_flutter_libs")
                    println("Auto-assigned namespace for ${project.name}: dev.isar.isar_flutter_libs")
                } else if (currentNamespace == null) {
                    val packageName = "com.tamadev.notesecret.${project.name.replace("-", "_")}"
                    setNamespace.invoke(androidExtension, packageName)
                    println("Auto-assigned namespace: $packageName")
                }
            } catch (e: Exception) {
                // Ignore reflection errors or if methods don't exist
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
