//
//  AgendaPokemonViewController.swift
//  PokemonGo
//
//  Created by Renilson Santana on 22/06/21.
//

import UIKit

class AgendaPokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Atributos
    
    var pokemonsCapiturados: [Pokemon] = []
    var pokemonsNaoCapiturados: [Pokemon] = []
    
    // MARK: IBActions

    @IBAction func fecharAgenda(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recuperaPokemons()
    }
    
    // MARK: Metodos
    
    func recuperaPokemons(){
        pokemonsCapiturados = CoreDatePokemon().recuperaPokemonsCapiturados(capturado: true)
        pokemonsNaoCapiturados = CoreDatePokemon().recuperaPokemonsCapiturados(capturado: false)
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capiturado"
        } else{
            return "Não Capiturado"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsCapiturados.count
        } else{
            return pokemonsNaoCapiturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        var pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsCapiturados[indexPath.row]
        } else{
            pokemon = pokemonsNaoCapiturados[indexPath.row]
        }
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return celula
    }
}
