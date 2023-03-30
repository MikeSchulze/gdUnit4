---
layout: default
title: Continuous Integration Testing
nav_order: 5
---

# Continuous Integration Testing (CI)

## Definition
Continuous Integration (CI) is a method for automating the integration of code changes made by multiple contributors to a single software project. It is a primary DevOps best practice that allows developers to frequently merge code changes into a central repository where builds and tests are executed. Automated tools are used to confirm the new code is bug-free before integration.

[Wiki - Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration){:target="_blank"}


## Command Line Tool
GdUnit4 provides a command line tool that allows you to automate your testing workflow, including CI.

For more details please show at [Command Line Tool](/gdUnit4/advanced_testing/cmd)

## Deploying for a Specific Godot Version
You can use a Docker image to export Godot Engine games and deploy them to GitLab/GitHub Pages and Itch.io using GitLab CI and GitHub Actions.

Provided by abarichello [Docker image](https://github.com/abarichello/godot-ci){:target="_blank"}


## Howto deploy with GitLab CI
You have to create a new workflow file on GitLab and named it *\.gitlab-ci\.yml*. Please visit [GitLab CI Documentation](https://docs.gitlab.com/ee/ci/yaml/gitlab_ci_yaml.html){:target="_blank"} for more detaild instructions

Thanks to [mzoeller](https://github.com/mzoeller){:target="_blank"} to providing this example workflow.
```
image: barichello/godot-ci:4.0.0

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

gdunit4:
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

## Howto deploy with GitHub Action
To deploy with GitHub Actions, you need to create a new workflow file in the *\.github/workflows/* directory and name it *ci\.yml*. Please visit [GitHub Workflows Page](https://docs.github.com/en/actions/using-workflows)

Example workflow: (Please note that this is just an example and needs to be adapted to your project environment.)
```
name: ci-pr

on:
  pull_request:
    paths-ignore:
      - '**.jpg'
      - '**.png'
      - '**.md'
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:

  unit-test:
    name: "Unit tests on Godot v${{ matrix.godot-version }}-${{ matrix.godot-status-version }} (${{ matrix.name }})"
    runs-on: ${{ matrix.os }}
    timeout-minutes: 15
    continue-on-error: false
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-22.04]
        godot-version: ['4.0']
        godot-status-version: ['stable']
        include:
          - os: ubuntu-22.04
            name: Godot 🐧 Linux Build
            godot-bin-name: 'linux.x86_64'
            godot-executable_path: '~/godot-linux/godot'
            godot-cache-path: '~/godot-linux'
            godot-mono: false
            install-opengl: true

    steps:
      - name: "Checkout GdUnit Repository"
        uses: actions/checkout@v3
        with:
          lfs: true
          submodules: 'recursive'

      - name: "Install Godot ${{ matrix.godot-version }}"
        uses: ./.github/actions/godot-install
        with:
          godot-version: ${{ matrix.godot-version }}
          godot-status-version: ${{ matrix.godot-status-version }}
          godot-bin-name: ${{ matrix.godot-bin-name }}
          godot-cache-path: ${{ matrix.godot-cache-path }}

      - name: "Install OpenGl Drivers"
        if: ${{ matrix.install-opengl && !cancelled() }}
        shell: bash
        run: |
          sudo apt-get -y update
          sudo Xvfb -ac :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
          export DISPLAY=:99
          sudo apt-get install cmake pkg-config
          sudo apt-get install mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev
          sudo apt-get install libglew-dev libglfw3-dev libglm-dev
          sudo apt-get install libao-dev libmpg123-dev
          glxinfo | grep OpenGL

      - name: "Update Godot project cache"
        if: ${{ !cancelled() }}
        timeout-minutes: 1
        continue-on-error: true # we still ignore the timeout, the script is not quit and we run into a timeout
        shell: bash
        run: |
          ${{ matrix.godot-executable_path }} --version
          ${{ matrix.godot-executable_path }} -e --path . -s res://addons/gdUnit4/bin/ProjectScanner.gd --headless

      - name: "Run Unit Tests"
        if: ${{ !cancelled() }}
        timeout-minutes: 10
        uses: ./.github/actions/unit-test
        with:
          godot-bin: ${{ matrix.godot-executable_path }}
          test-includes: "res://addons/gdUnit4/test/"

      - name: "Publish Unit Test Reports"
        if: ${{ !cancelled() }}
        uses: ./.github/actions/publish-test-report
        with:
          report-name: ${{ matrix.godot-build }}${{ matrix.godot-version }}

      - name: "Upload Unit Test Reports"
        if: ${{ !cancelled() }}
        uses: ./.github/actions/upload-test-report
        with:
          report-name: ${{ matrix.godot-build }}${{ matrix.godot-version }}
```
The full set of used GitHub actions used can be found [here](https://github.com/MikeSchulze/gdUnit4/tree/master/.github)


---
<h4> document version v4.1.0 </h4>