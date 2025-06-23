package test;

import xa3.Csv;

using buddy.Should;

class TestCheckColumnNames extends buddy.BuddySuite {

	public function new() {
		
		describe( "Test checkColumnNames", {

			final s = "column1;column2;column3\nline1 value1;line1 value2;line1 value3/n";

			it( "should detect all the column names", {
				Csv.fromString( "csv name", s ).checkColumnNames( ["column1", "column2", "column3"] ).should.be( true );
			});
			
			it( "should throw an error if a column is missing", {
				Csv.fromString( "csv name", s ).checkColumnNames.bind( ["column4"] ).should.throwValue("Error in csv csv name: Column column4 not found");
			});

		});
	}
}