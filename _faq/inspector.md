---
layout: default
title: Inspector
nav_order: 1
---

# The GdUnit Test Inspector/Explorer


## Definition
The GdUnit inspector gives an overview of the currently executed tests and allows you to navigate over them. This allows you to select individual tests and view possible test failures for them. The integrated status and info bar gives you a quick overview of the last test run.<br>

![](/gdUnit3/assets/images/inspector/inspector.png)
- [(1) Button bar](#button-bar)
- [(2) Status bar](#status-bar)
- [(3) Test run overview](#testrun-overview)
- [(4) Failure report](#failure-report)
- [(5) Info bar](#info-bar)



### Button Bar

This bar contains a number of buttons that allow you to open the documentation or configure the execution behavior of GdUnit, as well as restart the last executed tests.<br>
![](/gdUnit3/assets/images/inspector/button-bar.png)

|Button|Description|
|--- | --- |
|(1)| Opens the browser to the GdUnit documentation page |
|(2)| Opens the GdUnit settings |
|(3)| (Re)Run test's (Runtime mode) |
|(4)| (Re)Run debug test's (Debug mode)) |
|(5)| Stops current test run |
|(6)| GdUnit version info |

{% include advice.html 
content="You should first run your tests in debug mode(4) to get the failure line in the report.<br>
Godot does not provide stack trace information when running in runtime mode(3) and therefore will not display an failure line in the report."
%}

### Status Bar

This area gives you information about the current/last test execution, such as the progress and errors/failures found.<br>
With the arrow buttons you can navigate back and forth over found failures.<br>
![](/gdUnit3/assets/images/inspector/status-bar.png)

|Button|Description|
|--- | --- |
|(1)| Test execution progress (indicator of testrun)|
|(2)| Number of errors found |
|(3)| Number of failures found |
|(4)| Navigate to previous failure |
|(5)| Navigate to next failure |

{% include advice.html 
content="Whats the difference between errors and failures?<br>
GdUnit distinguishes between errors and failures. An error is a hard failure such as a test abort or timeout, while a failure is a test error caused by a failed assertion."
%}


### Testrun Overview
This area gives you an overview of all executed/executing tests and their execution status in real time.<br>
Here you can navigate through the tests and view the report for each individual test by selecting it. With a right click you can open a context menu and run the currently selected test or test suite again.<br>
![](/gdUnit3/assets/images/inspector/test-overview.png)

{% include advice.html 
content="By double-clicking, you can jump directly to the test or test error if an failure line reported Debug Mode(4)."
%}

### Failure Report
This area displays the failure report of the currently selected failed test.<br>
GdUnit generates the failure report based on the used assert according to the scheme **expected** vs **current** value.
![](/gdUnit3/assets/images/inspector/report.png)

### Info Bar

This section provides you with information about the total duration of the test execution and about any orphaned nodes found.<br>
![](/gdUnit3/assets/images/inspector/info-bar.png)


---