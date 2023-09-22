---
layout: default
title: Continuous Integration Testing
nav_order: 10
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
{% raw %}
```yaml
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
{% endraw %}

## Howto deploy with GitHub Action
To deploy with GitHub Actions, you need to create a new workflow file in the *\.github/workflows/* directory and name it *ci\.yml*. Please visit [GitHub Workflows Page](https://docs.github.com/en/actions/using-workflows)

Example workflow: (Please note that this is just an example and needs to be adapted to your project environment.)
{% raw %}
```yaml
name: ci-pr-example
run-name: ${{ github.head_ref || github.ref_name }}-ci-pr-example

on:
  pull_request:
    paths-ignore:
      - '**.yml'
      - '**.md'
  workflow_dispatch:


concurrency:
  group: ci-pr-example${{ github.event.number }}
  cancel-in-progress: true


jobs:
  unit-test:
    strategy:
      fail-fast: false
      matrix:
        godot-version: ['4.1.1'] # Insert here the Godot version you want to run your tests with

    name: "CI Unit Test 🐧 v${{ matrix.godot-version }}"
    runs-on: 'ubuntu-22.04'
    timeout-minutes: 10 # The overall timeout

    steps:
      - name: "Checkout your Repository"
        uses: actions/checkout@v3
        with:
          lfs: true

      - name: "🐧Download and Install Godot ${{ matrix.godot-version }}"
        continue-on-error: false
        shell: bash
        run: |
          GODOT_HOME=$HOME/bin
          GODOT_BIN=$GODOT_HOME/godot
          mkdir -p $GODOT_HOME
          chmod 770 $GODOT_HOME
          GODOT_CONF_PATH=$HOME/.config/godot
          if [ ! -d $GODOT_CONF_PATH ]; then
            mkdir -p $GODOT_CONF_PATH
            chmod 770 $GODOT_CONF_PATH
          fi

          GODOT_PACKAGE=Godot_v${{ matrix.godot-version }}-stable_linux.x86_64
          wget https://github.com/godotengine/godot/releases/download/${{ matrix.godot-version }}-stable/$GODOT_PACKAGE.zip -P ${{ runner.temp }}
          unzip ${{ runner.temp }}/$GODOT_PACKAGE.zip -d $GODOT_HOME
          mv $GODOT_HOME/$GODOT_PACKAGE $GODOT_BIN
          chmod u+x $GODOT_BIN
          echo "GODOT_HOME=$GODOT_HOME" >> "$GITHUB_ENV"
          echo "GODOT_BIN=$GODOT_BIN" >> "$GITHUB_ENV"

      # We need to update the project before running tests, Godot has actually issues with loading the plugin
      - name: "Update Project"
        if: ${{ !cancelled() }}
        timeout-minutes: 1
        continue-on-error: true # we still ignore the timeout, the script is not quit and we run into a timeout
        shell: bash
        run: |
          ${{ env.GODOT_BIN }} -e --path . -s res://addons/gdUnit4/bin/ProjectScanner.gd --headless --audio-driver Dummy

      - name: "Run Unit Tests"
        if: ${{ !cancelled() }}
        timeout-minutes: 8 # set your expected test timeout
        env:
          GODOT_BIN: ${{ env.GODOT_BIN }}
        shell: bash
        run: |
          chmod +x ./addons/gdUnit4/runtest.sh
          xvfb-run --auto-servernum ./addons/gdUnit4/runtest.sh --add "res://test" --audio-driver Dummy --display-driver x11 --rendering-driver opengl3 --screen 0 --continue

      - name: "Publish Test Report"
        if: ${{ always() }}
        uses: dorny/test-reporter@v1.6.0
        with:
          name: "test_report_${{ matrix.godot-version }}"
          path: "reports/**/results.xml"
          reporter: java-junit
          fail-on-error: 'false'

      - name: "Upload Unit Test Reports"
        if: ${{ always() }}
        uses: actions/upload-artifact@v3
        with:
          name: "test_report_${{ matrix.godot-version }}"
          path: |
            reports/**
            /var/lib/systemd/coredump/**
            /var/log/syslog

  finalize:
    if: ${{ !cancelled() }}
    runs-on: ubuntu-latest
    name: Final Results
    needs: [unit-test]
    steps:
      - run: exit 1
        if: >-
          ${{
              contains(needs.*.result, 'failure')
            || contains(needs.*.result, 'cancelled')
          }}
```
{% endraw %}
The full set of used GitHub actions used can be found [here](https://github.com/MikeSchulze/gdUnit4/blob/master/.github/workflows/ci-pr-example.yml)


---
<h4> document version v4.1.1 </h4>
