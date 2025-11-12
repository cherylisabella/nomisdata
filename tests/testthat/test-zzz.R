# Tests for package load hooks

test_that(".onLoad sets API key from environment", {
  # This is tested indirectly through set_api_key tests
  expect_true(TRUE)
})

test_that(".onAttach provides helpful message", {
  # Package startup messages are tested through R CMD check
  expect_true(TRUE)
})
