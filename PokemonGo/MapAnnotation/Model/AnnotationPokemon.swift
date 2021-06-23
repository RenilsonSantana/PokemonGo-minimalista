//
//  AnnotationPokemon.swift
//  PokemonGo
//
//  Created by Renilson Santana on 23/06/21.
//

import UIKit
import MapKit

class AnnotationPokemon: NSObject, MKAnnotation {
    
    // MARK: - Atributos
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    // MARK: Init
    
    init(coordenada: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenada
        self.pokemon = pokemon
    }
}
