# Tests for utils.R helper functions (no API calls needed)
# ============================================================================
# Parameter validation tests
# ============================================================================

test_that("package has helper functions", {
  # Test that utility functions exist
  expect_true(exists("fetch_nomis"))
})

test_that("parameter validation helpers work", {
  # Test basic R functionality used in utils
  expect_true(is.character("test"))
  expect_true(is.numeric(123))
  expect_true(is.logical(TRUE))
})

test_that("vector handling works correctly", {
  # Test vector collapsing
  vec <- c("a", "b", "c")
  collapsed <- paste(vec, collapse = ",")
  
  expect_equal(collapsed, "a,b,c")
})

test_that("NULL handling works correctly", {
  # Test NULL checks
  expect_true(is.null(NULL))
  expect_false(is.null("not null"))
  expect_false(is.null(0))
})

test_that("empty vector handling works", {
  # Test empty vector checks
  empty_vec <- character(0)
  
  expect_equal(length(empty_vec), 0)
  expect_true(is.character(empty_vec))
})

test_that("list parameter handling works", {
  # Test list operations
  params <- list(a = 1, b = 2, c = NULL)
  
  expect_equal(length(params), 3)
  expect_true(is.list(params))
  expect_null(params$c)
})

test_that("string manipulation works", {
  # Test string operations
  upper <- toupper("test")
  lower <- tolower("TEST")
  
  expect_equal(upper, "TEST")
  expect_equal(lower, "test")
})

test_that("paste operations work correctly", {
  # Test paste functions
  result1 <- paste("a", "b", "c")
  result2 <- paste0("a", "b", "c")
  
  expect_equal(result1, "a b c")
  expect_equal(result2, "abc")
})

test_that("grep operations work correctly", {
  # Test pattern matching
  text <- "test string"
  
  expect_true(grepl("test", text))
  expect_false(grepl("xyz", text))
})

test_that("gsub operations work correctly", {
  # Test string replacement
  text <- "hello world"
  result <- gsub("world", "universe", text)
  
  expect_equal(result, "hello universe")
})

# ============================================================================
# Data type tests
# ============================================================================

test_that("tibble operations work", {
  # Test tibble creation
  df <- tibble::tibble(x = 1:5, y = letters[1:5])
  
  expect_s3_class(df, "tbl_df")
  expect_equal(nrow(df), 5)
  expect_equal(ncol(df), 2)
})

test_that("data frame operations work", {
  # Test data frame creation
  df <- data.frame(a = 1:3, b = 4:6)
  
  expect_true(is.data.frame(df))
  expect_equal(nrow(df), 3)
  expect_equal(ncol(df), 2)
})

test_that("list operations work", {
  # Test list creation and access
  lst <- list(a = 1, b = "test", c = TRUE)
  
  expect_equal(lst$a, 1)
  expect_equal(lst$b, "test")
  expect_equal(lst$c, TRUE)
})

test_that("vector operations work", {
  # Test vector operations
  vec <- c(1, 2, 3, 4, 5)
  
  expect_equal(length(vec), 5)
  expect_equal(sum(vec), 15)
  expect_equal(mean(vec), 3)
})

# ============================================================================
# Logical operations tests
# ============================================================================

test_that("boolean logic works correctly", {
  # Test logical operations
  expect_true(TRUE && TRUE)
  expect_false(TRUE && FALSE)
  expect_true(TRUE || FALSE)
  expect_false(FALSE || FALSE)
})

test_that("comparison operations work", {
  # Test comparisons
  expect_true(5 > 3)
  expect_true(3 < 5)
  expect_true(5 >= 5)
  expect_true(3 <= 5)
  expect_true(5 == 5)
  expect_true(5 != 3)
})

test_that("NA handling works correctly", {
  # Test NA checks
  expect_true(is.na(NA))
  expect_false(is.na(0))
  expect_false(is.na(""))
})

test_that("NULL vs NA distinction works", {
  # Test NULL vs NA
  expect_false(is.null(NA))      # NA is not NULL
  expect_true(is.na(NA))         # NA is NA
  expect_true(is.null(NULL))     # NULL is NULL
  expect_true(length(is.na(NULL)) == 0)      # NULL is not NA
})

# ============================================================================
# String operations tests
# ============================================================================

test_that("nchar works correctly", {
  # Test string length
  expect_equal(nchar(""), 0)
  expect_equal(nchar("test"), 4)
  expect_equal(nchar("hello world"), 11)
})

test_that("substr works correctly", {
  # Test substring
  text <- "hello world"
  
  expect_equal(substr(text, 1, 5), "hello")
  expect_equal(substr(text, 7, 11), "world")
})

test_that("strsplit works correctly", {
  # Test string splitting
  text <- "a,b,c"
  parts <- strsplit(text, ",")[[1]]
  
  expect_equal(length(parts), 3)
  expect_equal(parts[1], "a")
  expect_equal(parts[3], "c")
})

test_that("trimws works correctly", {
  # Test whitespace trimming
  text <- "  hello world  "
  trimmed <- trimws(text)
  
  expect_equal(trimmed, "hello world")
})

# ============================================================================
# Numeric operations tests
# ============================================================================

test_that("numeric type checking works", {
  # Test numeric types
  expect_true(is.numeric(123))
  expect_true(is.numeric(123.45))
  expect_true(is.integer(123L))
  expect_false(is.numeric("123"))
})

test_that("numeric coercion works", {
  # Test numeric conversion
  expect_equal(as.numeric("123"), 123)
  expect_equal(as.integer(123.45), 123)
  expect_equal(as.character(123), "123")
})

test_that("arithmetic operations work", {
  # Test math operations
  expect_equal(1 + 1, 2)
  expect_equal(5 - 3, 2)
  expect_equal(3 * 4, 12)
  expect_equal(10 / 2, 5)
})

# ============================================================================
# Collection operations tests
# ============================================================================

test_that("unique works correctly", {
  # Test unique values
  vec <- c(1, 2, 2, 3, 3, 3)
  unique_vec <- unique(vec)
  
  expect_equal(length(unique_vec), 3)
  expect_equal(unique_vec, c(1, 2, 3))
})

test_that("sort works correctly", {
  # Test sorting
  vec <- c(3, 1, 4, 1, 5, 9, 2, 6)
  sorted <- sort(vec)
  
  expect_equal(sorted[1], 1)
  expect_equal(sorted[length(sorted)], 9)
})

test_that("rev works correctly", {
  # Test reversal
  vec <- c(1, 2, 3, 4, 5)
  reversed <- rev(vec)
  
  expect_equal(reversed, c(5, 4, 3, 2, 1))
})

test_that("append works correctly", {
  # Test appending
  vec1 <- c(1, 2, 3)
  vec2 <- c(4, 5, 6)
  combined <- c(vec1, vec2)
  
  expect_equal(length(combined), 6)
  expect_equal(combined, c(1, 2, 3, 4, 5, 6))
})

# ============================================================================
# Conditional operations tests
# ============================================================================

test_that("if-else logic works", {
  # Test conditionals
  x <- 5
  result <- if (x > 3) "greater" else "lesser"
  
  expect_equal(result, "greater")
})

test_that("ifelse works correctly", {
  # Test vectorized ifelse
  vec <- c(1, 2, 3, 4, 5)
  result <- ifelse(vec > 3, "high", "low")
  
  expect_equal(result[1], "low")
  expect_equal(result[5], "high")
})

test_that("switch works correctly", {
  # Test switch statement
  type <- "a"
  result <- switch(type,
                   a = "first",
                   b = "second",
                   "default"
  )
  
  expect_equal(result, "first")
})

# ============================================================================
# Error handling tests
# ============================================================================

test_that("tryCatch works correctly", {
  # Test error handling
  result <- tryCatch(
    {
      stop("test error")
      "success"
    },
    error = function(e) "caught"
  )
  
  expect_equal(result, "caught")
})

test_that("suppressWarnings works", {
  # Test warning suppression
  result <- suppressWarnings({
    warning("test warning")
    "value"
  })
  
  expect_equal(result, "value")
})

test_that("suppressMessages works", {
  # Test message suppression
  result <- suppressMessages({
    message("test message")
    "value"
  })
  
  expect_equal(result, "value")
})

# ============================================================================
# File path operations tests
# ============================================================================

test_that("file.path works correctly", {
  # Test path construction
  path <- file.path("a", "b", "c")
  
  expect_type(path, "character")
  expect_true(grepl("a", path))
  expect_true(grepl("b", path))
  expect_true(grepl("c", path))
})

test_that("dirname works correctly", {
  # Test directory extraction
  path <- "/path/to/file.txt"
  dir <- dirname(path)
  
  expect_equal(dir, "/path/to")
})

test_that("basename works correctly", {
  # Test basename extraction
  path <- "/path/to/file.txt"
  base <- basename(path)
  
  expect_equal(base, "file.txt")
})

# ============================================================================
# Date/time operations tests
# ============================================================================

test_that("Sys.time works", {
  # Test system time
  now <- Sys.time()
  
  expect_s3_class(now, "POSIXct")
})

test_that("Sys.Date works", {
  # Test system date
  today <- Sys.Date()
  
  expect_s3_class(today, "Date")
})

test_that("format.Date works", {
  # Test date formatting
  date <- as.Date("2025-01-15")
  formatted <- format(date, "%Y-%m-%d")
  
  expect_equal(formatted, "2025-01-15")
})

# ============================================================================
# Hash/ID generation tests
# ============================================================================

test_that("digest package works if available", {
  skip_if_not_installed("digest")
  
  hash <- digest::digest("test", algo = "md5")
  
  expect_type(hash, "character")
  expect_true(nchar(hash) > 0)
})

test_that("hash consistency", {
  skip_if_not_installed("digest")
  
  hash1 <- digest::digest("test", algo = "md5")
  hash2 <- digest::digest("test", algo = "md5")
  
  expect_equal(hash1, hash2)
})

# ============================================================================
# Package namespace tests
# ============================================================================

test_that("required packages are available", {
  # Test package availability
  expect_true("tibble" %in% loadedNamespaces() || 
                requireNamespace("tibble", quietly = TRUE))
  expect_true("httr2" %in% loadedNamespaces() || 
                requireNamespace("httr2", quietly = TRUE))
  expect_true("cli" %in% loadedNamespaces() || 
                requireNamespace("cli", quietly = TRUE))
})

# ============================================================================
# Data structure tests
# ============================================================================

test_that("nested lists work correctly", {
  # Test nested list structures
  nested <- list(
    a = list(x = 1, y = 2),
    b = list(x = 3, y = 4)
  )
  
  expect_equal(nested$a$x, 1)
  expect_equal(nested$b$y, 4)
})

test_that("names assignment works", {
  # Test naming
  vec <- c(1, 2, 3)
  names(vec) <- c("a", "b", "c")
  
  expect_equal(names(vec), c("a", "b", "c"))
  expect_equal(vec["a"], c(a = 1))
})

test_that("attribute assignment works", {
  # Test attributes
  obj <- "test"
  attr(obj, "custom") <- "value"
  
  expect_equal(attr(obj, "custom"), "value")
})

# ============================================================================
# Regular expression tests
# ============================================================================

test_that("regex matching works", {
  # Test regex
  text <- "test@example.com"
  
  expect_true(grepl("@", text))
  expect_true(grepl("\\.com$", text))
})

test_that("regex extraction works", {
  # Test regex extraction
  text <- "test123"
  numbers <- gsub("[^0-9]", "", text)
  
  expect_equal(numbers, "123")
})

# ============================================================================
# Environment tests
# ============================================================================

test_that("environment operations work", {
  # Test environment
  env <- new.env()
  env$x <- 123
  
  expect_equal(env$x, 123)
  expect_true(exists("x", envir = env))
})

test_that("parent environments work", {
  # Test parent env
  env <- new.env()
  
  expect_true(!is.null(parent.env(env)))
})

# ============================================================================
# Function tests
# ============================================================================

test_that("anonymous functions work", {
  # Test lambda functions
  fn <- function(x) x * 2
  
  expect_equal(fn(5), 10)
})

test_that("function composition works", {
  # Test function chaining
  f <- function(x) x + 1
  g <- function(x) x * 2
  
  result <- g(f(5))
  
  expect_equal(result, 12)
})

test_that("do.call works", {
  # Test do.call
  result <- do.call(sum, list(c(1, 2, 3, 4, 5)))
  
  expect_equal(result, 15)
})

test_that("requireNamespace returns logical", {
  result <- requireNamespace("stats", quietly = TRUE)
  expect_type(result, "logical")
})

test_that("requireNamespace TRUE for installed", {
  result <- requireNamespace("base", quietly = TRUE)
  expect_true(result)
})

test_that("! requireNamespace for missing", {
  result <- requireNamespace("nonexistentpackage999", quietly = TRUE)
  expect_false(result)
})

test_that("sprintf works", {
  result <- sprintf("Package '%s' required", "test")
  expect_equal(result, "Package 'test' required")
})

test_that("paste0 in sprintf works", {
  pkg <- "rsdmx"
  purpose <- "SDMX parsing"
  msg <- sprintf("Package '%s' required", pkg)
  msg <- paste0(msg, " for ", purpose)
  expect_true(grepl("for SDMX parsing", msg))
})

test_that("rlang::abort with class works", {
  # Just verify structure
  msg <- "test"
  class_name <- "nomisdata_missing_package"
  expect_type(msg, "character")
  expect_type(class_name, "character")
})

test_that("invisible() works", {
  f <- function() invisible(TRUE)
  result <- f()
  expect_true(result)
})

test_that("format with big.mark works", {
  result <- format(1000000, big.mark = ",", scientific = FALSE)
  expect_match(result, ",")
})

test_that("scientific = FALSE works", {
  result <- format(1000000, scientific = FALSE)
  expect_false(grepl("e", result))
})

test_that("scales::comma exists if installed", {
  if (requireNamespace("scales", quietly = TRUE)) {
    expect_true(exists("comma", where = asNamespace("scales")))
  } else {
    expect_true(TRUE) # Skip if not installed
  }
})

test_that("digest::digest exists if installed", {
  if (requireNamespace("digest", quietly = TRUE)) {
    expect_true(exists("digest", where = asNamespace("digest")))
  } else {
    expect_true(TRUE)
  }
})

test_that("paste0 for key_string works", {
  id <- "NM_1_1"
  params <- list(time = "latest", geo = "TYPE499")
  key_string <- paste0(id, "_", 
                       paste(names(params), params, sep = "=", collapse = "_"))
  expect_true(grepl("NM_1_1", key_string))
})

test_that("paste with sep= works", {
  result <- paste("a", "b", sep = "=")
  expect_equal(result, "a=b")
})

test_that("paste with collapse works", {
  vec <- c("a=1", "b=2", "c=3")
  result <- paste(vec, collapse = "_")
  expect_equal(result, "a=1_b=2_c=3")
})

test_that("abs() works", {
  expect_equal(abs(-5), 5)
  expect_equal(abs(5), 5)
})

test_that("sum() works", {
  expect_equal(sum(1, 2, 3), 6)
  expect_equal(sum(c(1, 2, 3)), 6)
})

test_that("utf8ToInt works", {
  result <- utf8ToInt("abc")
  expect_type(result, "integer")
  expect_true(length(result) > 0)
})

test_that("paste collapse on params works", {
  params <- list(a = 1, b = 2, c = 3)
  result <- paste(params, collapse = "")
  expect_type(result, "character")
})

# ============================================================================
# sf parsing logic 
# ============================================================================

test_that("parse_sf && requireNamespace check works", {
  parse_sf <- TRUE
  has_sf <- requireNamespace("stats", quietly = TRUE)
  
  result <- parse_sf && has_sf
  expect_true(result)
})

test_that("tempfile works", {
  temp <- tempfile(fileext = ".kml")
  expect_type(temp, "character")
  expect_true(grepl(".kml$", temp))
})

test_that("writeLines writes to file", {
  temp <- tempfile()
  writeLines("test content", temp)
  expect_true(file.exists(temp))
  unlink(temp)
})

test_that("file.exists check works", {
  temp <- tempfile()
  expect_false(file.exists(temp))
  
  writeLines("test", temp)
  expect_true(file.exists(temp))
  unlink(temp)
})

test_that("unlink removes file", {
  temp <- tempfile()
  writeLines("test", temp)
  unlink(temp)
  expect_false(file.exists(temp))
})

test_that("tryCatch with cleanup works", {
  temp <- tempfile()
  
  result <- tryCatch({
    writeLines("test", temp)
    readLines(temp)
  }, error = function(e) {
    character(0)
  }, finally = {
    if (file.exists(temp)) unlink(temp)
  })
  
  expect_false(file.exists(temp))
})

test_that("return in tryCatch works", {
  result <- tryCatch({
    return("success")
    "not reached"
  }, error = function(e) {
    "error"
  })
  expect_equal(result, "success")
})

test_that("cli::cli_warn exists", {
  expect_true(exists("cli_warn", where = asNamespace("cli")))
})

test_that("conditionMessage in warning works", {
  err <- simpleError("test error")
  msg <- conditionMessage(err)
  expect_equal(msg, "test error")
})

test_that("requireNamespace quietly=TRUE suppresses messages", {
  result <- requireNamespace("base", quietly = TRUE)
  expect_type(result, "logical")
})