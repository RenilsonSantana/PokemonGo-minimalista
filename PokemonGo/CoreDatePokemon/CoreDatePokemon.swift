//
//  CoreDatePokemon.swift
//  PokemonGo
//
//  Created by Renilson Santana on 22/06/21.
//

import UIKit
import CoreData

class CoreDatePokemon: NSObject {
    
    // MARK: Metodos
    
    //Recupera Context
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func adicionaTodosPokemons(){
        let context = self.getContext()
        
        self.criaPokemon(nome: "Abra", nomeImage: "abra", capturado: false)
        self.criaPokemon(nome: "Bellsprout", nomeImage: "bellsprout", capturado: false)
        self.criaPokemon(nome: "Pikachu", nomeImage: "pikachu-2", capturado: false)
        self.criaPokemon(nome: "Caterpie", nomeImage: "caterpie", capturado: false)
        self.criaPokemon(nome: "Charmander", nomeImage: "charmander", capturado: false)
        self.criaPokemon(nome: "Dratini", nomeImage: "dratini", capturado: false)
        self.criaPokemon(nome: "Eevee", nomeImage: "eevee", capturado: false)
        self.criaPokemon(nome: "Jigglypuff", nomeImage: "jigglypuff", capturado: false)
        self.criaPokemon(nome: "Mankey", nomeImage: "mankey", capturado: false)
        self.criaPokemon(nome: "Meowth", nomeImage: "meowth", capturado: false)
        self.criaPokemon(nome: "Mew", nomeImage: "mew", capturado: false)
        self.criaPokemon(nome: "Venonat", nomeImage: "venonat", capturado: false)
        self.criaPokemon(nome: "Pidgey", nomeImage: "pidgey", capturado: false)
        self.criaPokemon(nome: "Psyduck", nomeImage: "psyduck", capturado: false)
        self.criaPokemon(nome: "Rattata", nomeImage: "rattata", capturado: false)
        self.criaPokemon(nome: "Snorlax", nomeImage: "snorlax", capturado: false)
        self.criaPokemon(nome: "Squirtle", nomeImage: "squirtle", capturado: false)
        self.criaPokemon(nome: "Weedle", nomeImage: "weedle", capturado: false)
        self.criaPokemon(nome: "Zubat", nomeImage: "zubat", capturado: false)
        
        do{
            try context.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func criaPokemon(nome: String, nomeImage: String, capturado: Bool){
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImage
        pokemon.capturado = capturado
    }
    
    func recuperarTodosPokemons() -> [Pokemon]{
        let context = self.getContext()
        
        do{
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.adicionaTodosPokemons()
                return self.recuperarTodosPokemons()
            }
            
            return pokemons
        } catch{
            print(error.localizedDescription)
        }
        return []
    }
    
    func recuperaPokemonsCapiturados(capturado: Bool) -> [Pokemon] {
        let context = self.getContext()
        
        //Criando filtro de pokemons
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado == %@", NSNumber(value: capturado))
        
        do{
            let pokemonsFiltrados = try context.fetch(requisicao) as [Pokemon]
            return pokemonsFiltrados
        } catch{
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func capturarPokemon(pokemon: Pokemon){
        let context = self.getContext()
        pokemon.capturado = true
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
}
