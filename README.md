# codeclimate-test-reporter-buildkite-plugin

A BuildKite plugin

https://buildkite.com/docs/agent/plugins

to report coverage with the Code Climate test reporter

https://github.com/codeclimate/test-reporter

Plugin can handle single, or multiple (parallel), tests.

Also see: https://docs.codeclimate.com/docs/configuring-test-coverage

## Usage:

This plugin will download build artifact(s) generated by a previous step, compile and report to Code Climate.

Note: It runs as a [Command step](https://buildkite.com/docs/pipelines/command-step), but the command is ignored.

```
steps:
  - command: "Report Code Climate Coverage"
    label: ":codeclimate: Report coverage"
    plugins:
      jobready/codeclimate-test-reporter#v1.0.0:
        prefix: /app
        artifact: "coverage/.resultset.json"
        input_type: simplecov
        version: "0.4.3"
    env:
      CC_TEST_REPORTER_ID:
```

## Configuration

### `artifact` (required)

Passed through as the `[COVERAGE FILE]` argument to

https://github.com/codeclimate/test-reporter/blob/master/man/cc-test-reporter-format-coverage.1.md

Example: `coverage/.resultset.json`

Would be the artifact path uploaded by a previous step. Use a wildcard for multiple artifacts

Example: `coverage/.resultset*.json`

### `input_type` (required)

Passed through to the --input-type option of

https://github.com/codeclimate/test-reporter/blob/master/man/cc-test-reporter-format-coverage.1.md

Example: `simplecov`

### `prefix` (optional)

Passed through to the --prefix option of

https://github.com/codeclimate/test-reporter/blob/master/man/cc-test-reporter-format-coverage.1.md

Example: `/app`

If the coverage was generated from a Docker container, prefix would be the Dockerfile `WORKDIR`.

### `version` (optional)

The preferred version of the test reporter to download. Defaults to `latest`.

Example: `0.4.3`

### `parts` (optional)

If you expect multiple partial coverage artifacts, set this value to enforce a check. If not set the plugin will proceed with any/all provided parts.

Example: `2`

### `save_coverage` (optional)

Set to true to save the coverage upload file as a BuildKite artifact. For debugging.

Example: `true`

### `CC_TEST_REPORTER_ID` (required)

The `CC_TEST_REPORTER_ID` environment variable must be configured.
