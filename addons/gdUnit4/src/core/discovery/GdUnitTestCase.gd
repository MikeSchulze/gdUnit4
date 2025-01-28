## GdUnitTestCase
## A class representing a single test case in GdUnit4.
## This class is used as a data container to hold all relevant information about a test case,
## including its location, dependencies, and metadata for test discovery and execution.

class_name GdUnitTestCase
extends RefCounted

## A unique identifier for the test case. Used to track and reference specific test instances.
var guid := GdUnitGUID.new()

## The name of the test method/function. Should start with "test_" prefix.
var test_name: String

##  The class name of the test suite containing this test case.
var suite_name: String

## The fully qualified name of the test case following C# namespace pattern:
## Constructed from the folder path (where folders are dot-separated), the test suite name, and the test case name.
## All parts are joined by dots: {folder1.folder2.folder3}.{suite_name}.{test_name}
var fully_qualified_name: String

## Index tracking test attributes for ordered execution. Default is 0.
## Higher values indicate later execution in the test sequence.
var attribute_index: int

## Flag indicating if this test requires the Godot runtime environment.
## Tests requiring runtime cannot be executed in isolation.
var require_godot_runtime: bool

## The path to the source file containing this test case.
## Used for test discovery and execution.
var source_file: String

## The line number where the test case is defined in the source file.
## Used for navigation and error reporting.
var line_number: int

## Additional metadata about the test case, such as:
## - tags: Array[String] - Test categories/tags for filtering
## - timeout: int - Maximum execution time in milliseconds
## - skip: bool - Whether the test should be skipped
## - dependencies: Array[String] - Required test dependencies
var metadate: Dictionary = {}
