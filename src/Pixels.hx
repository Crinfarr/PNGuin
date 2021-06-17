package;

import format.png.*;
import haxe.io.Bytes;
import sys.io.File;

private typedef RawPxData = {
	data:format.png.Data,
	header:format.png.Data.Header
}
class Pixels {
	public static function read(path:String):{
		data:Bytes,
		width:Int,
		height:Int,
		raw:RawPxData
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

	public static function write(path:String, data:Data) {

	}

	public static function getPx(rawpx:RawPxData, xcoord:Int, ycoord:Int):{
		R:Int,
		G:Int,
		B:Int,
		A:Int
	} {
		var pxl:Int = Tools.extract32(rawpx.data).getInt32(4 * (xcoord + ycoord * rawpx.header.width));
		return {
			R: (pxl >>> 8) & 0xff,
			G: (pxl >>> 16) & 0xff,
			B: (pxl >>> 24) & 0xff,
			A: (pxl) & 0xff
		}
	}
	public static function setPx(rawpx:RawPxData, pixels:Array<{x:Int, y:Int, clr:Int}>):Data {
		/**
		 * LITTLE ENDIAN ENCODING: 4 * (xcoord + ycoord * width)
		 */
		var d:Bytes = Tools.extract32(rawpx.data);

		for (i in 0...pixels.length) {
			d.setInt32(4 * (pixels[i].x + pixels[i].y * rawpx.header.width), pixels[i].clr);
		}
		return Tools.build32ARGB(rawpx.header.width, rawpx.header.height, d);
	}
}