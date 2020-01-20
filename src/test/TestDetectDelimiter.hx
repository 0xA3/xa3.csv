package test;

import xa3.Csv;

using buddy.Should;

class TestDetectDelimiter extends buddy.BuddySuite {

	public function new() {
		
		describe( "Test detectDelimiter", {

			it( "should correctly detect the ; delimiter", {
				final cSemi = "column1;column2;column3\nline1 value1;line1 value2;line1 value3/n";
				Csv.detectDelimiter( cSemi ).should.be( ";" );
			});

			it( "should correctly detect the ; delimiter", {
				final cComma = "column1,column2,column3\nline1 value1,line1 value2,line1 value3/n";
				Csv.detectDelimiter( cComma ).should.be( "," );
			});

			it( "should correctly detect the ; delimiter", {
				final cTab = "column1	column2	column3\nline1 value1	line1 value2	line1 value3/n";
				Csv.detectDelimiter( cTab ).should.be( "	" );
			});
		});
	}
}