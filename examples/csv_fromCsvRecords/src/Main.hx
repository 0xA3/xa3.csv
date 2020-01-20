class Main {
	
	static function main() {
		
		// let's create some data to play with
		final header = '"name","favorite quote"';
		final line1 = '"Lisa","Never mind what your friend said, if you wanna have fun with your girl try dancing"';
		final line2 = '"Ben","Well, duh shes rachet."';
		final line3 = '"Sofia","Here, take some tums!"';
		// and join it to a text string like it would be in a real csv file
		final s = [header, line1, line2, line3].join("\n");

		final csvRecords = format.csv.Reader.parseCsv( s );
		final csv = xa3.Csv.fromCsvRecords( csvRecords, "Favorite quotes" );

		trace( 'The name of the csv is "${csv.name}""' );
		trace( 'ColumnNames are ${csv.columnNames}' );
		
		final favoriteColors = csv.lines.map( line -> line["favorite quote"] ).map( quote -> '"$quote"' ).join( "," );
		trace( 'The favorite quotes of the children are $favoriteColors' );

	}
}
