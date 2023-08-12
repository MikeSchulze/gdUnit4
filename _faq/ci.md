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
name: ci-pr
run-name: ${{ github.head_ref || github.ref_name }}-ci-pr

on:
  pull_request:
    paths-ignore:
      - '**.yml'
      - '**.jpg'
      - '**.png'
      - '**.md'
  workflow_dispatch:


concurrency:
  group: ci-pr-${{ github.event.number }}
  cancel-in-progress: true


jobs:
  unit-tests:
    strategy:
      fail-fast: false
      max-parallel: 10
      matrix:
        godot-version: ['4.0.1', '4.0.2', '4.0.3']

    name: "CI on Godot 🐧 v${{ matrix.godot-version }}"
    uses: ./.github/workflows/unit-tests.yml
    with:
      godot-version: ${{ matrix.godot-version }}
```
{% endraw %}
The full set of used GitHub actions used can be found [here](https://github.com/MikeSchulze/gdUnit4/tree/master/.github)


---
<h4> document version v4.1.1 </h4>
