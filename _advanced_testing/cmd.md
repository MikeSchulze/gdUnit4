---
layout: default
title: Command Line Tool
parent: Advanced Testing
nav_order: 8
---

# Command Line Tool

## The GdUnit Command Line Tool
GdUnit4 provides a command line tool named `res://addons/gdUnit4/bin/GdUnitCmdTool.gd` that allows you to run a specific set of test suites and tests from the command line. The tool provides a set of commands that can be used to control the execution of tests.
You can use the provided scripts `addons/gdunit4/runtest.sh` for linux/macos and `addons/gdunit4/runtest.cmd` for windows to execute the tool.

To get an overview of the available commands, execute it with the command `-help`.


```
----------------------------------------------------------------------------------------------
 GdUnit4 Commandline Tool

 Usage:
        runtest -a <directory|path of testsiute>
        runtest -a <directory> -i <path of testsuite|testsuite_name|testsuite_name:test_name>

-- Options ---------------------------------------------------------------------------------------

  [-help]                                 Shows this help message.

  [--help-advanced]                       Shows advanced options.

  [-a, --add]                             Adds the given test suite or directory to the execution pipeline.
     -a <directory|path of testsuite>

  [-i, --ignore]                          Adds the given test suite or test case to the ignore list.
     -i <testsuite_name|testsuite_name:test-name>

  [-c, --continue]                        By default GdUnit will abort on first test failure to be fail fast, instead of stop after first failure you can use this option to run the complete test set.

  [-conf, --config]                       Run all tests by given test configuration. Default is 'GdUnitRunner.cfg'
     -conf [testconfiguration.cfg]
```

## Preconditions to run on Windows 10
- Setup test environment as follow

  Add the environment variable `GODOT_BIN` by opening a termial and entering the command below.
  Replace the path `D:\develop\Godot.exe` with your own location where you have Godot installed.
```
    setx GODOT_BIN D:\develop\Godot.exe
```
- The GdUnit tool uses colored console output and needs to be enabled manually under Windows 10.

  **Do it manually by open regedit:**

  The registry key at HKEY_CURRENT_USER\Console\VirtualTerminalLevel sets the global default behavior for processing ANSI escape sequences. Create a     
  DWORD key (if necessary) and set its value to 1 to globally enable (or 0 to disable`) ANSI processing by default.
  
  **Do this with the following command and open the terminal again:**
```
  REG ADD HKCU\CONSOLE /f /v VirtualTerminalLevel /t REG_DWORD /d 1
```


Now you can run your tests by `runtest [cmd]`


## Preconditions to run on MacOS and Linux
- Setup test environment as follow
  
  Add the environment variable `GODOT_BIN` by opening a termial and entering the command below.
  Replace the path `/Applications/Godot.app/Contents/MacOS/Godot` with your own location where you have Godot installed.
```
 export GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot
``` 

Now you can run your tests by `./runtest.sh [cmd]`


### How to use
**Please note the requirements described above!**

You can use the tool to run a complete test package or only a specific set of execution definitions or tests.

```
    # runs all testsuites located under the directory '/myProject/test'
    runtest -a /myProject/test
```

You can specify one ore more directories for execution
```
    # runs all testsuites located under the directory /myProject/test/foo/bar1' and '/myProject/test/foo/bar3'
    runtest -a /myProject/test/foo/bar1 -a /myProject/test/foo/bar3
```

Sometimes it may be necessary to skip (ignore) some test suites or tests from test execution.

You can do this easily with the command '-i'.
```
    # runs all testsuites located under the directory /myProject/test' exclusive all tests located under '/myProject/test/foo/bar3'
    runtest -a /myProject/test -i /myProject/test/foo/bar3
```
You can also specify skipping by testsuite name and/or testcase name.
```
    # runs all testsuites located under the directory /myProject/test' exclusive testsuite 'ClassATest' and 'ClassBTest:test_abc'
    runtest -a /myProject/test -i ClassATest -i ClassBTest:test_abc
```

You can also rerun the latest test execution (executed over the UI GdUnit-inspector)
```
    # loads latest GdUnitRunner.cfg and runs the configured tests
    runtest -conf
```

```
    # loads a specific test configuration and runs the configured tests (since v1.0.6)
    runtest -conf <test_config.cfg>
```


The report is stored by default under `/reports`. You can also change the default report directory invidually with the option `-rd [directory]`.
By default, the last 20 reports are saved, older reports are automatically deleted. You can change the number with `-rc [number]`.

See next section.

## Advanced Options
You can control the created reports by advanced options.

```

 [-rd, --report-directory]               Specifies the output directory in which the reports are to be written. The default is res://reports/.
    -rd <directory>

 [-rc, --report-count]                   Specifies how many reports are saved before they are deleted. The default is 20.
    -rc <count>

```
To get an overview of all advaced options use `--help-advanced`.


## Return Codes
The tool ends with a certain return code, where you can check if the tests were completed successfully.
```
0   = all tests success
100 = ends with test failures
101 = ends with test warnings
```

## The Report
The GdUnit command line tool generates a modern HTML and JUnit report with which you can quickly get an overview of the executed tests. 
You can find the reports in the report folder as:
- index.htm - the HTML report
- results.xml - the [JUnit report](https://www.ibm.com/docs/en/developer-for-zos/14.1.0?topic=formats-junit-xml-format){:target="_blank"}


### The HTML report
![](/gdUnit4/assets/images/reports/GdUnit3Report-main.png)


## Report by Path
You can switch between the full list of executed test-suites or the view collected by paths.
![](/gdUnit4/assets/images/reports/GdUnit3Report-sort-by-path.png)
If you click on a test-suite you can view the report for a specific test-suite.

## Select a Testsuite Report
By further selecting the test cases, the test errors can be viewed in the "Failure Report" window.
![](/gdUnit4/assets/images/reports/GdUnit3Report-failure-report.png)

## Logging
If logging is enabled in your project, the report saves the current log and can be viewed by clicking `Logging`.
![](/gdUnit4/assets/images/reports/GdUnit3Report-logging.png)

---
<h4> document version v4.1.0 </h4>