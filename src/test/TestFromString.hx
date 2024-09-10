package test;

import xa3.Csv;

using buddy.Should;

class TestFromString extends buddy.BuddySuite {

	public function new() {
		
		describe( "Test CSV fromString", {

			final s = "column1;column2;column3\nline1 value1;line1 value2;line1 value3\n";
			
			it( "should read first line as column names", {
				Csv.fromString( "csv name", s ).columnNames.toString().should.be( "[column1,column2,column3]" );
			});

			it( "should have 1 lines", {
				Csv.fromString( "csv name", s ).lines.length.should.be( 1 );
			});

			it( "shuld correctly read column 2 of first line", {
				Csv.fromString( "csv name", s ).lines[0]["column2"].should.be( "line1 value2" );
			});

		});
	}
}