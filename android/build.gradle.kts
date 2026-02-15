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
    project.evaluationDependsOn(":app")

    // FIX: Assign namespace to libraries that don't have one (required for AGP 8+)
    afterEvaluate {
        val androidExtension = project.extensions.findByName("android")
        if (androidExtension != null) {
            try {
                // Access 'android' extension dynamically to avoid classpath issues
                val getNamespace = androidExtension.javaClass.getMethod("getNamespace")
                val setNamespace = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                
                if (getNamespace.invoke(androidExtension) == null) {
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
