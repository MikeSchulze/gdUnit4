class_name GdUnitTestCoverageChecker
extends RefCounted

# verbosity levels:
# NONE: not verbose
# FILENAMES: coverage for each file,
# FAILING_FILES: coverage for only files that failed to meet the file coverage target.
# PARTIAL_FILES: coverage for each line (except when file coverage is 0%/100%)
# ALL_FILES: coverage for each line for every file
enum Verbosity { NONE = 0, FILENAMES = 1, FAILING_FILES = 3, PARTIAL_FILES = 4, ALL_FILES = 5 }

const MAX_QUEUE_SIZE := 10000

var coverage_collectors :Dictionary[String,ScriptCoverageCollector] = {}

var _scene_tree: MainLoop
var _exclude_paths := []
var _enforce_node_coverage := false
var _autoloads_instrumented := false
var _coverage_target_file := INF
var _coverage_target_total := INF

static var instance: GdUnitTestCoverageChecker


class ScriptCoverage:
	extends RefCounted

	var coverage_lines : Dictionary[int,int]= {}
	# coverage_queue.append() is so far the fastest way to instrument code
	# coverage_queue.append(line_number) seems faster than coverage_lines[i] += 1
	var coverage_queue := []
	var script_path := ""
	var source_code := ""

	func _init(_script_path: String, _load_source_code := false) -> void:
		script_path = _script_path
		var f := FileAccess.open(_script_path, FileAccess.READ)
		assert(f, "Unable to open %s for reading: %s" % [_script_path, FileAccess.get_open_error()])
		source_code = f.get_as_text()
		f.close()

	func coverage_count() -> int:
		process_queue()
		var count := 0
		for line in coverage_lines:
			if coverage_lines[line] > 0:
				count += 1
		return count

	func coverage_line_count() -> int:
		process_queue()
		return len(coverage_lines)

	func coverage_percent() -> float:
		process_queue()
		var clc := coverage_line_count()
		return (float(coverage_count()) / float(clc)) * 100.0 if clc > 0 else 100.0

	func add_line_coverage(line_number: int, count := 1) -> void:
		if !line_number in coverage_lines:
			coverage_lines[line_number] = 0
		coverage_lines[line_number] = coverage_lines[line_number] + count

	func get_coverage_json() -> Dictionary:
		process_queue()
		return coverage_lines.duplicate()

	func merge_coverage_json(coverage_json: Dictionary) -> void:
		@warning_ignore("untyped_declaration")
		for line_number in coverage_json:
			add_line_coverage(int(line_number), coverage_json[line_number])

	func script_coverage(verbosity := Verbosity.NONE, target: float = INF) -> String:
		var result := PackedStringArray()
		var i := 0
		var coverage_percent := coverage_percent()
		var partial_show: bool = (
			verbosity == Verbosity.PARTIAL_FILES && coverage_percent < 100 && coverage_percent > 0
		)
		var failed_show: bool = verbosity == Verbosity.FAILING_FILES && coverage_percent < target
		var show_source := partial_show || failed_show || verbosity == Verbosity.ALL_FILES
		var pass_fail := ""

		if target != INF:
			pass_fail = "(fail) " if coverage_percent < target else "(pass) "
		result.append("%s%.1f%% %s" % [pass_fail, coverage_percent, script_path])
		if show_source:
			for line in source_code.split("\n"):
				result.append(
					(
						"%4d %s %s"
						% [
							i,
							"%4dx" % [coverage_lines[i]] if i in coverage_lines else "     ",
							line
						]
					)
				)
				i += 1
		return "\n".join(result)

	# virtual
	# Call this function to revert the script object to it's original state.
	func revert() -> void:
		pass

	# only process the queue if it got too big
	func maybe_process_queue() -> void:
		if len(coverage_queue) > MAX_QUEUE_SIZE:
			process_queue()

	func process_queue() -> void:
		@warning_ignore("untyped_declaration")
		for line in coverage_queue:
			add_line_coverage(line)
		coverage_queue = []

class BlockCounter:
	var blocks :=  {"{}": 0, "()": 0, "[]": 0}
	var lambda: BlockCounter = null

	func _line_ends_with_lambda(line: String) -> bool:
		if line.ends_with("):"):
			var paren_count := 0
			var map := {
				"(": -1,
				")": 1
			}
			for i in range(len(line) - 2, 4, -1):
				paren_count += map.get(line[i], 0)
				if paren_count == 0:
					return line.substr(i - 4, 4) == "func"
		return false

	func _erase_string_literals(line: String) -> String:
		# Ignoring multiline strings here .. probably need to deal with them at some point
		var dq := "\""
		var sq := "'"
		var quote := ""
		var escaped := false
		var result := line
		for i in len(line):
			if quote:
				if !escaped && line[i] == quote:
					quote = ""
				else:
					result[i] = "_"
				escaped = line[i] == "\\"
			else:
				if line[i] in [dq, sq]:
					quote = line[i]
		return result

	func _merge_lambda() -> void:
		@warning_ignore("untyped_declaration")
		for k in lambda.blocks:
			blocks[k] += lambda.blocks[k]
		lambda = null

	## Normally returns 0, except when exiting a lambda block,
	## then it contains the outer block's total
	func update(line: String, ignore_lambda := false) -> int:
		line = _erase_string_literals(line)
		var line_ends_with_lambda := !ignore_lambda && _line_ends_with_lambda(line)
		if line_ends_with_lambda && !lambda:
			# next time we are called, we will defer to the nested lambda block
			lambda = BlockCounter.new()
		elif lambda:
			lambda.update(line, line_ends_with_lambda)
			# if lambda total is <0 it will be merged on the next pass.. but we need to know
			# the block count of the outer block on this line
			var t := lambda.get_total()
			if t < 0:
				t = get_total()
				_merge_lambda()
				return t
			return 0
		@warning_ignore("untyped_declaration")
		for key in blocks:
			var block_count := line.count(key[0]) - line.count(key[1])
			blocks[key] += block_count
		return 0

	func get_total() -> int:
		if lambda:
			var lr := lambda.get_total()
			if lr >= 0:
				return lr
			pass
		var result := 0
		@warning_ignore("untyped_declaration")
		for key in blocks:
			result += blocks[key]
		return result

	func _to_string() -> String:
		if lambda:
			return "%s l%s" % [blocks, lambda]
		return str(blocks)

class ScriptCoverageCollector:
	extends ScriptCoverage

	var DEBUG_SCRIPT_COVERAGE := false
	const ERR_MAP := {43: "PARSE_ERROR"}
	const LAMBDA_BLOCK = "func():"

	var instrumented_source_code := ""
	var covered_script: Script

	static var last_script_id := 0

	class Indent:
		extends RefCounted
		enum State { NONE, CLASS, FUNC, STATIC_FUNC, MATCH, MATCH_PATTERN }

		var depth: int
		var state: int
		var subclass_name: String

		func _init(_depth: int, _state: int, _subclass_name: String) -> void:
			depth = _depth
			state = _state
			subclass_name = _subclass_name

	func _init(coverage_script_path: String, script_path: String) -> void:
		super(script_path, false)
		#DEBUG_SCRIPT_COVERAGE = _script_path.match("*some_script.gd")
		var id := last_script_id + 1
		last_script_id = id
		covered_script = load(script_path)
		source_code = covered_script.source_code
		if DEBUG_SCRIPT_COVERAGE:
			print(covered_script)
		instrumented_source_code = _interpolate_coverage(coverage_script_path, covered_script, id)
		# caller must run set_instrumented() in case the script has a _static_init

	func _set_script_code(new_source_code :String) -> void:
		if covered_script.source_code == new_source_code:
			return
		covered_script.source_code = new_source_code
		if DEBUG_SCRIPT_COVERAGE:
			print(add_line_numbers(covered_script.source_code))
		# if we pass 'keep_state = true' to reload() then we can reload the script
		# without removing it from all the nodes.
		# this requires us to add a function call for each line that checks to make
		# sure the coverage variable is set before calling add_line_coverage
		var err := covered_script.reload(true)

		assert(
			err == OK,
			(
				"Error reloading %s: error: %s\n-------\n%s"
				% [
					covered_script.resource_path,
					ERR_MAP[err] if err in ERR_MAP else err,
					add_line_numbers(covered_script.source_code)
				]
			)
		)

	func set_instrumented(value := true) -> void:
		_set_script_code(instrumented_source_code if value else source_code)

	func revert() -> void:
		pass
		# this can cause scripts to crash
		# set_instrumented(false)

	static func add_line_numbers(source_code: String) -> String:
		var result := PackedStringArray()
		var i := 0
		for line in source_code.split("\n"):
			result.append("%4d: %s" % [i, line])
			i += 1
		return "\n".join(result)

	func _to_string() -> String:
		return script_coverage(2)

	func _get_token(stripped_line: String, skip := 0) -> String:
		var space_token := stripped_line.get_slice(" ", skip)
		var tab_token := stripped_line.get_slice("\t", skip)
		return space_token if space_token && len(space_token) < len(tab_token) else tab_token

	func _get_leading_whitespace(line: String) -> String:
		var leading_whitespace := PackedStringArray()
		for chr in range(len(line)):
			if line[chr] in [" ", "\t"]:
				leading_whitespace.append(line[chr])
			else:
				break
		return "".join(leading_whitespace)

	func _get_coverage_collector_expr(
		coverage_script_path: String, script_resource_path: String
	) -> String:
		return (
			'preload("%s").instance.get_coverage_collector("%s")'
			% [coverage_script_path, script_resource_path]
		)

	func _interpolate_coverage(coverage_script_path: String, script: GDScript, _id: int) -> String:
		var collector_var := "__cl__"
		var lines := script.source_code.split("\n")
		var indent_stack := []
		var ld_stack := []
		var write_var := false
		var state: int = Indent.State.NONE
		var next_state: int = Indent.State.NONE
		var subclass_name: String
		var next_subclass_name: String
		var depth := 0
		var out_lines := PackedStringArray()
		# 0 based, start with -1 so that the first increment will give 0
		var i := -1
		var block := BlockCounter.new()
		# the collector var must be placed after 'extends' b
		var continuation := false

		for line in lines:
			i += 1
			var comment := ""
			var stripped_line := line.strip_edges()
			if stripped_line == "" || stripped_line.begins_with("#"):
				if DEBUG_SCRIPT_COVERAGE:
					var lws := _get_leading_whitespace(line)
					out_lines.append("%s\t# empty skip: %s" % [lws, block])
				out_lines.append(line)
				continue
			# if we are inside a block then block_count will be > 0, we can't insert instrumentation
			# except if it's a lambda, then we create a nested lambda block
			var block_count := block.get_total()
			# update the block count:
			#  '(', '{' and '[' characters create a block
			#  except if there's a lambda initialization (line matches /func(...):$/)
			block_count += block.update(stripped_line)
			# if we are in a block or have a continuation from the last line
			# don't add instrumentation
			var skip := block_count > 0 || continuation
			continuation = stripped_line.ends_with("\\")
			if skip:
				if DEBUG_SCRIPT_COVERAGE:
					var lws := _get_leading_whitespace(line)
					out_lines.append("%s\t# early skip: %s %s" % [lws, block_count, block])
				out_lines.append(line)
				continue

			var leading_whitespace := _get_leading_whitespace(line)
			var line_depth := len(leading_whitespace)
			while line_depth < depth:
				@warning_ignore("inference_on_variant")
				var indent := indent_stack.pop_back()
				if DEBUG_SCRIPT_COVERAGE:
					print(
						(
							"\t\t\t\tPOP_LINE_DEPTH %s > %s (%s) %s  (was %s) %s"
							% [
								depth,
								indent.depth,
								state,
								indent.subclass_name,
								subclass_name,
								subclass_name && subclass_name != indent.subclass_name
							]
						)
					)
				depth = indent.depth
				state = indent.state
				next_state = indent.state
				subclass_name = indent.subclass_name
			if line_depth > depth:
				if DEBUG_SCRIPT_COVERAGE:
					print(
						(
							"\t\t\t\tPUSH_LINE_DEPTH %s > %s (%s > %s) %s"
							% [depth, line_depth, state, next_state, subclass_name]
						)
					)
				indent_stack.append(Indent.new(depth, state, subclass_name))
				if next_subclass_name:
					subclass_name = next_subclass_name
				next_subclass_name = ""
				state = next_state
			depth = line_depth

			var first_token := _get_token(stripped_line)
			match first_token:
				"func":
					next_state = Indent.State.FUNC
					write_var = true
				"class":
					next_state = Indent.State.CLASS
					next_subclass_name = _get_token(stripped_line, 1).trim_suffix(":")
				"static":
					write_var = true
					next_state = Indent.State.STATIC_FUNC
				"else:", "elif":
					skip = true
				"match":
					next_state = Indent.State.MATCH
			if state == Indent.State.MATCH:
				next_state = Indent.State.MATCH_PATTERN
			elif state == Indent.State.MATCH_PATTERN:
				next_state = Indent.State.FUNC
			if !skip && state in [Indent.State.FUNC, Indent.State.STATIC_FUNC]:
				if write_var:
					write_var = false
					out_lines.append(
						(
							"%svar %s = %s.coverage_queue"
							% [
								leading_whitespace,
								collector_var,
								_get_coverage_collector_expr(
									coverage_script_path, script.resource_path
								)
							]
						)
					)
				if DEBUG_SCRIPT_COVERAGE:
					comment += "%s %s" % [block_count, block]
				comment = " # " + comment if comment else ""
				coverage_lines[i] = 0
				out_lines.append("%s%s.append(%s)%s" % [leading_whitespace, collector_var, i, comment])
			elif DEBUG_SCRIPT_COVERAGE:
				out_lines.append("%s\t# skip: %s state: %s" % [leading_whitespace, skip, state])
			out_lines.append(line)
		return "\n".join(out_lines)


# this is a placeholder class for when we've finalized and don't want coverage anymore
# some scripts will continue to be instrumented so we must have something to accept all these calls
class NullCoverage:
	extends ScriptCoverageCollector
	func get_coverage_collector(_script_name: String) -> ScriptCoverageCollector:
		return self

func _init(scene_tree: MainLoop, exclude_paths := []) -> void:
	_exclude_paths += exclude_paths
	assert(!instance, "Only one instance of this class is allowed")
	instance = self
	_scene_tree = scene_tree


func enforce_node_coverage() -> GdUnitTestCoverageChecker:
	var err := _scene_tree.connect("tree_changed", Callable(self, "_on_tree_changed"))
	assert(err == OK)
	_enforce_node_coverage = true
	# this may error on autoload if you don"t call `instrument_autoloads()` immediately
	_on_tree_changed()
	return self


func _finalize(print_verbosity := 0) -> void:
	for script_path in coverage_collectors:
		coverage_collectors[script_path].revert()
	if _enforce_node_coverage:
		_scene_tree.disconnect("tree_changed", Callable(self, "_on_tree_changed"))
	print(script_coverage(print_verbosity))


func get_coverage_collector(script_name: String) -> ScriptCoverageCollector:
	var result := coverage_collectors[script_name] if script_name in coverage_collectors else null
	if result:
		result.maybe_process_queue()
	else:
		printerr("Unable to get coverage collector for %s" % [script_name])
		print_stack()
		printerr(ScriptCoverageCollector.add_line_numbers(load(script_name).get_source_code()))
	return result


func coverage_count() -> int:
	var result := 0
	for script in coverage_collectors:
		result += coverage_collectors[script].coverage_count()
	return result


func coverage_line_count() -> int:
	var result := 0
	for script in coverage_collectors:
		result += coverage_collectors[script].coverage_line_count()
	return result


func coverage_percent() -> float:
	var clc := coverage_line_count()
	return (float(coverage_count()) / float(clc)) * 100.0 if clc > 0 else 100.0


func set_coverage_targets(total: float, file: float) -> void:
	_coverage_target_total = total
	_coverage_target_file = file


func coverage_passing() -> bool:
	var all_files_passing := true
	if _coverage_target_file < INF:
		for script in coverage_collectors:
			var script_percent := coverage_collectors[script].coverage_percent()
			all_files_passing = all_files_passing && script_percent >= _coverage_target_file
	return coverage_percent() >= _coverage_target_total && all_files_passing


# see ScriptCoverage.Verbosity for verbosity levels
func script_coverage(verbosity := 0) -> String:
	var result := PackedStringArray()
	var coverage_count := 0
	var coverage_lines := 0
	var coverage_percent := coverage_percent()
	var pass_fail := ""
	if _coverage_target_total != INF:
		pass_fail = "(fail) " if coverage_percent < _coverage_target_total else "(pass) "
	var multiline := false
	if verbosity > Verbosity.NONE:
		for script in coverage_collectors:
			var file_coverage := coverage_collectors[script].script_coverage(
				verbosity, _coverage_target_file
			)
			result.append(file_coverage)
			if file_coverage.match("*\n*"):
				multiline = true
	result.append(
		(
			"%s%.1f%% Total Coverage: %s/%s lines"
			% [pass_fail, coverage_percent, coverage_count(), coverage_line_count()]
		)
	)

	return ("\n\n" if multiline else "\n").join(result)


func merge_from_coverage_file(filename: String, auto_instrument := true) -> bool:
	var f := FileAccess.open(filename, FileAccess.READ)
	if !f:
		printerr("Error %s opening %s for reading" % [FileAccess.get_open_error(), filename])
		return false
	var test_json_conv := JSON.new()
	var err := test_json_conv.parse(f.get_as_text())
	@warning_ignore("untyped_declaration")
	var parsed = test_json_conv.data
	f.close()
	if err != OK:
		printerr(
			"Error %s on line %s parsing %s" % [err, test_json_conv.get_error_line(), filename]
		)
		printerr(parsed.error_string)
		return false
	if !parsed is Dictionary:
		printerr("Error: content of %s expected to be a dictionary" % [filename])
		return false
	@warning_ignore("untyped_declaration")
	for script_path in parsed:
		if !parsed[script_path] is Dictionary:
			printerr("Error: %s in %s is expected to be a dictionary" % [script_path, filename])
			return false
		if auto_instrument:
			_instrument_script(load(script_path))
		elif !script_path in coverage_collectors:
			coverage_collectors[script_path] = ScriptCoverage.new(script_path)
		coverage_collectors[script_path].merge_coverage_json(parsed[script_path])
	return true


func save_coverage_file(filename: String) -> bool:
	var coverage := {}
	for script_path in coverage_collectors:
		coverage[script_path] = coverage_collectors[script_path].get_coverage_json()
	var f := FileAccess.open(filename, FileAccess.WRITE)
	if !f:
		printerr(
			(
				"Error %s opening coverage file %s for writing"
				% [FileAccess.get_open_error(), filename]
			)
		)
		return false
	f.store_string(JSON.stringify(coverage))
	f.close()
	return true


func _on_tree_changed() -> void:
	_ensure_node_script_instrumentation(_scene_tree.root)


func _excluded(resource_path: String) -> bool:
	var excluded := false
	@warning_ignore("untyped_declaration")
	for ep in _exclude_paths:
		if resource_path.match(ep):
			excluded = true
			break
	return excluded


func _ensure_node_script_instrumentation(node: Node) -> void:
	# this is too late, if a node already has the script then reload it fails with ERR_ALREADY_IN_USE
	@warning_ignore("inference_on_variant")
	var script := node.get_script()
	if script is GDScript:
		assert(
			_excluded(script.resource_path) || script.resource_path in coverage_collectors,
			(
				"Node %s has a non-instrumented script %s"
				% [node.get_path() if node.is_inside_tree() else node.name, script.resource_path]
			)
		)
	for n in node.get_children():
		_ensure_node_script_instrumentation(n)


func _instrument_script(script: GDScript) -> void:
	var script_path := script.resource_path
	var coverage_script_path :String = get_script().resource_path

	if !_excluded(script_path) && script_path && !script_path in coverage_collectors:
		var cc := ScriptCoverageCollector.new(coverage_script_path, script_path)
		coverage_collectors[script_path] = cc
		# NOTE: if the script has _static_init we need to update the source code after adding the collector
		cc.set_instrumented()
		var deps := ResourceLoader.get_dependencies(script_path)
		if len(deps) == 0:
			# TODO: remove when this issue is resolved:
			# https://github.com/godotengine/godot/issues/90643
			deps = _scan_script_for_dependencies(script_path, script.get_source_code())
		for dep in deps:
			if dep.get_extension() == "gd":
				var s := load(dep)
				assert(
					s, "Unable to load dependency %s while instrumenting %s" % [dep, script_path]
				)
				_instrument_script(s)


func _scan_script_for_dependencies(script_path: String, source_code: String) -> PackedStringArray:
	var script_dir := script_path.get_base_dir()
	var load_expr := RegEx.new()
	var abs_path_expr := RegEx.new()
	load_expr.compile("\\b(?:pre)load\\([\"'](?<path>[^\"']+)[\"']\\)[\\b\\n]")
	# ^res://, ^user:// etc or ^/ or ^\ or ^c:\
	abs_path_expr.compile("^(\\w+://|/|\\\\|\\w:\\\\)")
	var found := load_expr.search_all(source_code)
	var result := PackedStringArray()
	for f in found:
		var path := f.get_string("path")
		var abs_match := abs_path_expr.search(path)
		if !abs_match:
			path = script_dir.path_join(path.trim_prefix("./"))
		result.append(path)
	return result


func instrument_scene_scripts(scene: PackedScene) -> GdUnitTestCoverageChecker:
	var s := scene.get_state()
	for i in range(s.get_node_count()):
		var node_instance := s.get_node_instance(i)
		if node_instance:
			# load this packed scene and replace all scripts etc
			instrument_scene_scripts(node_instance)
		for npi in range(s.get_node_property_count(i)):
			var p := s.get_node_property_name(i, npi)
			print("scene prop %s :%s" % [p, s.get_node_property_value(i, npi)])
			if p == "script":
				_instrument_script(s.get_node_property_value(i, npi))
	return self


func _collect_script_objects(obj: Object, objs: Array, obj_set: Dictionary) -> void:
	# prevent cycles
	obj_set[obj] = true
	assert(obj && obj.get_script(), "Couldn't collect script from %s" % [obj])
	if obj.get_script() && !_excluded(obj.get_script().resource_path):
		objs.append({obj = obj, script = obj.get_script()})
	# collect all child nodes of an autoload that may have scripts attached
	if obj is Node:
		@warning_ignore("untyped_declaration")
		for c in obj.get_children():
			var script :GDScript = c.get_script()
			if script && script.resource_path:
				_collect_script_objects(c, objs, obj_set)
	# collect all properties of autoloaded objects that may have scripts attached
	for p in obj.get_property_list():
		if p.type == TYPE_OBJECT:
			if p.name in obj:
				@warning_ignore("inference_on_variant")
				var value := obj.get(p.name)
				if !value in obj_set:
					var script :GDScript = value.get_script() if value else null
					if script && script.resource_path:
						_collect_script_objects(value, objs, obj_set)


func _collect_autoloads() -> Array[GDScript]:
	assert(!_autoloads_instrumented, "Tried to collect autoloads twice?")
	_autoloads_instrumented = true
	var autoloaded := []
	var obj_set := {}
	assert(
		_scene_tree is SceneTree,
		"Cannot collect autoloads from %s because it is not a SceneTree" % [_scene_tree]
	)
	var root := (_scene_tree as SceneTree).root
	for n in root.get_children():
		var setting_name := "autoload/%s" % [n.name]
		var autoload_setting :String = (
			ProjectSettings.get_setting(setting_name)
			if ProjectSettings.has_setting(setting_name)
			else ""
		)
		if autoload_setting:
			_collect_script_objects(n, autoloaded, obj_set)
	autoloaded.reverse()
	var deps := []
	@warning_ignore("untyped_declaration")
	for item in autoloaded:
		for d in ResourceLoader.get_dependencies(item.script.resource_path):
			var dep_script := load(d)
			if dep_script:
				deps.append({obj = null, script = dep_script})
	return deps + autoloaded


func instrument_autoloads() -> GdUnitTestCoverageChecker:
	var autoload_scripts := _collect_autoloads()
	autoload_scripts.reverse()
	for item in autoload_scripts:
		_instrument_script(item.script)
	return self


func instrument_scripts(path: String) -> GdUnitTestCoverageChecker:
	var list := _list_scripts_recursive(path)
	@warning_ignore("untyped_declaration")
	for script in list:
		_instrument_script(load(script))
	return self


func _list_scripts_recursive(path: String, list := []) -> Array:
	var d := DirAccess.open(path)
	assert(d, "Error opening path %s: %s" % [path, DirAccess.get_open_error()])
	var err := d.list_dir_begin()  # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	assert(err == OK, "Error listing directory %s: %s" % [path, err])
	var next := d.get_next()
	while next:
		var next_path := path.path_join(next)
		if next.get_extension() == "gd":
			if !_excluded(next_path):
				list.append(next_path)
		elif d.dir_exists(next_path):
			_list_scripts_recursive(next_path, list)
		next = d.get_next()
	d.list_dir_end()
	return list


static func finalize(print_verbosity := 0) -> void:
	# gdlint: ignore=private-method-call
	instance._finalize(print_verbosity)
	var scene_tree := instance._scene_tree
	instance = null
