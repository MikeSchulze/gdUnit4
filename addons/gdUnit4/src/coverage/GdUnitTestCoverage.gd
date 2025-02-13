class_name GdUnitTestCoverage
extends RefCounted

# Minimum default overall coverage target required for a successful code coverage check
static var DEFAULT_COVERAGE_TARGET := 0.0

# Minimum default per file coverage target required for a successful code coverage check
static var DEFAULT_FILE_TARGET := 0.0

# Default paths to exclude from coverage instrumentation
static var DEFAULT_EXCLUDE_PATHS : Array[String] = [
	"res://addons/*",
	# NOTE: Godot may crash if you try to instrument the script that's calling instrument_scripts()
	"res://tests/*",
]

static var instance : GdUnitTestCoverageChecker

## Setup the test coverage checker. Uses the given tree for instantiating the TestCoverage
## node. The specified excluded paths will not be instrumented and checked for test coverage.
## It is very important that the test coverage exlcude the test classes themselves within
## the excluded paths, as otherwise a circular instrumentation of instrumented classes
## will result.
static func setup(tree : SceneTree, exclude_paths := DEFAULT_EXCLUDE_PATHS) -> void:
	assert(instance == null, "Do not overwrite class singleton instance by calling setup twice")
	assert(tree != null, "The scene tree for initializing test coverage class may not be null")
	instance = GdUnitTestCoverageChecker.new(tree, exclude_paths)

## Optionally generates a report file at the specified filename location; defaults to using
## the value of env var COVERAGE_FILE if no other value is specified.
static func set_report_file(filename := OS.get_environment("COVERAGE_FILE")) -> void:
	assert(instance != null, "Before using this method ensure you setup coverage with setup function")
	instance.save_coverage_file(filename)

## Add a directory whose child scripts should be includeded and checked for test coverage.
static func add_checked_directory(source_dir : String) -> void:
	assert(instance != null, "Before using this method ensure you setup coverage with setup function")
	instance.instrument_scripts(source_dir)

## Configure what the acceptable minimum code coverage is for the overall set of scripts
## instrumented, as well as the minimum code coverage percentage required of each individual
## script file. Defaults to a target of 0% for both, which always successfully validates
## that the code coverage tagets were met.
static func set_targets(per_file_target := DEFAULT_FILE_TARGET, overall_target := DEFAULT_COVERAGE_TARGET) -> void:
	assert(per_file_target >= 0.0 && per_file_target <= 100.0, "Invalid per file target percentage given")
	assert(overall_target >= 0.0 && overall_target <= 100.0, "Invalid overall target percentage given")
	instance.set_coverage_targets(per_file_target, overall_target)

## Once finished adding all the instrumented code, this method finalizes the code coverage
## analysis. Returns true if the code coverage passsed with the
static func finish(verbosity := GdUnitTestCoverageChecker.Verbosity.FILENAMES) -> bool:
	assert(instance != null, "Before using this method ensure you setup coverage with setup function")
	instance._finalize(verbosity)
	return  instance.coverage_passing()
