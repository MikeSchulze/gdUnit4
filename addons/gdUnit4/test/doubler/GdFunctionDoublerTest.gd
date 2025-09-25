class_name GdFunctionDoublerTest
extends GdUnitTestSuite


# helper to get function descriptor
func get_function_description(clazz_name :String, method_name :String) -> GdFunctionDescriptor:
	var method_list := ClassDB.class_get_method_list(clazz_name)
	for method_descriptor in method_list:
		if method_descriptor["name"] == method_name:
			return GdFunctionDescriptor.extract_from(method_descriptor)
	return null
