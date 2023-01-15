#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Installs the latest reporter binary" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_FORMAT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_REPORT="false"

  stub curl "--location --silent --output ./cc-test-reporter \"https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64\" : echo 'Binary downloaded'"
  stub chmod "+x ./cc-test-reporter : echo 'Binary made executable'"
  stub cc-test-reporter "-v : echo 'Code Climate Test Reporter version'"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Installing latest cc-test-reporter"
  assert_output --partial "Binary downloaded"
  assert_output --partial "Binary made executable"
  assert_output --partial "Code Climate Test Reporter version"

  unstub curl
  unstub chmod
  unstub cc-test-reporter
}

@test "Downloads artifacts" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_FORMAT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_REPORT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"

  stub buildkite-agent "artifact download coverage/.resultset.json ./ : echo 'Artifacts downloaded'"
  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :buildkite: Downloading artifact"
  assert_output --partial "Artifacts downloaded"

  unstub buildkite-agent
}

@test "Formats files" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_REPORT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INPUT_TYPE="simplecov"

  stub cc-test-reporter "format-coverage --input-type simplecov --output coverage/codeclimate.1.json coverage/.resultset.json : echo 'Artifacts formatted'"
  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Formatting coverage"
  assert_output --partial "cc-test-reporter format-coverage --input-type simplecov --output coverage/codeclimate.1.json coverage/.resultset.json"
  assert_output --partial "Artifacts formatted"

  unstub cc-test-reporter
}

@test "Formats files with prefix" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_REPORT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INPUT_TYPE="simplecov"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_PREFIX="/app"

  stub cc-test-reporter "format-coverage --input-type simplecov --output coverage/codeclimate.1.json --prefix /app coverage/.resultset.json : echo 'Artifacts formatted'"
  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Formatting coverage"
  assert_output --partial "cc-test-reporter format-coverage --input-type simplecov --output coverage/codeclimate.1.json --prefix /app coverage/.resultset.json"
  assert_output --partial "Artifacts formatted"

  unstub cc-test-reporter
}

@test "Formats files with add-prefix" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_REPORT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INPUT_TYPE="simplecov"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ADD_PREFIX="/path"

  stub cc-test-reporter "format-coverage --input-type simplecov --output coverage/codeclimate.1.json --add-prefix /path coverage/.resultset.json : echo 'Artifacts formatted'"
  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Formatting coverage"
  assert_output --partial "cc-test-reporter format-coverage --input-type simplecov --output coverage/codeclimate.1.json --add-prefix /path coverage/.resultset.json"
  assert_output --partial "Artifacts formatted"

  unstub cc-test-reporter
}

@test "Reports coverage" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_FORMAT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INPUT_TYPE="simplecov"

  stub ls "\* : echo 'listing inputs'"
  stub cc-test-reporter \
    "sum-coverage coverage/codeclimate.*.json : echo 'Coverage summed'" \
    "upload-coverage : echo 'Coverage uploaded'"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Reporting coverage"
  assert_output --partial "Coverage summed"
  assert_output --partial "Coverage uploaded"

  unstub cc-test-reporter
  unstub ls
}

@test "Reports coverage with 3 parts" {
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INSTALL="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_DOWNLOAD="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_FORMAT="false"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_ARTIFACT="coverage/.resultset.json"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_INPUT_TYPE="simplecov"
  export BUILDKITE_PLUGIN_CODECLIMATE_TEST_REPORTER_PARTS="3"

  stub ls "\* : echo 'listing inputs'"
  stub cc-test-reporter \
    "sum-coverage --parts 3 coverage/codeclimate.*.json : echo 'Coverage summed'" \
    "upload-coverage : echo 'Coverage uploaded'"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Reporting coverage"
  assert_output --partial "Coverage summed"
  assert_output --partial "Coverage uploaded"

  unstub cc-test-reporter
  unstub ls
}
