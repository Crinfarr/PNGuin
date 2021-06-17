package;

import format.png.*;
import Pixels;

class Main {
	static function main() {
		if (Sys.args().length == 0) {
			Sys.println('Usage:');
			Sys.println('pnguin encode <something.png> <something (raw file)> <language> <pixel offset> <compression degree>');
			Sys.println('               the file to          the file            the space       the amount of');
			Sys.println('               write into          to encode         between pixels       compression');
			Sys.println('pnguin run <something.png>');
			Sys.println('           the png to run');
			Sys.println('pnguin decode <something.png>');
			Sys.println('              the png to decode');
			Sys.exit(1);
		}
		switch Sys.args()[0] {
			case "run":
			/**
			 * pixel 1: meta
			 * R/G/B/A::0xNN, 0xNN, 0xNN, 0xNN
			 * Byte 1: offset
			 * > the number of unset pixels between info bytes
			 * Byte 2: language
			 * > 0x00: raw text
			 * > 0x01: brainfuck
			 * > (0x02-0xff unset)
			 * Byte 3: compression type
			 * > 0x00: uncompressed
			 * > 0x01: Zlib
			 * > (0x02-0xff unset)
			 * Byte 4: compression degree
			 * > 0x00-0x09: degree
			 */

			case "encode":
			/**
			 * HEX TO STRING:
			 * StringTools.hex(n:Int);
			 * 
			 * STRING TO HEX:
			 * Std.parseInt('0x'+n:String);
			 */

		}
	}
}
