// GdUnit generated TestSuite
using Godot;
using GdUnit4;
using System;

namespace GdUnit4
{
	using static Assertions;
	using static Utils;
	
	[TestSuite]
	public partial class GdUnit4MonoApiTest
	{
		// TestSuite generated from
		private const string sourceClazzPath = "d:/develop/workspace/gdUnit4/addons/gdUnit4/src/mono/GdUnit4MonoApi.cs";
		
		[TestCase]
		public void IsTestSuite()
		{
			AssertThat(GdUnit4MonoAPI.IsTestSuite("res://addons/gdUnit4/src/mono/GdUnit4MonoApi.cs")).IsFalse();
			AssertThat(GdUnit4MonoAPI.IsTestSuite("res://addons/gdUnit4/test/mono/GdUnit4MonoApiTest.cs")).IsTrue();
		}
		
		[TestCase]
		public void IsFoo()
		{
			AssertThat(true).IsFalse();
		}
	}
}
