//
//  Typealias.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

typealias ItemClosure<T> = ((T) -> Void)
typealias VoidClosure = (() -> Void)
typealias ApiCompletionBlock<T : Decodable> = (Result<T, Error>) -> Void
typealias CompletionBlock<T> = (Result<T, Error>) -> Void
