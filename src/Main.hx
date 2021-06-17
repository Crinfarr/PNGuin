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
			Sys.exit(1);
		}
		switch Sys.args()[0] {
			case "run":
				if (Sys.args().length != 2) {
					Sys.println("invalid argument count");
					Sys.println("Run PNGuin with no arguments for help");
					Sys.exit(1);
				}
				var pxls = Pixels.getPixels(Sys.args()[1]);
				var meta:{
					offset:Int,
					language:String,
					compression:String,
					degree:Int,
					raw_ARGB:String
				}

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
				var pixel = Pixels.getPx(pxls.raw, 0, 0);//get pixel at 0,0
				
			case "encode":
				if (Sys.args().length != 4) {
					Sys.println("invalid argument count");
					Sys.println("Run PNGuin with no arguments for help");
					Sys.exit(1);
				}
				var pxls = Pixels.getPixels(Sys.args()[1]);
				var meta = {offset: Sys.args()[3]};

				/**
				 * HEX TO STRING:
				 * StringTools.hex(n:Int);
				 * 
				 * STRING TO HEX:
				 * Std.parseInt('0x'+n:String);
				 * 
				 * LITTLE ENDIAN ENCODING: 4 * (xcoord + ycoord * width)
				 * (not sure why)
				 * //TODO: study endianness (secondary)
				 */
				// TODO: create encode function, maybe add json support for command
		}
	}
}
