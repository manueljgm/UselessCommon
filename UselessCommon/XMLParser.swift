//
//  XMLParser.swift
//  Common
//
//  Created by Manny Martins on 1/20/16.
//  Copyright © 2016 Useless Robot. All rights reserved.
//

// MARK: - XMLParser

public class XMLParser {
    
    public class func documentFromData(_ data: Data) -> XMLDocument? {
        let parser = StandardXMLParser(data: data)
        return parser.parse()
    }
    
}

// MARK: - StandardXMLParser

fileprivate class StandardXMLParser: NSObject, XMLParserDelegate {

    private let parser: Foundation.XMLParser
    
    init(data: Data) {
        self.parser = Foundation.XMLParser(data: data)
        super.init()
        self.parser.delegate = self
    }
    
    fileprivate func parse() -> XMLDocument? {
        self.parser.parse()
        
        defer {
            self.currDocument = nil
        }
        
        return self.currDocument
    }

    private var currDocument: XMLDocument?
    private var currNode: XMLNode? {
        didSet {
            if currDocument == nil {
                currDocument = XMLDocument.init(root: self.currNode!)
            }
        }
    }

    func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currNode = XMLNode(named: elementName, attributes: attributeDict, parent: self.currNode)
        self.currNode?.parent?.children.append(self.currNode!)
    }
    
    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
        self.currNode?.value = string
    }

    func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currNode = self.currNode?.parent
    }
   
    func parserDidEndDocument(_ parser: Foundation.XMLParser) {

    }
    
}

// MARK: - XMLNode

public class XMLNode {
    
    public fileprivate(set) weak var parent: XMLNode?
    
    public let name: String
    public let attributes: [String : String]
    public fileprivate(set) var value: String?
    public fileprivate(set) var children: [XMLNode]
    
    init(named name: String, attributes: [String : String], parent: XMLNode? = nil) {
        self.parent = parent
        
        self.name = name
        self.attributes = attributes
        self.value = nil
        self.children = []
    }
    
    public func children(named name: String) -> [XMLNode] {
        return self.children.filter { $0.name.caseInsensitiveCompare(name) == .orderedSame }
    }
    
    public subscript(_ attribute: String) -> String? {
        return self.attributes[ignoreCase: attribute]
    }
    
}

// MARK: - XMLDocument

public class XMLDocument {
    
    public let root: XMLNode
    
    init(root: XMLNode) {
        self.root = root
    }
    
}
