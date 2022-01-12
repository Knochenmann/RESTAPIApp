//
//  CoordinatesGeneratorService.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//


class CoordinatesGeneratorService {
    
    func latitude() -> Double {
        Double.random(in: -90...90)
    }
    
    func longitude() -> Double {
        Double.random(in: -180...180)
    }
}
