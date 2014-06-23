// Playground - noun: a place where people can play

import Cocoa
import Foundation

import XCPlayground
XCPSetExecutionShouldContinueIndefinitely()

var bundle = NSBundle.mainBundle()
var url = bundle.URLForResource("item", withExtension: "xml")

var data = NSData(contentsOfURL: url)

var str = String.stringWithContentsOfURL(url,
    encoding: NSUTF8StringEncoding,
    error: nil)

class Item: Printable {
    var id = 0
    var year = 0
    var name = ""
    var thumb = ""
    
    var description:String {
        get {
            return "Item: \(name), \(year), \(id), \(thumb)"
        }
    }
}

class MyParser: NSObject, NSXMLParserDelegate {
    var item:Item?
    
    func parser(              parser: NSXMLParser!,
         didStartElement elementName: String!,
                        namespaceURI: String!,
         qualifiedName         qName: String!,
         attributes    attributeDict: NSDictionary!) {
        
        let attr = attributeDict as Dictionary<String,AnyObject>

        switch (elementName!, attr["value"], attr["id"]) {
        case ("items", _, _):
            "root"
        case ("item", _, _):
            // the following is crashing
            // case ("item", _, .Some(let id as NSString)):
            item = Item()
            attr["id"]
            var idStr = attr["id"] as NSString
            var idInt = idStr.integerValue
            item!.id = idInt
        case ("name", .Some(let name as NSString), _):
            item!.name = name
        case ("thumbnail", .Some(let thumb as NSString), _):
            item!.thumb = thumb
        case ("yearpublished", .Some(let year as NSString), _):
            item!.year = year.integerValue
            // for the sake of argument
            attr["value"]
            var valStr = attr["value"] as NSString
            var valInt = valStr.integerValue
        default:
            elementName
        }
    }

    
}

var myparser = MyParser()
var oneparser = NSXMLParser(contentsOfURL: url)
oneparser.delegate = myparser
if oneparser.parse() {
    myparser.item
    println(myparser.item!.description)
} else {
    var failed = "failed"
    println(failed)
}


