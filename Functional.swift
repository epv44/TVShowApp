//
//  Functional.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

infix operator <^> { associativity left }
infix operator <*> { associativity left }
infix operator >>> { associativity left precedence 150 }

func >>><A,B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    }else{
        return .None
    }
}

func >>><A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Value(x):     return f(x.value)
    case let .Error(error): return .Error(error)
    }
}

func <^><A, B>(f: A -> B, a: A?) -> B? {
    if let x = a{
        return f(x)
    }else{
        return .None
    }
}

func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    if let x = a {
        if let fx = f {
            return fx(x)
        }
    }
    return .None
}