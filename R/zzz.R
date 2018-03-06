datacache <- new.env(hash=TRUE, parent=emptyenv())

org.Mabscessus.eg <- function() showQCData("org.Mabscessus.eg", datacache)
org.Mabscessus.eg_dbconn <- function() dbconn(datacache)
org.Mabscessus.eg_dbfile <- function() dbfile(datacache)
org.Mabscessus.eg_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
org.Mabscessus.eg_dbInfo <- function() dbInfo(datacache)

org.Mabscessus.egORGANISM <- "Mycobacterium abscessus"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "org.Mabscessus.eg.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"OrgDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("org.Mabscessus.eg.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(org.Mabscessus.eg_dbconn())
}

