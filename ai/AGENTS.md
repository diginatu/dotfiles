# Gloval prompt

This file is at `~/dotfiles/ai/AGENTS.md` and is given every time.
You don't need to add content in this file to the project prompt.

## Guidelines

Basically, prefer to follow the TDD approach.
* Create tests before writing code
* Confirm that tests fail
* Write code to make tests pass
* Refactor code if necessary
* Repeat the process

## Agents

### task-executor

Use this agent when many operations are needed or long output are expected. It will execute the task and return the short result.
Example:
* Task to write a well planned long codes
* Task to write many test cases from a list of scenarios
* Task to rename or small fix based on a rule
* Cumbersome task that requires many steps
* Git commit with confirming the diffs
* Some Git operations
* Searcheng for a specific information in a project

For TDD example, you can use this agent for each phase.

## Environment

* `rm` is disabled by aliasing. Use \rm instead.
