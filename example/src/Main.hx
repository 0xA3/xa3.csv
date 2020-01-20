class Main {
	
	static function main() {
		
		// let's create some data to play with
		final header = "name;year;gender;favorite color";
		final line1 = "Lisa;1981;f;pink";
		final line2 = "Ben;1983;m;blue";
		final line3 = "Sofia;1988;f;orange";
		// and join it to a text string like it would be in a real csv file
		final s = [header, line1, line2, line3].join("\n");

		final csv = xa3.Csv.fromString( "Children grades", s );

		trace( 'The name of the csv is "${csv.name}""' );
		trace( 'ColumnNames are ${csv.columnNames}' );
		
		final favoriteColors = csv.lines.map( line -> line["favorite color"] ).join( "," );
		trace( 'The favorite colors of the children are $favoriteColors' );

	}
}
