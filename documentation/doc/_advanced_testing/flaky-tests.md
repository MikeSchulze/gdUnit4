---
layout: default
title: Flaky Tests
parent: Advanced Testing
nav_order: 11
---

# Flaky Tests

## Definition

Flaky tests are tests that may pass or fail inconsistently, even when run against the same code. This can happen due to various reasons such as timing issues,
race conditions, or external dependencies that can cause unexpected behaviors during test execution.

### How to handle flaky tests in GdUnit4

GdUnit4 provides built-in support for handling flaky tests to help improve the reliability of your test suite.
This feature allows tests that fail intermittently to be re-executed automatically, reducing the chance of reporting false negatives.

### Flaky Test Settings

![settings]({{site.baseurl}}/assets/images/settings/flaky-test-settings.png){:.centered}

* **Flaky Test**
    The Flaky Test setting allows you to enable or disable the detection and handling of flaky tests.
    When enabled, GdUnit4 will automatically retry tests that fail,
    helping to distinguish between actual test failures and sporadic issues caused by flaky tests.

    **Enabled:**
        GdUnit4 will monitor test failures and automatically rerun tests that fail to determine if they are truly faulty or just flaky.<br>
    **Disabled:**
        No additional handling for flaky tests. All test failures will be reported immediately.

* **Flaky Max Retries**
    The Flaky Max Retries setting determines the number of times a flaky test should be retried before it is considered a failure.
    This helps to confirm whether a test is truly failing or just encountering a temporary issue.

    **Default Value:** 3 retries<br>
    **Range:** Any positive integer

### Best Practices for Handling Flaky Tests

* **Identify the Cause:**
    Before relying on flaky test handling, try to identify and fix the underlying cause of flaky behavior.
    Common causes include race conditions, external dependencies, or timing issues.
* **Use Retries Sparingly:**
    While flaky test retries can help reduce noise in your test reports, excessive retries can mask legitimate issues. Use them judiciously.
* **Monitor Test Stability:**
    Keep track of test stability over time. If a test consistently fails even with retries, it may need to be rewritten or reviewed.

### Conclusion

Handling flaky tests effectively can significantly improve the stability and reliability of your test suite.
By using GdUnit4’s built-in settings for flaky tests, you can automatically manage intermittent test failures and focus on addressing real issues in your codebase.
