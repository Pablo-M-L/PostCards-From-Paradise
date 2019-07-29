//
//  ViewController.swift
//  PostCards From Paradise
//
//  Created by admin on 27/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MobileCoreServices //donde ios se guarda los tipos de datos e identificadores que necesitamos para el drop.

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate, UIDragInteractionDelegate {
    
    @IBOutlet weak var postcardImageView: UIImageView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var galeryColletionView: UICollectionView!
    
    
    
    var colors = [UIColor]()
    var galeria = [UIImage]()
    var image: UIImage?
    var topText = "texto de arriba"
    var bottomText = "testo de abajo"
    var topFontName = "Avenir Next"
    var bottomFontName = "Avenir Next"
    var topFontColor: UIColor = .white
    var bottomFontColor: UIColor = .white
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.dragDelegate = self
        galeryColletionView.delegate = self
        galeryColletionView.dataSource = self
        
        
        
        //habilitar la imagen para ser interactiva y recibir el drop
        self.postcardImageView.isUserInteractionEnabled = true
        
        colorCollectionView.dragInteractionEnabled = true
        let dragInteraction = UIDragInteraction(delegate: self)
        self.postcardImageView.addInteraction(dragInteraction)
        
        let dropInteraction = UIDropInteraction(delegate: self)
        self.postcardImageView.addInteraction(dropInteraction)
        //self.galeryColletionView.addInteraction(dropInteraction)
        
        
        self.title = "postales des el paraiso"
        
        
        //generar colores y guardarlos en el array.
        self.colors += [.black, .gray, .white, .red, .orange, .yellow, .green, .cyan, .blue, .purple, .magenta]
        
        for hue in 0...9{
            for sat in 1...10{
                let color = UIColor(hue: CGFloat(hue)/10, saturation: CGFloat(sat)/10, brightness: 1, alpha: 1)
                self.colors.append(color)
                
            }
        }
        
        //galeria
        guard let imagenDefecto = UIImage(named: "imagenPorDefecto") else{print("fallo imagen"); return}
        galeria = Array([UIImage](repeating: imagenDefecto, count: 25))
        
        renderPostcard()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = (collectionView == colorCollectionView) ? colors.count : galeria.count
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
            let color = self.colors[indexPath.row]
            cell.backgroundColor = color
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 5
            return cell
        }
        else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "GaleryCell", for: indexPath) as? GaleryCollectionViewCell
            let galeryImage =  self.galeria[indexPath.row]
            cell2?.imagenGalery.image = galeryImage
            cell2?.layer.borderWidth = 1
            cell2?.layer.cornerRadius = 5
            return cell2!
        }

        
        
    }
    
    func renderPostcard(){
        //definir la zona de dibujo para trabajar. 3000x2400
        let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
        
        //crear dos rectangulos para los dos textos de la postal.
        let topRect = CGRect(x: 300, y: 200, width: 2400, height: 800)
        let bottomRect = CGRect(x: 300, y: 1800, width: 2400, height: 600)
        
        //a partir de los nombres d elas fuentes, crear los dos objetos UIFont. dejando una fuente por defecto.
        let topFont = UIFont(name: self.topFontName, size: 300) ?? UIFont.systemFont(ofSize: 240)
        let bottomFont = UIFont(name: self.bottomFontName, size: 120) ?? UIFont.systemFont(ofSize: 80)
        
        
        //NSMutablePagraphStyle
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        //definir la estructura de la etiqueta. color, fuente. (atributed strings)
        let topAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : topFontColor, .font : topFont, .paragraphStyle : centered]
        let bottomAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : bottomFontColor, .font : bottomFont, .paragraphStyle : centered]
        
        //iniciar la renderizacion de la clase.
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        self.postcardImageView.image = renderer.image(actions: { (context) in
            
            //renderizar la zona con un fondo gris si no hay imagen.
            UIColor.lightGray.set()
            context.fill(drawRect)
            
            //pintar la imagen seleccionada del usuario empezando por el borde superior izquierdo.

           
            
            //self.image?.draw(at: CGPoint(x: 0, y: 0))
            self.image?.draw(in: drawRect) //encuadra la imagen en el imageview (postcardview)
            //pintar las dos etiquetas de texto con los parámetros confirados anteriormente.
            self.topText.draw(in: topRect, withAttributes: topAttributes)
            self.bottomText.draw(in: bottomRect, withAttributes: bottomAttributes)
            
        })
    }
    

    //MARK: UIColletionViewDragDelegate. dropinteractiondelegate
    //DRAG
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = colors[indexPath.row]
        let itemProvider = NSItemProvider(object: color)
        let item = UIDragItem(itemProvider: itemProvider)
        
        return [item]
    }
    
    //MARK: UIDragInteractionDelegate
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = self.postcardImageView.image else { return []}
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
    
    //MARK: UIDropInteractionDelegate

    //se renderiza mientras se está moviendo el objeto.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    //metodo cuando se suelta el objeto
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        let dropLocation = session.location(in: postcardImageView)
        let dropGalery = session.location(in: galeryColletionView)
        
        //comrpobar que objeto se ha soltado.
        
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]){
            //si se suelta un string se ejecutará :
            session.loadObjects(ofClass: NSString.self) { items in
                guard let fontName = items.first as? String else { return }
                if dropLocation.y < self.postcardImageView.bounds.midY{
                    self.topFontName = fontName
                }
                else{
                    self.bottomFontName = fontName
                }
                self.renderPostcard()
            }
        }
        else if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]){
            //si se suelta una imagen se ejecutará :
            session.loadObjects(ofClass: UIImage.self) { items in
                guard let image = items.first as? UIImage else { return }
                self.image = image
                self.renderPostcard()
            }

        }
        else{
            //si lo que se suelta no es un  string ni una imagen (es decir un color) se ejecutará :
            session.loadObjects(ofClass: UIColor.self) { items in
                guard let color = items.first as? UIColor else {return}
                if dropLocation.y < self.postcardImageView.bounds.midY{
                    self.topFontColor = color
                }
                else{
                    self.bottomFontColor = color
                }
                self.renderPostcard()
            }
        }
    }
    


    //MARK: gesture recognizer
    @IBAction func changeTexto(_ sender: UITapGestureRecognizer) {
        //encontrar la localización del tap dentro de la postal.
        let tapLocation = sender.location(in: self.postcardImageView) //localizacion relativa al imageview. que tiene el 0.0 arriba a la izquierda.
        
        //decidir si el usuario tiene que cambiar la etiqueta superior o inferior.
        let changeTop = (tapLocation.y < self.postcardImageView.bounds.midY) ? true : false
        
        //crear un objeto UIAlertcontroler con un textfield adicional para que el usuario escriba el texto.
        
        let alert = UIAlertController(title: "Cambiar Texto", message: "escribe el nuevo texto", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "¿que texto quieres ?"
            if changeTop{
                textfield.text = self.topText
            }
            else{
                textfield.text = self.bottomText
            }
        }
        
        //añadir accion cambiar texto en el alert.
        let btnOK = UIAlertAction(title: "OK", style: .default) { _ in
            guard let newText = alert.textFields?[0].text else{ return }
            if changeTop{
                self.topText = newText
            }
            else{
                self.bottomText = newText
            }
            self.renderPostcard()
        }
        
        let btnCancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        
        alert.addAction(btnOK)
        alert.addAction(btnCancelar)
        self.present(alert,animated: true)
    
    }
}

