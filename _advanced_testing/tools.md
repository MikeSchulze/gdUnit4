---
layout: default
title: Tools and Monitoring
parent: Advanced Testing
nav_order: 5
---

# Tools and Monitoring

GdUnit offers numerous functions that make it easier to write tests.

---

### error_as_string
Map Godot error number to a readable error message. See[Error Codes](https://docs.godotengine.org/de/stable/classes/class_@globalscope.html#enum-globalscope-error){:target="_blank"}

{% tabs tools-error_as_string %}
{% tab tools-error_as_string GdScript %}
```ruby
    func error_as_string(error_number :int) -> String:
```
{% endtab %}
{% tab tools-error_as_string C# %}
```cs
    public static string ErrorAsString(Godot.Error errorNumber);
    public static string ErrorAsString(int errorNumber);
```
{% endtab %}
{% endtabs %}

### auto_free()
A little helper for automatically releasing your created objects after the test execution.

*Objects do not manage memory. If a class inherits from Object, you will have to delete instances of it manually.*
*References keep an internal reference counter so that they are automatically released when no longer in use, and only then. References therefore do not need to be freed manually with Object.free.*

Use **auto_free()** to automatically released Objects when no longer in use.

{% tabs tools-auto_free %}
{% tab tools-auto_free GdScript %}
```ruby
    func auto_free(obj :Object) -> Object:
```
{% endtab %}
{% tab tools-auto_free C# %}
```cs
    public static T AutoFree<T>(T obj);
```
{% endtab %}
{% endtabs %}

Example:
{% tabs tools-auto_free-example %}
{% tab tools-auto_free-example GdScript %}
```ruby
    # using auto_free() on Path object to register for freeing after the test is finished
    assert_object(auto_free(Path.new())).is_not_instanceof(Tree)
```
{% endtab %}
{% tab tools-auto_free-example C# %}
```cs
    // using AutoFree() on Path object to register for freeing after the test is finished
    AssertObject(AutoFree(new Godot.Path())).IsNotInstanceOf<Godot.Tree>();
```
{% endtab %}
{% endtabs %}


### *A small example test suite to show up memory usage and freeing*
Objects covered by *auto_free* live only in the scope where it is used. Scopes are: *test suite setup*, *test case setup* and *tests*

```ruby
    extends GdUnitTestSuite

    var _obj_a;
    var _obj_b;
    var _obj_c;

    # Scope test suite setup
    func before():
        _obj_a = auto_free(Node.new())
        print_obj_usage("before")

    # Scope test case setup
    func before_test():
        _obj_b = auto_free(Node.new())
        print_obj_usage("before_test")

    # Scope test
    func test():
        _obj_c = auto_free(Node.new())
        # _obj_a still lives here
        # _obj_b still lives here
        # _obj_b still lives here
        print_obj_usage("test")

    # Scope test case setup
    func after_test():
        # _obj_a still lives here
        # _obj_b still lives here
        # _obj_c is freed
        print_obj_usage("after_test")
        
    # Scope test suite setup
    func after():
        # _obj_a still lives here
        # _obj_b is auto freed
        # _obj_c is freed
        print_obj_usage("after")

    func _notification(what):
        if what == NOTIFICATION_PATH_CHANGED:
            print_header()
        else:
            print_obj_usage(GdObjects.notification_as_string(what))

    func print_header() :
        prints("|%16s | %16s | %16s | %16s |" % ["", "_obj_a", "_obj_b", "_obj_c"])
        prints("----------------------------------------------------------------------------")

    func print_obj_usage(name :String) :
        prints("|%16s | %16s | %16s | %16s |" % [name, _obj_a, _obj_b, _obj_c])
```

```
|                 |           _obj_a |           _obj_b |           _obj_c |
----------------------------------------------------------------------------
|        PARENTED |             Null |             Null |             Null |
|      ENTER_TREE |             Null |             Null |             Null |
| POST_ENTER_TREE |             Null |             Null |             Null |
|           READY |             Null |             Null |             Null |
|          before |      [Node:1515] |             Null |             Null |
|     before_test |      [Node:1515] |      [Node:1519] |             Null |
|            test |      [Node:1515] |      [Node:1519] |      [Node:1521] |
|      after_test |      [Node:1515] |      [Node:1519] | [Deleted Object] |
|           after |      [Node:1515] | [Deleted Object] | [Deleted Object] |
|       EXIT_TREE | [Deleted Object] | [Deleted Object] | [Deleted Object] |
|      UNPARENTED | [Deleted Object] | [Deleted Object] | [Deleted Object] |
|       PREDELETE | [Deleted Object] | [Deleted Object] | [Deleted Object] |
```


### create_temp_dir
Creates a new directory under the temporary directory *user://tmp*.

Useful for storing data during test execution. The directory is automatically deleted after the execution of the test suite.

{% tabs tools-create_temp_dir %}
{% tab tools-create_temp_dir GdScript %}
```ruby
    func create_temp_dir(relative_path :String) -> String:
```
{% endtab %}
{% tab tools-create_temp_dir C# %}
```cs
    public static string CreateTempDir(string path);
```
{% endtab %}
{% endtabs %}

Example:

```ruby
    func test_save_game_data():
        # create a temporay directory to store test data
        var temp_dir := create_temp_dir("examples/game/save")
        var file_to_save := temp_dir + "/save_game.dat"
        
        var data = {
            'user': "Hoschi",
            'level': 42
        }
        var file := File.new()
        file.open(file_to_save, File.WRITE)
        file.store_line(JSON.print(data))
        file.close()
        
            # the data is saved at "user://tmp/examples/game/save/save_game.dat"
        assert_bool(file.file_exists(file_to_save)).is_true()
```


### clean_temp_dir
Deletes the temporary directory.

Is called automatically after each execution of the test suite.

{% tabs tools-clean_temp_dir %}
{% tab tools-clean_temp_dir GdScript %}
```ruby
   func clean_temp_dir():
```
{% endtab %}
{% tab tools-clean_temp_dir C# %}
```cs
   public static void ClearTempDir();
```
{% endtab %}
{% endtabs %}

### create_temp_file
Creates a new File under the temporary directory *user://tmp* + \<relative_path\>
with given name \<file_name\> and given file \<mode\> (default = File.WRITE).

If success the returned File is automatically closed after the execution of the test suite.

```ruby
    func create_temp_file(relative_path :String, file_name :String, mode :=File.WRITE) -> File:
```

Example:
We create a small test file in the beginning of a test suite on *before()* and read it later on the test.
It is not need to close the file (e.g. you forgot it to close), the GdUnit test runner will close it automaticaly.

```ruby
    # setup test data
    func before():
        # opens a tmp file with WRITE mode under "user://tmp/examples/game/game.sav" (auto closed)
        var file := create_temp_file("examples/game", "game.sav")
        assert_object(file).is_not_null()
        # write some example data
        file.store_line("some data")
        # not needs to be manually close, will be auto closed before test execution
        
    func test_create_temp_file():
        # opens the stored tmp file with READ mode under "user://tmp/examples/game/game.sav" (auto closed)
        var file_read := create_temp_file("examples/game", "game.sav", File.READ)
        assert_object(file_read).is_not_null()
        assert_str(file_read.get_as_text()).is_equal("some data\n")
        # not needs to be manually close, will be auto closed after test suite execution
```


### resource_as_array
Reads a resource by given path \<resource_path\> into an pooled string array.

```ruby
    func resource_as_array(resource_path :String) -> PoolStringArray:
```

Example:

```ruby
	var rows = ["row a", "row b"]
	var file_content := resource_as_array("res://myproject/test/resources/TestRows.txt")
	assert_array(rows).contains_exactly(file_content)
```


### resource_as_string
Reads a resource by given path \<resource_path\> and returned the content as String.

```ruby
    func resource_as_string(resource_path :String) -> String:
```

Example:

```ruby
	var rows = "row a\nrow b\n"
	var file_content := resource_as_string("res://myproject/test/resources/TestRows.txt")
	assert_string(rows).is_equal(file_content)
```


## Monitoring
---
### Orphan Nodes or leaking Memory
In Godot, objects that are not freed are called *orphan nodes*. When you start writing a test, you often have no way of knowing whether all of the objects you created were properly shared after the test was run.
One helping tool is using **auto_free** to manage your object.

GdUnit will help you by reporting detected orphan nodes for each test run in the status bar.
A green icon indicates no orphan nodes detected and a red blinking icon warns you to have detected orphan nodes.

![](/gdUnit3/assets/images/monitoring/orphan-nodes.png)

Use the button to jump to the first orphan node to inspect.
Orphan nodes are reported and marked in yellow for each test step as before(), before_test() and the test itself.

I recommend checking your implementation if any orphan nodes are detected, follow the guide to fix.



### Test Execution Time
On the status bar at the bottom left the total elapsed execution time is shown.
The execution time is messured to for each testsuite and testcase and can be read on each element in the tree inspector.

![](/gdUnit3/assets/images/monitoring/execution-time.png)