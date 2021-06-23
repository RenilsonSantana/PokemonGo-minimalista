//
//  ViewController.swift
//  PokemonGo
//
//  Created by Renilson Santana on 08/06/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Atributos
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDatePokemon: CoreDatePokemon!
    var pokemons: [Pokemon] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - IBActions
    
    @IBAction func btnPokebola(_ sender: Any) {
    }
    
    
    @IBAction func btnBussola(_ sender: Any) {
        centralizaMapa()
    }
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        solicitaPermissao()
        geraAnotacaoAleatoria()
        
        self.coreDatePokemon = CoreDatePokemon()
        pokemons = self.coreDatePokemon.recuperarTodosPokemons()
    }
    
    // MARK: - Metodos
    
    func solicitaPermissao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    func alertPermissaoNegada(){
        let alerta = UIAlertController(title: "Permissao de Localizacao", message: "Para o funcionamento desse aplicativo é necessario sua localizacao", preferredStyle: .alert)
        
        let abrirConfiguracoes = UIAlertAction(title: "Abrir configuracões", style: .default) { abrirConfiguracoes in
            if let configuracoes = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuracoes)
            }
        }
        alerta.addAction(abrirConfiguracoes)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)
    }
    
    func centralizaMapa(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
            //let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let regiao = MKCoordinateRegion.init(center: coordenadas, latitudinalMeters: 350, longitudinalMeters: 350)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    func centralizaPokemon(coordenada: CLLocationCoordinate2D){
        //let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let regiao = MKCoordinateRegion.init(center: coordenada, latitudinalMeters: 350, longitudinalMeters: 350)
        mapa.setRegion(regiao, animated: true)
    }
    
    func geraAnotacaoAleatoria(){
        //trecho de codigo execultado 10 em 10 segundos
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            guard let coordenada = self.gerenciadorLocalizacao.location?.coordinate else{return}
            guard let pokemonAleatorio = self.pokemons.randomElement() else{return}
            let anotacao = AnnotationPokemon(coordenada: coordenada, pokemon: pokemonAleatorio)
            anotacao.coordinate.latitude += Double.random(in: -2..<2) / 1000.0
            anotacao.coordinate.longitude += Double.random(in: -2..<2) / 1000.0
            self.mapa.addAnnotation(anotacao)
        }
    }
    
    func alert(titulo: String, msg: String){
        let alert = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - MapView
    
    // Metodo para criar visualizacões das anotacões
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //Verifica se a anotacao é a localizacão do usuario
        if annotation is MKUserLocation{
            anotacaoView.image = UIImage(named: "player")
        } else{
            guard let anotacaoPokemon = annotation as? AnnotationPokemon else {return anotacaoView}
            anotacaoView.image = UIImage(named: anotacaoPokemon.pokemon.nomeImagem!)
        }
        
        //Configura o tamanho do imagem da anotacao
        anotacaoView.frame.size.width = 40
        anotacaoView.frame.size.height = 40
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anotacao = view.annotation as? AnnotationPokemon else{return}
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if view.annotation is MKUserLocation {
            return
        }

        self.centralizaPokemon(coordenada: anotacao.coordinate)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            if let coordenadaUsuario = self.gerenciadorLocalizacao.location?.coordinate{
                //Verifica se a localizacão do usuario esta dentro da area de foco do mapa
                if self.mapa.visibleMapRect.contains(MKMapPoint.init(coordenadaUsuario)){
                    self.coreDatePokemon.capturarPokemon(pokemon: anotacao.pokemon)
                    self.mapa.removeAnnotation(anotacao)
                    
                    self.alert(titulo: "PARABËNS!!!", msg: "Você conseguiu capturar \(anotacao.pokemon.nome!) com sucesso!")
                } else{
                    self.alert(titulo: "Pokemon muito longe", msg: "Não da para capturar o pokemon, aproxime-se mais")
                }
            }
        }
    }
    
    // MARK: - LocationManager

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            alertPermissaoNegada()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contador < 3 {
            centralizaMapa()
            contador += 1
        } else{
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
}
