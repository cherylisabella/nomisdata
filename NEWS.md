# nomisdata 0.1.2

* Expanded test suite coverage without API access
* Added mocked tests for `lookup_geography()`, `search_datasets()`, `describe_dataset()`, `dataset_overview()`, and cache functions
* Consolidated duplicate cache test files
* Fixed cache directory handling during R CMD check

# nomisdata 0.1.1
* Added test suite coverage without API access

# nomisdata 0.1.0

* Initial CRAN release
* `fetch_nomis()`: download data with automatic pagination
* `search_datasets()`, `describe_dataset()`, `dataset_overview()`: dataset discovery
* `get_codes()`, `fetch_codelist()`, `lookup_geography()`: dimension and geography lookup
* `fetch_spatial()`, `add_geography_names()`: spatial data integration
* `aggregate_geography()`, `aggregate_time()`, `tidy_names()`: data processing
* `set_api_key()`: API key management with `.Renviron` persistence
* `enable_cache()`, `clear_cache()`: disk-based response caching
* `browse_dataset()`, `explore_dataset()`: interactive helpers
* httr2-based client with retry logic and structured error handling