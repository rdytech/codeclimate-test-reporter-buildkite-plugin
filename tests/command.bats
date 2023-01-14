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

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "--- :codeclimate: Installing latest cc-test-reporter"
  assert_output --partial "Binary downloaded"
  assert_output --partial "Binary made executable"

  unstub curl
  unstub chmod
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
