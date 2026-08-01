---
description: diginatu's personal global guidelines
---

# Global prompt

This file is at `~/dotfiles/ai/apm/personal/.apm/instructions/personal.instructions.md` and is given every time (installed via APM).
You don't need to add content in this file to the project prompt.

## Guidelines

Basically, prefer to follow the TDD approach.
* Create tests before writing code
* Confirm that tests fail
* Write code to make tests pass
* Refactor code if necessary
* Update memory files and documents (this file, README.md and repository local AGENTS.md or CLAUDE.md) if necessary
* Repeat the process

When you cannot write tests first (e.g. implementation already exists), you MUST still verify that each new test would fail against a broken implementation. Briefly mutate the implementation (return wrong value, remove a clamp/branch, change a constant, etc.), run the affected test, confirm it fails, then revert. Do this for every behavior the test is meant to guard. A passing test proves nothing unless you have seen it fail. Report the mutation-catch evidence alongside the final green result, not just the green result.
日本語の場合はタメ口で返答する。

## Environment

* `rm` is disabled by aliasing. Use \rm instead.
* Sandbox permission errors: report and ask, don't attempt workarounds
