@tool
extends Node

signal gdunit_client_connected(client_id :int)
signal gdunit_client_disconnected(client_id :int)
signal gdunit_client_terminated()

signal gdunit_event(event :GdUnitEvent)
signal gdunit_add_test_suite(test_suite :GdUnitTestSuiteDto)
signal gdunit_message(message :String)
