# Contributing to nomisdata

Thank you for your interest in contributing to `nomisdata`! This document provides comprehensive guidelines for contributing to the package.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing Requirements](#testing-requirements)
- [Documentation Standards](#documentation-standards)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)
- [Getting Help](#getting-help)

## Code of Conduct

### Our Pledge

Maintainers are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, gender identity, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, religion, or nationality.

### Our Standards

**Positive behaviors include:**
* Using welcoming and inclusive language
* Respecting differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what benefits the community
* Showing empathy toward others

**Unacceptable behaviors include:**
* Trolling, insulting comments, or personal attacks
* Public or private harassment
* Publishing others' private information without permission
* Other conduct reasonably considered inappropriate

### Enforcement

Instances of unacceptable behavior may be reported to the maintainer at cheryl.academic@gmail.com. All complaints will be reviewed and investigated confidentially.

## Getting Started

### Prerequisites

**Required Software:**
* R (>= 3.5.0)
* RStudio (recommended but not required)
* Git

**Development Dependencies:**
```r
install.packages(c(
  "devtools",      # Development tools
  "roxygen2",      # Documentation
  "testthat",      # Testing framework
  "pkgdown",       # Website generation
  "covr",          # Code coverage
  "lintr",         # Code linting
  "styler"         # Code formatting
))
```

**Optional Tools:**
* [usethis](https://usethis.r-lib.org/) - Workflow automation
* [goodpractice](https://github.com/MangoTheCat/goodpractice) - Best practices checker

### Initial Setup

1. **Fork the Repository**

   Navigate to https://github.com/cherylisabella/nomisdata and click "Fork"

2. **Clone Your Fork**

   ```bash
   git clone https://github.com/YOUR-USERNAME/nomisdata.git
   cd nomisdata
   ```

3. **Add Upstream Remote**

   ```bash
   git remote add upstream https://github.com/cherylisabella/nomisdata.git
   ```

4. **Install Package Dependencies**

   ```r
   # In R console from package root
   devtools::install_deps(dependencies = TRUE)
   ```

5. **Verify Installation**

   ```r
   devtools::load_all()  # Load package for development
   devtools::test()      # Run tests
   devtools::check()     # Run full check
   ```

### Register for Nomis API Access

For testing features requiring API access:

1. Register at https://www.nomisweb.co.uk/myaccount/userjoin.asp
2. Obtain your API key from your account page
3. Set environment variable:
   ```r
   usethis::edit_r_environ()
   # Add: NOMIS_API_KEY=your_key_here
   ```

## Development Workflow

### Branch Strategy

We use a simplified Git Flow:

* `main`: Stable release branch (protected)
* `develop`: Integration branch for next release
* `feature/*`: New features
* `fix/*`: Bug fixes
* `docs/*`: Documentation updates
* `test/*`: Test improvements

### Creating a Feature Branch

```bash
# Ensure you're up to date
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/descriptive-name

# Examples:
# feature/add-time-aggregation
# fix/geography-lookup-error
# docs/improve-spatial-vignette
```

### Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
* `feat`: New feature
* `fix`: Bug fix
* `docs`: Documentation only
* `style`: Formatting, missing semicolons, etc.
* `refactor`: Code restructuring without behavior change
* `test`: Adding or updating tests
* `chore`: Maintenance tasks

**Examples:**
```bash
feat(download): add parallel query execution

Implement parallel downloading for large multi-geography queries
using future package. Reduces download time by ~60% for queries
with >100 geographic units.

Closes #42

fix(geography): handle special characters in lookup

Geography lookup was failing for areas with apostrophes or
hyphens. Now properly escapes special regex characters.

Fixes #38

docs(vignette): add spatial analysis examples

Expanded spatial-analysis vignette with choropleth mapping
examples and integration with sf workflows.
```

### Development Cycle

1. **Write Code**
   ```r
   # Edit files in R/
   usethis::use_r("my_function")
   ```

2. **Document**
   ```r
   # Add roxygen2 comments
   devtools::document()
   ```

3. **Test**
   ```r
   # Write tests in tests/testthat/
   usethis::use_test("my_function")
   devtools::test()
   ```

4. **Check**
   ```r
   devtools::check()
   ```

5. **Commit**
   ```bash
   git add .
   git commit -m "feat: add my new feature"
   ```

6. **Push**
   ```bash
   git push origin feature/my-feature
   ```

## Code Standards

### Style Guide

Please follow the [tidyverse style guide](https://style.tidyverse.org/), especially:

#### Naming Conventions

```r
# Functions: snake_case
fetch_nomis <- function() {}

# Variables: snake_case
unemployment_data <- tibble()

# Constants: SCREAMING_SNAKE_CASE
API_BASE_URL <- "https://..."

# Private functions: prefix with dot (but prefer keywords internal)
.validate_params <- function() {}  # Better: use @keywords internal
```

#### Spacing and Indentation

```r
# Good
x <- 5
if (x > 0) {
  print("positive")
}

# Bad
x<-5
if(x>0){
print("positive")
}

# Function calls
result <- fetch_nomis(
  id = "NM_1_1",
  time = "latest",
  geography = "TYPE480"
)
```

#### Line Length

* Maximum 80 characters per line
* Break long function calls across multiple lines

```r
# Good
long_result <- very_long_function_name(
  first_parameter = "value",
  second_parameter = "another_value",
  third_parameter = "yet_another_value")

# Bad
long_result <- very_long_function_name(first_parameter = "value", second_parameter = "another_value", third_parameter = "yet_another_value")
```

### Automated Formatting

```r
# Format entire package
styler::style_pkg()

# Format single file
styler::style_file("R/my_function.R")

# Check style (don't auto-fix)
lintr::lint_package()
```

### Function Design Principles

#### 1. Single Responsibility

Each function should do one thing well:

```r
# Good
fetch_data <- function(id) { ... }
validate_id <- function(id) { ... }
parse_response <- function(response) { ... }

# Bad (doing too much)
fetch_and_validate_and_parse <- function(id) { ... }
```

#### 2. Clear Parameter Names

```r
# Good
fetch_nomis(id = "NM_1_1", time = "latest")

# Bad
fetch_nomis(x = "NM_1_1", t = "latest")
```

#### 3. Early Input Validation

```r
my_function <- function(id, value) {
  # Validate immediately
  if (missing(id) || !is.character(id)) {
    rlang::abort("`id` must be a character string")
  }
  
  if (!is.numeric(value) || value < 0) {
    rlang::abort("`value` must be a non-negative number")
  }
  
  # Then proceed with logic
  # ...
}
```

#### 4. Consistent Return Types

```r
# Good - always returns tibble
get_data <- function() {
  if (no_data) {
    return(tibble::tibble())  # Empty tibble
  }
  tibble::as_tibble(result)
}

# Bad - inconsistent returns
get_data <- function() {
  if (no_data) {
    return(NULL)  # Different type!
  }
  tibble::as_tibble(result)
}
```

### Error Handling

Use `rlang` for structured errors:

```r
# Good
rlang::abort(
  c(
    "Cannot fetch data",
    "x" = "Invalid dataset ID: {id}",
    "i" = "Use search_datasets() to find valid IDs"
  ),
  class = "nomisdata_invalid_id"
)

# Bad
stop("Error: bad ID")
```

**Error Message Guidelines:**
* Start with what went wrong
* Use `x` for error details
* Use `i` for helpful information
* Use custom error classes for programmatic handling

## Testing Requirements

### Test Coverage

* **Minimum**: 80% code coverage for new code
* **Goal**: 90%+ overall coverage
* Check coverage: `covr::package_coverage()`

### Test Structure

```r
test_that("function does what it should", {
  # Arrange
  input <- create_test_input()
  
  # Act
  result <- my_function(input)
  
  # Assert
  expect_equal(result, expected_output)
  expect_s3_class(result, "tbl_df")
})
```

### Test Categories

#### 1. Unit Tests

Test individual functions in isolation:

```r
test_that("validate_id rejects invalid IDs", {
  expect_error(validate_id(NULL), "must be a character")
  expect_error(validate_id(""), "cannot be empty")
  expect_error(validate_id(123), "must be a character")
})

test_that("validate_id accepts valid IDs", {
  expect_silent(validate_id("NM_1_1"))
  expect_silent(validate_id("nm_1_1"))  # Case insensitive
})
```

#### 2. Integration Tests

Test multiple components together:

```r
test_that("fetch_nomis retrieves and parses data", {
  skip_on_cran()
  skip_if_offline()
  
  vcr::use_cassette("fetch_basic", {
    result <- fetch_nomis(
      "NM_1_1",
      time = "latest",
      geography = "TYPE499"
    )
    
    expect_s3_class(result, "tbl_df")
    expect_true(nrow(result) > 0)
    expect_true("OBS_VALUE" %in% names(result))
  })
})
```

#### 3. Edge Cases

```r
test_that("handles empty responses gracefully", {
  # Test with query that returns no data
  # ...
})

test_that("handles very large datasets", {
  # Test pagination logic
  # ...
})
```

### Using vcr for API Tests

Record API interactions once, replay offline:

```r
# First run: records API response
vcr::use_cassette("my_test", {
  result <- fetch_nomis("NM_1_1", time = "latest")
  expect_true(nrow(result) > 0)
})

# Subsequent runs: use recorded response (no API call)
```

**vcr Best Practices:**
* Use descriptive cassette names
* One cassette per logical test scenario
* Filter sensitive data (API keys) in `tests/testthat/helper-vcr.R`
* Commit cassettes to git

### Test Helpers

```r
# tests/testthat/helper-nomisdata.R

skip_if_no_api <- function() {
  if (Sys.getenv("NOMIS_API_KEY") == "") {
    skip("No API key available")
  }
}

create_sample_data <- function() {
  tibble::tibble(
    GEOGRAPHY_CODE = c("A", "B"),
    OBS_VALUE = c(100, 200)
  )
}
```

## Documentation Standards

### Function Documentation

Every exported function must have:

```r
#' Short Title (One Line)
#'
#' @description Longer description paragraph explaining what the function
#' does and when to use it.
#'
#' @param id Dataset identifier (required). Character string like "NM_1_1".
#' @param time Time period selection. Accepts "latest", "previous", "prevyear",
#'   "first", or specific dates. Defaults to NULL (all periods).
#' @param ... Additional parameters passed to API.
#'
#' @return A tibble containing the requested data with columns:
#' \describe{
#'   \item{GEOGRAPHY_CODE}{Geographic area code}
#'   \item{OBS_VALUE}{Observed value (numeric)}
#'   \item{DATE}{Date of observation}
#' }
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Fetch latest data for UK regions
#' data <- fetch_nomis(
#'   "NM_1_1",
#'   time = "latest",
#'   geography = "TYPE480"
#' )
#' }
#'
#' @seealso [describe_dataset()] for dataset structure
#' @seealso [get_codes()] for available codes
fetch_nomis <- function(id, time = NULL, ...) {
  # Implementation
}
```

### Vignette Guidelines

Vignettes should:
* Have clear learning objectives
* Include working examples
* Use `jsa_sample` data where possible (offline)
* Progress from simple to complex
* Include real-world use cases

```r
# Create new vignette
usethis::use_vignette("my-topic")
```

### README Updates

Update README.md when adding:
* New major features
* Changed APIs
* New dependencies
* Important bug fixes

## Pull Request Process

### Before Submitting

1. **Sync with upstream**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run full checks**
   ```r
   devtools::test()
   devtools::check()
   goodpractice::gp()
   ```

3. **Update documentation**
   ```r
   devtools::document()
   pkgdown::build_site()
   ```

4. **Update NEWS.md**
   ```markdown
   # nomisdata (development version)
   
   * Added new feature X (#PR_NUMBER)
   * Fixed bug in Y (#ISSUE_NUMBER)
   ```

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All existing tests pass
- [ ] Added new tests for changes
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guide
- [ ] Documentation updated
- [ ] NEWS.md updated
- [ ] No new warnings from R CMD check
```

### Review Process

1. Maintainer(s) will review 
2. Address feedback with new commits
3. Once approved, maintainer(s) will merge
4. Delete your feature branch after merge

## Release Process

(For maintainers)

1. **Prepare release**
   ```r
   usethis::use_version("minor")  # or "patch", "major"
   ```

2. **Update NEWS.md**
   - Move development changes to new version section
   - Add release date

3. **Final checks**
   ```r
   devtools::check()
   rhub::check_for_cran()
   devtools::check_win_devel()
   ```

4. **Build and submit**
   ```r
   devtools::build()
   devtools::release()
   ```

5. **Post-release**
   - Create GitHub release
   - Increment to development version

## Getting Help

### Questions

* **General questions**: [GitHub Discussions](https://github.com/cherylisabella/nomisdata/discussions)
* **Bug reports**: [GitHub Issues](https://github.com/cherylisabella/nomisdata/issues)
* **Security issues**: Email cheryl.academic@gmail.com directly

### Resources

* [R Packages book](https://r-pkgs.org/)
* [tidyverse style guide](https://style.tidyverse.org/)
* [Writing R Extensions](https://cran.r-project.org/doc/manuals/R-exts.html)
* [Nomis API documentation](https://www.nomisweb.co.uk/api/v01/help)

Thank you for contributing to `nomisdata`!

---

**Maintained by**: Cheryl Isabella Lim  
**License**: MIT  