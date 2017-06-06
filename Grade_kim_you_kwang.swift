//
//  File.swift
//  test
//
//  Created by 김유광 on 2017. 6. 2..
//
//

import Foundation



let file : FileHandle? = FileHandle(forReadingAtPath: "/Users/kim-youkwang/students.json")
let databuffer = file?.readDataToEndOfFile()
let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
var data = out.data(using: .utf8)!

class OurJSONParser {

    func gradechk(avg: Int) -> (String){
        if avg >= 90 && avg <= 100{
            return "A"
        }
        else if avg >= 80 && avg < 90{
            return "B"
        }
        else if avg >= 70 && avg < 80{
            return "C"
        }
        else if avg >= 60 && avg < 70{
            return "D"
        }
        else
        {
            return "F"
        }
 
    }

    func parseJSONResults() -> (String) {
        do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                   let list = json as [AnyObject]
                    var allsum : Float = 0
                    var allst : Float = 0
                    var temparray = [(name : String , grade : String)]()
                    var tempname = [String]()
                    for student in list
                    {
                        let name = student["name"] as! String
                        if let gradeJSON = student["grade"] as? [String: Float]{
                            var sum : Float = 0
                            var count : Float = 0
                            if let data_structure = gradeJSON["data_structure"]{
                                sum += data_structure
                                count += 1
                            }
                            if let algorithm = gradeJSON["algorithm"]{
                                sum += algorithm
                                count += 1
                            }
                            if let networking = gradeJSON["networking"]{
                                sum += networking
                                count += 1
                            }
                            if let database = gradeJSON["database"]{
                                sum += database
                                count += 1
                            }
                            if let operating_system = gradeJSON["operating_system"]
                            {
                                sum += operating_system
                                count += 1
                            }
                            let avg = Float(sum/count)
                            temparray.append((name,gradechk(avg:Int(avg))))
                            if avg >= 70{
                                tempname.append(name)
                            }
                            allsum += avg
                            allst += 1
                        }
                    }
                    let allavg = Double(allsum/allst)
                    let numberOfPlaces = 2.0
                    let multiplier = pow(10.0, numberOfPlaces)
                    let rounded = round(allavg * multiplier) / multiplier
                    let temgrdsort = temparray.sorted(by:<)
                    let temnamesort = tempname.sorted()
                    var text2 = " "
                    var temptext = "개인별 학점" + "\n"
                    let text1 =  "전체 평균 : " + String(rounded) + "\n"
                    for i in 0..<5{
                        temptext += (temgrdsort[i].name + "    :  " + temgrdsort[i].grade) + "\n"
                        text2 = temptext
                    }
                    let text3 = "수료생" + "\n" + temnamesort[0] + ", " + temnamesort[1] + ", " + temnamesort[2]

                    return "성적결과표" + "\n" + "\n" + text1 + "\n" + text2 + "\n"  + text3
            }
        } catch {
            // 실패한 경우, 오류 메시지를 출력합니다.
            print("Error, Could not parse the JSON request")
        }
        
        return "no data"
    }
}

let parser = OurJSONParser()
let result = parser.parseJSONResults()
print(result)

let fileName = "result"
let URL = FileManager.default.homeDirectory(forUser : "kim-youkwang" )
let fileURL = URL?.appendingPathComponent(fileName).appendingPathExtension("txt")
try result.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
let wdata = (result as NSString).data(using: String.Encoding.utf8.rawValue)





