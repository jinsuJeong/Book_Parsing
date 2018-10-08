//
//  ViewController.swift
//  Book_Parsing
//
//  Created by D7703_18 on 2018. 10. 2..
//  Copyright © 2018년 201550057. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBookData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        cell.textLabel?.text = myBookData[indexPath.row].title
        cell.detailTextLabel?.text = myBookData[indexPath.row].author
        return cell
    }
    
    @IBOutlet weak var myTableView: UITableView!
    // 데이터 클래스 객체 배열
    var myBookData: [BookData] = []
    var Title = ""
    var Author = ""
    
    //현재의 tag를 저장
    var currentElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource=self
        
        //book.xml 가져오기
        
        if let path = Bundle.main.url(forResource: "book", withExtension: "xml") {
            //파싱 시작
            if let myParser = XMLParser(contentsOf: path) {
                //delegate를 ViewController와 연결
                myParser.delegate=self
                
                if myParser.parse() {
                    print("파싱 성공")
                    for i in 0 ..< myBookData.count {
                        print(myBookData[i].title)
                        print(myBookData[i].author)
                    }
                } else {
                    print("파싱 실패")
                }
                
            } else {
                print("파싱 오류 발생")
            }
            
        } else {
            print("xml file not found")
        }
    
    }
    
    // XML Parser delegate 메소드
    // 1. tag(element)를 만나면 실행
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    //2. tag 다음에 문자열을 만날때 실행
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 공백 등 제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch currentElement {
            case "title" : Title = data
            case "author" : Author = data
            default : break
            }
        }
    }
    
    //3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            let myItem = BookData()
            myItem.title = Title
            myItem.author = Author
            myBookData.append(myItem)
        }
    }
}
