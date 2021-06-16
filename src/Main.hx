package;

import format.png.*;
import sys.io.File;
import haxe.io.Bytes;

class Main {
	public static function main() {
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
				var pxls = getPixels(Sys.args()[1]);
				var meta:{
					offset:Int,
					language:String,
					compression:String,
					degree:Int,
					raw_ARGB:String
				} = {
					offset: 0,
					language: "raw",
					compression: "none",
					degree: 0,
					raw_ARGB: "0x00"
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
				var a = pxls.data.getInt32(0);

				// get meta pixel
				// > offset
				meta.offset = (a >>> 16) & 0xff;
				// > language
				switch ((a >>> 8) & 0xff) {
					case 0x00:
						meta.language = "raw";
					case 0x01:
						meta.language = "bf";
					default:
						Sys.println("unknown language meta");
						// Sys.exit(1);
				}
				// > Compression
				switch ((a) & 0xff) {
					case 0x00:
						meta.compression = 'none';
					case 0x01:
						meta.compression = 'zlib';
					default:
						Sys.println("unknown compression meta");
						// Sys.exit(1);
				}
				// > Compression amount
				meta.degree = (a >>> 24);
				// > raw data
				meta.raw_ARGB = StringTools.hex(a);

				Sys.println(meta);
				Sys.println(Math.floor(pxls.width / meta.offset) + " daxels with offset " + meta.offset);
			case "encode":
				if (Sys.args().length != 4) {
					Sys.println("invalid argument count");
					Sys.println("Run PNGuin with no arguments for help");
					Sys.exit(1);
				}
				var pxls = getPixels(Sys.args()[1]);
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

	private static function getPixels(path:String):{
		data:Bytes,
		width:Int,
		height:Int,
		raw: {data:format.png.Data, header: format.png.Data.Header}
	} {
		var handle = File.read(path);
		var d = new Reader(handle).read();
		var hdr = Tools.getHeader(d);

		handle.close();
		return {
			data: Tools.extract32(d),
			width: hdr.width,
			height: hdr.height,
			raw: {data: d, header: hdr}
		}
	}
}
