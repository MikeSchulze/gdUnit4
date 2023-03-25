---
layout: default
title: Continuous Integration Testing
nav_order: 4
---

# Continuous Integration Testing (CI)

### Definition
Continuous Integration (CI) is a method for automating the integration of code changes made by multiple contributors to a single software project. It is a primary DevOps best practice that allows developers to frequently merge code changes into a central repository where builds and tests are executed. Automated tools are used to confirm the new code is bug-free before integration.

[Wiki - Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration){:target="_blank"}


### Command Line Tool
GdUnit4 provides a tool that allows you to deploy your CI  workflow.

For more details please show at [Command Line Tool](/gdUnit4/advanced_testing/cmd)

### Howto deploy for a specific Godot version
Using Docker image to export Godot Engine games and deploy to GitLab/GitHub Pages and Itch.io using GitLab CI and GitHub Actions.

Provided by abarichello [Docker image](https://github.com/abarichello/godot-ci){:target="_blank"}


### Howto deploy with GitLab CI 
You have to create a new workflow file on GitLab and named it *\.gitlab-ci\.yml*. Please visit [GitLab CI Documentation](https://docs.gitlab.com/ee/ci/yaml/gitlab_ci_yaml.html){:target="_blank"} for more detaild instructions

Thanks to [mzoeller](https://github.com/mzoeller){:target="_blank"} to providing this example workflow.
```
image: barichello/godot-ci:3.4.4

cache:
  key: import-assets
  paths:
    - .import/

stages:
  - export
  - tests
  - deploy

variables:
  EXPORT_NAME: $CI_PROJECT_NAME
  GIT_SUBMODULE_STRATEGY: recursive

linux:
  stage: export
  script:
    - mkdir -v -p build/linux
    - godot -v --export "Linux/X11" build/linux/$EXPORT_NAME.x86_64
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/linux

gdunit3:
  stage: tests
  dependencies:
    - linux
  script:
    - export GODOT_BIN=/usr/local/bin/godot
    - ./runtest.sh -a ./test || if [ $? -eq 101 ]; then echo "warnings"; elif [ $? -eq 0 ]; then echo "success"; else exit 1; fi
  artifacts:
    when: always
    reports:
      junit: ./reports/report_1/results.xml
```

### Howto deploy with GitHub Action
You have to create a new workflow file on GitHub *\.github/workflows/* and named it *ci\.yml*. Please visit [GitHub Workflows Page](https://docs.github.com/en/actions/using-workflows){:target="_blank"} for more detaild instructions

Example workflow:
```
name: CI Godot 3.4.4

on:
  push:
    paths-ignore:
      - '**.yml'
      - '**.jpg'
      - '**.png'
      - '**.md'
  workflow_dispatch:

jobs:
  testing:
    name: CI Godot 3.4.4
    runs-on: ubuntu-latest
    continue-on-error: true
    container:
      image: barichello/godot-ci:3.4.4

    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          lfs: true
          submodules: 'recursive'

      - name: Run Selftest
        timeout-minutes: 10
        env:
          GODOT_BIN: "/usr/local/bin/godot"
        shell: bash
        run: ./runtest.sh --selftest

      - name: Publish Test Reports
        if: always()
        uses: ./.github/actions/publish-test-report
        with:
          report-name: Test Report (3.4.4)

      - name: Collect Test Artifacts
        if: always()
        uses: actions/upload-artifact@v2
        with:
          name: Report (3.4.4)
          path: reports/**
```