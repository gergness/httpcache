
## Create the cache env
cache <- NULL
initCache <- function () {
    cache <<- new.env(hash=TRUE)
}
cache_identifier_key <- '__CACHE_IDENTIFIER_FUNCTION__'
#' @export
registerCache <- function(fn){
    stopifnot(
        'fn must be a function' = is.function(fn)
    )
    assign(cache_identifier_key, fn, envir=cache)
}
identifyCache <- function(){
    idfun <- get(cache_identifier_key, envir = cache)
    idfun()
}
initCache()
registerCache(function() cache)

#' Save and load cache state
#'
#' Warm your query cache from a previous session by saving out the cache and
#' loading it back in.
#' @param file character file path to write the cache data to, in `.rds` format
#' @return Nothing; called for side effects.
#' @export
saveCache <- function (file) {
    saveRDS(identifyCache(), file=file)
}

#' @rdname saveCache
#' @export
loadCache <- function (file) {
    env <- readRDS(file)
    if (!is.environment(env)) {
        halt("'loadCache' requires an .rds file containing an environment")
    }
    ## Copy the values over
    for (key in ls(all.names=TRUE, envir=env)) {
        setCache(key, get(key, env))
    }
    invisible(NULL)
}
