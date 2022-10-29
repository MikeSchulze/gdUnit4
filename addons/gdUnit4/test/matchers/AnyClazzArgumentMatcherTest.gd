# GdUnit generated TestSuite
class_name AnyClazzArgumentMatcherTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/matchers/AnyClazzArgumentMatcher.gd'

func test_is_match_reference():
	var matcher := AnyClazzArgumentMatcher.new(RefCounted)
	
	assert_bool(matcher.is_match(Resource.new())).is_true()
	assert_bool(matcher.is_match(RefCounted.new())).is_true()
	assert_bool(matcher.is_match(auto_free(Node.new()))).is_false()
	assert_bool(matcher.is_match(null)).is_false()
	assert_bool(matcher.is_match(0)).is_false()
	assert_bool(matcher.is_match(false)).is_false()
	assert_bool(matcher.is_match(true)).is_false()

func test_is_match_node():
	var matcher := AnyClazzArgumentMatcher.new(Node)
	
	assert_bool(matcher.is_match(auto_free(Node.new()))).is_true()
	assert_bool(matcher.is_match(auto_free(AnimationPlayer.new()))).is_true()
	assert_bool(matcher.is_match(auto_free(Timer.new()))).is_true()
	assert_bool(matcher.is_match(Resource.new())).is_false()
	assert_bool(matcher.is_match(RefCounted.new())).is_false()
	assert_bool(matcher.is_match(null)).is_false()
	assert_bool(matcher.is_match(0)).is_false()
	assert_bool(matcher.is_match(false)).is_false()
	assert_bool(matcher.is_match(true)).is_false()

func test_any_class():
	assert_object(any_class(Node)).is_instanceof(AnyClazzArgumentMatcher)
