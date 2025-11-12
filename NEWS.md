# nomisdata 0.1.0
  
### Overview
  
First public release of `nomisdata`, providing modern programmatic access to the UK Nomis labour market database. This release establishes a production-grade foundation for accessing ONS labour market statistics through R.

### Core Functionality

#### Data Retrieval

* `fetch_nomis()`: Primary data download function with automatic pagination for datasets exceeding API row limits (25,000 guest / 100,000 registered users)
* `search_datasets()`: Full-text search across Nomis catalogue by name, keywords, and description
* `describe_dataset()`: Retrieve comprehensive dataset structure and metadata
* `dataset_overview()`: Get detailed overview with selectable information sections
* `get_codes()`: Extract dimension codes and hierarchies for query construction
* `fetch_codelist()`: Download complete code lists for dataset dimensions
* `lookup_geography()`: Geography code resolution with fuzzy name matching

#### Spatial Integration

* `fetch_spatial()`: Download data with KML boundaries for spatial analysis
* Native `sf` package integration for seamless GIS workflows
* `add_geography_names()`: Automatic geography name joins
* Support for all standard UK geography levels (countries, regions, local authorities, wards, LSOAs, MSOAs)

#### Data Processing

* `aggregate_geography()`: Hierarchical geographic aggregation
* `aggregate_time()`: Temporal aggregation with flexible period selection
* `tidy_names()`: Column name standardization with multiple style options

#### Authentication & Configuration

* `set_api_key()`: Secure API key management with `.Renviron` persistence
* Automatic key detection from environment variables
* Clear upgrade path from guest (25K limit) to registered (100K limit) access

#### User Experience

* `browse_dataset()`: Open dataset pages in web browser for visual exploration
* `explore_dataset()`: Interactive console-based dataset explorer
* `enable_cache()` / `clear_cache()`: Intelligent cache management for reproducible workflows
* Progress reporting for long-running multi-part queries
* Informative error messages with actionable suggestions

### Infrastructure

#### HTTP Client

* Modern `httr2`-based client with exponential backoff retry logic
* Automatic handling of transient failures (429, 503, 504 status codes)
* Configurable retry attempts (default: 3) with exponential backoff
* Comprehensive error handling with structured error classes

#### Caching System

* Metadata caching via `memoise` for instant repeated queries
* Optional disk-based cache for large data downloads
* Cache validation with age checking (default: 30 days)
* Cryptographic hash-based cache keys for query uniqueness

#### Type Safety

* Comprehensive parameter validation with early failure detection
* Type checking for all function arguments
* Informative error messages using `cli` and `rlang`
* Graceful handling of missing optional dependencies

### Testing & Quality Assurance

* **135+ comprehensive tests** covering all package functionality
* `vcr` package integration for offline test fixtures
* 80%+ code coverage across all modules
* Continuous integration via GitHub Actions (macOS, Windows, Linux)
* CRAN-compliant examples with appropriate `\donttest{}` wrappers

### Documentation

#### Package Documentation

* Complete function documentation with roxygen2
* 5 comprehensive vignettes:
  - Getting Started
- Geography Guide
- Advanced Queries
- Spatial Analysis
- Visualisation Examples
* Publication-quality example Visualisations (12 figures)
* Sample dataset (`jsa_sample`) for offline examples

#### Visualisation Gallery

Complete reproduction code for 12 publication-quality figures:
  
  1. **National Overview**: Current unemployment by UK constituent nations
2. **Lorenz Curve**: Geographic concentration of unemployment
3. **Distribution Analysis**: Unemployment by urban hierarchy
4. **High Unemployment Areas**: Top 20 local authorities
5. **Gender Disparities**: Male vs female unemployment gaps
6. **London Inequality**: Within-city variation across 33 boroughs
7. **Temporal Dynamics**: Year-on-year changes by nation
8. **Performance Analysis**: Best and worst performing local authorities
9. **Multi-Dimensional Dashboard**: Integrated 4-panel overview
10. **Labour Market Tightness**: Employment-unemployment relationships
11. **Regional Inequality**: Level vs within-region variation
12. **Scale-Growth Dynamics**: Non-linear unemployment dynamics

All Visualisations use transparent backgrounds for GitHub dark theme compatibility and include comprehensive methodological notes.

### Technical Specifications

#### Performance

* Guest users: 25,000 rows per query
* Registered users: 100,000 rows per query
* Automatic query chunking for larger datasets
* 10-50× speedup for cached queries
* Typical latency: 1-3s (small), 10-30s (large with pagination)

#### Dependencies

**Imports** (core functionality):
  * cli (>= 3.6.0), dplyr (>= 1.1.0), httr2 (>= 1.0.0)
* jsonlite (>= 1.8.0), rlang (>= 1.1.0), tibble (>= 3.2.0)
* utils, digest, methods

**Suggests** (enhanced features):
  * Spatial: sf (>= 1.0.0), rsdmx (>= 0.6.0)
* Visualisation: ggplot2 (>= 3.4.0), scales (>= 1.2.0)
* Caching: cachem (>= 1.0.0), memoise (>= 2.0.0), rappdirs (>= 0.3.0)
* Testing: testthat (>= 3.1.0), vcr (>= 1.2.0), withr (>= 2.5.0)
* Documentation: knitr (>= 1.42), rmarkdown (>= 2.20)
* Utilities: janitor (>= 2.2.0), readr (>= 2.1.0)

### Breaking Changes

None (initial release)

### Known Issues

None

### Deprecations

None (initial release)

### Future Development

Planned for future releases:
  
* Additional dataset-specific helper functions
* Enhanced geography hierarchy traversal
* Time series analysis utilities
* Parallel query execution for very large downloads
* Interactive Shiny dashboard for data exploration
* Integration with additional UK official statistics sources

### Acknowledgments

* Office for National Statistics for maintaining the Nomis database
* Durham University for hosting the Nomis service

### Citation

If using `nomisdata` in published research:
  
  ```bibtex
@Manual{nomisdata2024,
  title = {nomisdata: Access Nomis UK Labour Market Data and Statistics},
  author = {Cheryl Isabella Lim},
  year = {2024},
  note = {R package version 0.1.0},
  url = {https://github.com/cherylisabella/nomisdata},
}
```

### License

MIT © 2025 Cheryl Isabella Lim

---
  
  For detailed usage instructions, see the package vignettes:
  ```r
browseVignettes("nomisdata")
```

For bug reports and feature requests:
  https://github.com/cherylisabella/nomisdata/issues
