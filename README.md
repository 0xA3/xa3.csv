## A CSV format library

Converts csv data to an easy to use format.  
Uses very simple parser for csv files. Autodetects delimiter: Space, Semikolon or Tab.  
For more complex csv files optionally uses https://github.com/jonasmalacofilho/csv library for parsing.

## Simple Example

```haxe
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
```

## Complex Example

In this example the delimiter for the cells is a comma and there are also commas in the quotes. Because of this the parsing has to be done with the format.csv.Reader library and the resulting "csvRecords" are then converted to xa3.Csv.

```haxe
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
```


## Issues

Found any bug? Please create a new issue.
