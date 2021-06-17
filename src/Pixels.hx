package;

import format.png.*;
import haxe.io.Bytes;
import sys.io.File;

class Pixels {
	public static function getPixels(path:String):{
		data:Bytes,
		width:Int,
		height:Int,
		raw:{data:format.png.Data, header:format.png.Data.Header}
	} {
		var handle = File.read(path);
		var d = new Reader(handle).read();
		var hdr = Tools.getHeader(d);

		handle.close();
		var data = {
			data: Tools.extract32(d),
			width: hdr.width,
			height: hdr.height,
			raw: {data: d, header: hdr}
		}
		return data;
	}

	public static function getPx(rawpx:{data:format.png.Data, header:format.png.Data.Header}, xcoord:Int, ycoord:Int):{
		R:Int,
		G:Int,
		B:Int,
		A:Int
	} {
        var pxl:Int = Tools.extract32(rawpx.data).getInt32(4*(xcoord + ycoord * rawpx.header.width));
        return {
            R:(pxl>>>8)&0xff,
            G:(pxl>>>16)&0xff,
            B:(pxl>>>24)&0xff,
            A:(pxl)&0xff
        }
    }
	public static function setPx(rawpx:{data:Data, header:Data.Header}, pixels:Array<{x:Int, y:Int, clr:Int}>) {
	/**
	 * possible methods:
	 * Iterate through endian coordinates in steps of 1 {offset} until pixels runs out
	 * Iterate through pixels by coordinate until EOI
	 */
	}
}
