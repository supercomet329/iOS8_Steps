// Playground - noun: a place where people can play

import Cocoa

/*******************
  MUTABILITY
******************/
struct MyStruct {
  let t: Int
  var u: String
}

var struct1 = MyStruct(t: 15, u: "Hello")
//struct1.t = 13 // Error: t is an immutable property
struct1.u = "GoodBye"
struct1 = MyStruct(t: 10, u: "You")

let struct2 = MyStruct(t: 12, u: "World")
//struct2.u = "Planet" // Error: struct2 is immutable
//struct2 = MyStruct(t: 10, u: "Defeat") // Error: struct2 is an immutable ref

class MyClass {
  let t: Int
  var u: String
  
  init(t: Int, u: String) {
    self.t = t
    self.u = u
  }
}

var class1 = MyClass(t: 15, u: "Hello")
//class1.t = 13 // Error: t is an immutable property
class1.u = "GoodBye"
class1 = MyClass(t: 10, u: "You")

let class2 = MyClass(t: 12, u: "World")
class2.u = "Planet" // No error
//class2 = MyClass(t: 11, u: "Geoid") Error: class2 is an immutable reference


var array1 = [1,2,3,4]
array1.append(5)
array1[0] = 27
array1
array1 = [3,2]

let array2 = [4,3,2,1]
//array2.append(0) // Error: array2 is immutable
//array2[2] = 36   // Error: array2 is immutable
//array2 = [5,6]   // Error: cannot reassign an immutable reference


/*******************
  AnyObject
******************/

let myString: AnyObject = "hello"
myString.cornerRadius // Returns nil

func someFunc(parameter: AnyObject!) {
  if let castedParameter = parameter as? NSString {
    // Do something
  }
}

func someOtherFunc(parameter: AnyObject!) {
  let castedParameter = parameter as! NSString
  // Do something
}

func someArrayFunc(parameter: [AnyObject]!) {
  let newArray = parameter as! [NSString]
  // Do something
}


/*******************
  Protocols
******************/

protocol MyProtocol {
  func myProtocolMethod() -> Bool
}

//if let class1AsMyProtocol = class1 as? MyProtocol {
  // We're in
//} // Error: need MyProtocol to be @objc

@objc protocol MyNewProtocol {
  func myProtocolMethod() -> Bool
}

if let class1AsMyNewProtocol = class1 as? MyNewProtocol {
  // We're in
}



/*******************
  Enums
******************/

enum MyEnum {
  case FirstType
  case IntType (Int)
  case StringType (String)
  case TupleType (Int, String)
  
  func prettyFormat() -> String {
    switch self {
    case .FirstType:
      return "No params"
    case .IntType(let value):
      return "One param: \(value)"
    case .StringType(let value):
      return "One param: \(value)"
    case .TupleType(let v1, let v2):
      return "Some params: \(v1), \(v2)"
    default:
      return "Nothing to see here"
    }
  }
}


var enum1 = MyEnum.FirstType
enum1.prettyFormat()
enum1 = .TupleType(12, "Hello")
enum1.prettyFormat()


