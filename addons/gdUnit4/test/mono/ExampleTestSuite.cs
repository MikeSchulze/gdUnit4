// GdUnit generated TestSuite
using Godot;
using GdUnit4;
using System;

namespace GdUnit4
{
	using static Assertions;
	using static Utils;
	
	[TestSuite]
	public partial class ExampleTestSuite
	{
		[TestCase]
		public void IsFoo()
		{
			AssertThat("Foo").IsEqual("Foo");
		}
		
		[TestCase('A', Variant.Type.Int)]
		[TestCase(SByte.MaxValue, Variant.Type.Int)]
		[TestCase(Byte.MaxValue, Variant.Type.Int)]
		[TestCase(Int16.MaxValue, Variant.Type.Int)]
		[TestCase(UInt16.MaxValue, Variant.Type.Int)]
		[TestCase(Int32.MaxValue, Variant.Type.Int)]
		[TestCase(UInt32.MaxValue, Variant.Type.Int)]
		[TestCase(Int64.MaxValue, Variant.Type.Int)]
		[TestCase(UInt64.MaxValue, Variant.Type.Int)]
		[TestCase(Single.MaxValue, Variant.Type.Float)]
		[TestCase(Double.MaxValue, Variant.Type.Float)]
		[TestCase("HalloWorld", Variant.Type.String)]
		[TestCase(true, Variant.Type.Bool)]
		public void ParameterizedTest(dynamic? value, Variant.Type type) {
			Godot.Variant v = value == null ? new Variant() : Godot.Variant.CreateFrom(value);
			AssertObject(v.VariantType).IsEqual(type);
		}
	}
}
