.onLoad <- function(libname, pkgname) {
  .jinit()
  # Check that Java version is at least 8
  jv <- .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
  if(substr(jv, 1L, 2L) == "1.") {
    jvn <- as.numeric(paste0(strsplit(jv, "[.]")[[1L]][1:2], collapse = "."))
    if(jvn < 1.8) stop("Java >= 8 is needed for this package but not available")
  }
  # Download flsgen jar if not already downloaded
  jar_path <- file.path(libname, pkgname, "java", "flsgen-core-1.2.0.jar")
  if (!file.exists(jar_path)) {
    old_options <- options(timeout = max(1000, getOption("timeout")))
    on.exit(options(old_options))
    utils::download.file("https://github.com/dimitri-justeau/flsgen/releases/download/v1.2.0/flsgen-core-1.2.0.jar", destfile = jar_path)
  }
  .jpackage(pkgname, lib.loc = libname)
  J("java.lang.System")$setProperty("EPSG-HSQL.directory", tempdir())
}
