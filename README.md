# action-controlrepo-pdk-tests

This action runs `pdk validate` and `pdk test unit` on your codebase and fails the step if there are test failures.

## Usage

To use the action add the following step to your workflow file (e.g. `.github/workflows/pdk-tests.yml`)

```yaml
name: Run pdk on control repo

on:
  - push
  - pull_request
  - workflow_dispatch

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Clone repository
      uses: actions/checkout@v3

    - name: Run unit tests
      uses: newcastleuniversity/action-controlrepo-pdk-test-unit@main
      with:
          # A string indicating the Puppet version to validate against, such as "5.4.2" or "5.5".
          puppet-version: # optional
          # A string indicating the PE version to validate against, such as "2017.3.5" or "2018.1".
          pe-version: # optional
          # A string indicating the path within your controlrepo that contains your profiles and roles modules.
          site-module-path: # optional
```
