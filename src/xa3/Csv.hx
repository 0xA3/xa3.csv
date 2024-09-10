package xa3;

using Lambda;
using StringTools;

enum QuoteCells {
	Quoted;
	NotQuoted;
	Autodetect;
}

class Csv {

	public static inline var CHARCODE_NEWLINE:String = String.fromCharCode(10);
	public static inline var CR:String = String.fromCharCode(13);
	
	public final name:String;
	public final columnNames:Array<String>;
	public final columnMap:Map<String,Int>;
	public final lines:Array<Map<String,String>>;

	public function new( name:String, columnNames:Array<String>, columnMap:Map<String,Int>, lines:Array<Map<String,String>> ) {
		
		this.name = name;
		this.columnNames = columnNames;
		this.columnMap = columnMap;
		this.lines = lines;
	}

	public static function fromString( name:String, content:String, quoteCells = Autodetect, inputDelimiter = "" ):Csv {

		final delimiter = inputDelimiter == "" ? detectDelimiter( content ) : inputDelimiter;
		
		final decoded = decode( content, quoteCells, delimiter );
		final columnNames = decoded.length == 0 ? [] : decoded[0];
		
		return fromColumnAndStringArrays( name, columnNames, decoded.slice( 1 ), inputDelimiter );
	}

	public static function fromColumnAndStringArrays( name:String, columnNames:Array<String>, decodedLines:Array<Array<String>>, inputDelimiter = "" ):Csv {

		final columnMap:Map<String,Int> = [];
		for( i in 0...columnNames.length ) columnMap.set( columnNames[i], i );
		
		final lines = decodedLines.map( decodedLine -> [ for( i in 0...columnNames.length ) columnNames[i] => decodedLine[i] ]);
		
		final nonEmptyLines = filterEmptyLines( lines );

		return new Csv( name, columnNames, columnMap, nonEmptyLines );
	}
	
	public static function fromCsvRecords( records:Array<format.csv.Data.Record>, name = "noname", trimCells = true, isCaseSensitive = true ):xa3.Csv {

		final columnNames = records.length == 0 ? [] : records[0].map( columnName -> isCaseSensitive ? columnName : columnName.toLowerCase());
		
		final columnMap:Map<String,Int> = [];
		for( i in 0...columnNames.length ) columnMap.set( isCaseSensitive ? columnNames[i] : columnNames[i].toLowerCase(), i );

		final dataRecords = records.slice( 1 );
		final trimmedDataRecords = trimCells ? dataRecords.map( line -> line.map( cell -> cell.trim())) : dataRecords;
		final lines = trimmedDataRecords.map( columns -> [ for( i in 0...columnNames.length ) columnNames[i] => columns[i] ]);

		final nonEmptyLines = filterEmptyLines( lines );
		return new xa3.Csv( name, columnNames, columnMap, nonEmptyLines );

	}

	public static function fromFiles( files:Map<String, String> ):Array<Csv> {

		final filenames = [ for( filename in files.keys()) filename ];
		final csvs:Array<Csv> = filenames.map( filename -> Csv.fromString( filename, files[filename] ));

		return csvs;
	}

	static function filterEmptyLines( lines:Array<Map<String, String>> ):Array<Map<String, String>> {

		return lines.filter( line -> {
			for( cell in line ) if( cell != "" ) return true;
			return false;
		});
	}
	
	public static function decode( s:String, quoteCells = Autodetect, delimiter = ";", trimCells = true ):Array<Array<String>> {
		
		final isQuoted = switch quoteCells {
			case Quoted: true;
			case NotQuoted: false;
			case Autodetect: s.charAt( 0 ) == '"' ? true : false;
		}

		if( s.indexOf( CR ) != -1 ) s = s.replace( CR, "" );
		final lines = s.split( CHARCODE_NEWLINE );

		final linesWithContent = lines.filter( line -> line.length > 1 );
		final linesArray = linesWithContent.map( line -> line.split( delimiter ));
		final trimmedLinesArray = trimCells ? linesArray.map( line -> line.map( cell -> cell.trim())) : linesArray;

		return isQuoted ? trimmedLinesArray.map( lineArray -> lineArray.map( s -> removeQuotes( s ))) : trimmedLinesArray;  // TODO implement proper CSV parsing
	}

	static function removeQuotes( s:String ) {
		final startChar = s.charAt( 0 ) == '"' ? 1 : 0;
		final endChar = s.charAt( s.length - 1 ) == '"' ? s.length - 1 : s.length;
		return s.substring( startChar, endChar );
	}

	public static function encode( a:Array<Array<String>>, delimiter = ";" ):String {
		return a.fold(( line:Array<String>, sum:String ) -> sum + line.join( ";" ) + "\n", "" );
	}

	public static function detectDelimiter( s:String ):String {
		
		var delimiter = ";";
		for( i in 0...s.length ) {

			switch s.charAt( i ) {
				case ";": break;
				case ",":
					delimiter = ",";
					break;
				case "	":
					delimiter = "	";
					break;
			}
		}

		return delimiter;
	}

	public function toString():String {
		return '$columnMap $lines';
	}
}
