# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name TestSuite
extends RefCounted

var _assertion_failed: bool = false

func print_newline():
	printerr()

func print_error(s: String):
	push_error(s)

## Asserts that `what` is `true`, but does not abort the test. Returns `what` so you can return
## early from the test function if the assertion failed.
func assert_that(what: bool, message: String = "") -> bool:
	if what:
		return true

	_assertion_failed = true

	print_newline() # previous line not yet broken
	if message:
		print_error("GDScript assertion failed:  %s" % message)
	else:
		print_error("GDScript assertion failed.")
	return false

func assert_eq(left, right, message: String = "") -> bool:
	if left == right:
		return true

	_assertion_failed = true

	print_newline() # previous line not yet broken
	if message:
		print_error("GDScript assertion failed:  %s\n  left: %s\n right: %s" % [message, left, right])
	else:
		print_error("GDScript assertion failed:  `(left == right)`\n  left: %s\n right: %s" % [left, right])
	return false

# Disable error message printing from godot. 
#
# Error messages are always re-enabled by the rust test runner after a test has been run.
func disable_error_messages():
	Engine.print_error_messages = false

# Enable error message printing from godot. 
# 
# Error messages are always re-enabled by the rust test runner after a test has been run.
func enable_error_messages():
	Engine.print_error_messages = true

# Asserts that the test failed to reach this point. You should disable error messages before running code 
# that is expected to print an error message that would otherwise cause the CI to report failure.
func assert_fail(message: String = "") -> bool:
	_assertion_failed = true

	print_newline()
	if message:
		print_error("Test execution should have failed: %s" % [message])
	else:
		print_error("Test execution should have failed")

	return false