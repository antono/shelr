Feature: Recording shell

  In order to impress the world
  As a `shelr` user
  I would like to record my terminal

  Background:
    Given shelr backend is script

  Scenario: Basic recording
    When I run `shelr record` interactively
    And I type "test screencast"
    And I type "ls"
    # FIXME: wtf with nested processes?
    And I type "exit"
    Then the stdout should contain "Provide HUMAN NAME for Your record: "
    And the stdout should contain "Press Ctrl+D or 'exit' to finish recording"
    And the stdout should contain "Replay  : shelr play last"
    And the stdout should contain "Publish : shelr push last"
    And the stdout should contain "Your session started"
