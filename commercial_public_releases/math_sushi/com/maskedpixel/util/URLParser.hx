package com.maskedpixel.util;

/**
 * ...
 * @author Erin M Gunn
 */

class URLParser
{

  public var url:String;
  public var source:String;
  public var protocol:String;
  public var authority:String;
  public var userInfo:String;
  public var user:String;
  public var password:String;
  public var host:String;
  public var port:String;
  public var relative:String;
  public var path:String;
  public var directory:String;
  public var file:String;
  public var query:String;
  public var anchor:String;
 
  private static inline var parts:Array<String> =
    [ "source", "protocol", "authority", "userInfo", "user", "password", "host",
      "port", "relative", "path", "directory", "file", "query", "anchor"];


  public function new(url:String):Void
  {
    // Save for 'ron
    this.url = url;
 
    /*
     * This regexp actually has a bug, it doesn't correctly parse
     * file: protocol URLs with an absolute path leading slash.
     */

    // The almighty regexp (courtesy of
    // http://blog.stevenlevithan.com/archives/parseuri)
    var r:EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
 
    // Match the regexp to the url
    r.match(url);
 
    // Use reflection to set each part
    for (i in 0...parts.length) {
      Reflect.setField(this, parts[i],  r.matched(i));
    }
  }

  public static function parse(url:String):URLParser
  {
    return new URLParser(url);
  }
}