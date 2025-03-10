## GdUnit4CSharpApiLoader
##
## A bridge class that handles communication between GDScript and C# for the GdUnit4 testing framework.
## This loader acts as a compatibility layer to safely access the .NET API and ensure that calls
## only proceed when the .NET environment is properly configured and available.
## [br]
## The class handles:
## - Verification of .NET runtime availability
## - Loading the C# wrapper script
## - Checking for the GdUnit4Api assembly
## - Providing proxy methods to access GdUnit4 functionality in C#
class_name GdUnit4CSharpApiLoader
extends RefCounted

## Cached reference to the loaded C# wrapper script
static var _gdUnit4NetWrapper: Script


## Returns an instance of the GdUnit4CSharpApi wrapper.[br]
## @return Script: The loaded C# wrapper or null if .NET is not supported
static func instance() -> Script:
	if not GdUnit4CSharpApiLoader.is_dotnet_supported():
		return null

	return _gdUnit4NetWrapper


static func is_engine_version_supported(engine_version: int = Engine.get_version_info().hex) -> bool:
	return engine_version >= 0x40200


## Checks if the .NET environment is properly configured and available.[br]
## This performs multiple checks:[br]
## 1. Verifies if the wrapper is already loaded[br]
## 2. Confirms Godot has C# support[br]
## 3. Validates the project's C# configuration[br]
## 4. Attempts to load the wrapper and find the GdUnit4 assembly[br]
##
## @return bool: True if .NET is fully supported and the assembly is found
static func is_dotnet_supported() -> bool:
	# If the wrapper is already loaded we don't need to check again
	if _gdUnit4NetWrapper != null:
		return true

	# First we check if this is a Godot .NET runtime instance
	if not ClassDB.class_exists("CSharpScript") and not is_engine_version_supported():
		return false
	# Second we check the C# project file exists
	var assembly_name: String = ProjectSettings.get_setting("dotnet/project/assembly_name")
	if assembly_name.is_empty() or not FileAccess.file_exists("res://%s.csproj" % assembly_name):
		return false

	# Finally load the wrapper and check if the GdUnit4 assembly can be found
	_gdUnit4NetWrapper = load("res://addons/gdUnit4/src/dotnet/GdUnit4CSharpApi.cs")
	return _gdUnit4NetWrapper != null and _gdUnit4NetWrapper.call("FindGdUnit4NetAssembly")


## Returns the version of the GdUnit4 .NET assembly.[br]
## @return String: The version string or "unknown" if .NET is not supported
static func version() -> String:
	if not GdUnit4CSharpApiLoader.is_dotnet_supported():
		return "unknown"
	@warning_ignore("unsafe_method_access")
	return instance().Version()


static func create_test_suite(source_path: String, line_number: int, test_suite_path: String) -> GdUnitResult:
	if not GdUnit4CSharpApiLoader.is_dotnet_supported():
		return  GdUnitResult.error("Can't create test suite. No .NET support found.")
	@warning_ignore("unsafe_method_access")
	var result: Dictionary = instance().CreateTestSuite(source_path, line_number, test_suite_path)
	if result.has("error"):
		return GdUnitResult.error(str(result.get("error")))
	return  GdUnitResult.success(result)


static func is_test_suite(resource_path: String) -> bool:
	if not is_csharp_file(resource_path) or not GdUnit4CSharpApiLoader.is_dotnet_supported():
		return false

	if resource_path.is_empty():
		if GdUnitSettings.is_report_push_errors():
			push_error("Can't create test suite. Missing resource path.")
		return  false
	@warning_ignore("unsafe_method_access")
	return instance().IsTestSuite(resource_path)


static func parse_test_suite(source_path: String) -> Node:
	if not GdUnit4CSharpApiLoader.is_dotnet_supported():
		if GdUnitSettings.is_report_push_errors():
			push_error("Can't create test suite. No .Net support found.")
		return null
	@warning_ignore("unsafe_method_access")
	return instance().ParseTestSuite(source_path)


static func create_executor(listener: Node) -> RefCounted:
	if not GdUnit4CSharpApiLoader.is_dotnet_supported():
		return null
	@warning_ignore("unsafe_method_access")
	return instance().Executor(listener)


static func is_csharp_file(resource_path: String) -> bool:
	var ext := resource_path.get_extension()
	return ext == "cs" and GdUnit4CSharpApiLoader.is_dotnet_supported()
