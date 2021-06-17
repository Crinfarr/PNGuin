package;

import format.png.Tools;
import haxe.zip.Uncompress;
import haxe.zip.Compress;
import sys.io.File;
import Pixels;
import haxe.io.Bytes;

class PNGuinCore {
	public static function encode(imagePath:String, filePath:String, compDegree:Int, offset:Int) {
		/**
		 * PHASE 0:
		 * Error detection
		 */
		if (offset <= 0) {
			Sys.println('Error: offset <= 0! try again with offset >=1.');
			Sys.exit(1);
		}

		/**
		 * BEGIN PHASE 1:
		 * String compress and encode
		 */
		Sys.println(Date.now() + '> Begin phase 1: String Encode');

		var txt:haxe.io.Bytes = File.read(filePath, false).readAll();

		Sys.println("text byte length: " + txt.length + 'b');
		txt = Compress.run(txt, compDegree);
		Sys.println("compressed length: " + txt.length + 'b');
		// txt to pixel arr
		var coded:Array<String> = [];
		Sys.println('encoding...');
		for (char in 0...txt.length) {
			coded.push(txt.sub(char, 1).toHex());
			Sys.print(Math.floor((char / txt.length) * 10000) / 100 + '%\r');
		}
		Sys.println('100%    ');

		/**
		 * BEGIN PHASE 2
		 * convert arbitrary text into pixels
		 */
		Sys.println(Date.now() + '> Begin phase 2: Byte to Pixel conversion');

		var pix:Array<Pixel> = [
			{
				// METADAXEL
				R: offset,
				G: 0x00,
				B: 0x01,
				A: compDegree
			}
		];

		while (coded.length % 4 != 0) {
			coded.push('00');
			Sys.print('padding final pixel...\r');
		}
		Sys.println('padding final pixel...Done');
		var v = coded.length;
		while (coded.length != 0) {
            //TODO: PxPS, ETA
			Sys.print('Converting to rgba... ${Math.floor(((v-coded.length)/v)*10000)/100}% (${coded.length} remaining)    \r');
			pix.push({
				R: Std.parseInt(coded.splice(0, 1)[0]),
				G: Std.parseInt(coded.splice(0, 1)[0]),
				B: Std.parseInt(coded.splice(0, 1)[0]),
				A: Std.parseInt(coded.splice(0, 1)[0])
			});
		}
		Sys.println('Converting to rgba...Done');

		/**
		 * BEGIN PHASE 3
		 * convert pixel array into coordinated image mask
		 */
		Sys.println(Date.now() + '> Begin phase 3: Pixel array mapping');

		var img:Pixels.PxDataPlus = Pixels.read(imagePath);

		// x and y coordinates
		var CIM:Array<{x:Int, y:Int, clr:Int}> = [];
		var xco:Int = 0;
		var yco:Int = 0;
		var i:Int = 0;
		Sys.println('mapping ${pix.length} pixels...');
		while (true) {
			if (pix.length == 0)
				break;
			if (xco > img.width) {
				xco = 0;
				yco ++;
			}
			if (yco >= img.height) {
				Sys.println('Too much data or too much offset! try again with a lower offset.');
				Sys.exit(1);
			}
			var pxl:Pixel = pix.splice(0, 1)[0];
			CIM.push({
				x: xco,
				y: yco,
				clr: Std.parseInt('0x${pxl.A}${pxl.R}${pxl.G}${pxl.B}')
			});
			Sys.print('Pixels remaining: ${pix.length}       \r');
            xco+=offset;
		}
		Sys.println('Pixels fully encoded                    ');
		/**
		 * BEGIN PHASE 4
		 * Overlay mask
		 */
         Sys.println(Date.now()+'> Begin phase 4: overlay mask on image');
         var complete = Pixels.setPx(img.raw, CIM);
         return complete;
	}
}
