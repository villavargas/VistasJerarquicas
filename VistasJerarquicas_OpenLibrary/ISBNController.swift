//
//  ViewController.swift
//  PeticionServidor
//
//  Created by Luis Alejandro Villa Vargas on 23/04/16.
//  Copyright © 2016 Luis Alejandro Villa Vargas. All rights reserved.
// test

import UIKit
import CoreData

protocol communicationWithTableView {
    func passName(name: String,isbn:String,autores:[String],imagen:UIImage?)
}

class ISBNController: UIViewController,UITextFieldDelegate  {
    
    var isbnLibro:String = ""
    var tituloLibro:String = ""
    var autoresLibro:[String] = []
    var imagenLibro:UIImage?
    var autores = ""
    var ISBNModel = [ISBNModelo]()

    
    @IBOutlet weak var ISBN: UITextField!
    @IBOutlet weak var textView: UITextView!
    var contexto:NSManagedObjectContext?
    var mDelegate: communicationWithTableView!
    
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ISBN.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelar(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func aceptar(sender: AnyObject) {
        
    if let texto = ISBN.text {
            print("VC: \(texto) \(self.tituloLibro)   \(autoresLibro)    \(imagenLibro)   ")
            let isbn = ISBNModelo(isbn: texto, nombre: self.tituloLibro, autores: autoresLibro, imagen: imagenLibro)
            ISBNModel.append(isbn)
            self.mDelegate.passName(texto, isbn: isbnLibro, autores: autoresLibro,imagen: imagenLibro)
        } else {
            self.mDelegate.passName("", isbn: "", autores: [],imagen: nil)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    
    @IBAction func backgroundTap(sender: UIControl) {
        ISBN.resignFirstResponder()
    }
    
    
    
    @IBAction func textFieldDidEndEditing(textField: UITextField) {
        print("Inicia peticion al servidor...")
        sincrono()
        print(ISBN.text)
    }
    
    func sincrono(){
        
        if let isbn = ISBN.text {
            let baseURL = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)")
            
            
            let datos:NSData? = NSData(contentsOfURL: baseURL!)
            let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
            print(texto)
            var titulo = ""
            var autores = ""
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers)
                
                let dico1 = json as! NSDictionary
                
                if let dico2 = dico1["ISBN:\(isbn)"] as? NSDictionary {
                    
                    let dico3 = dico2["authors"] as? [NSDictionary]
                    
                    titulo = "\(dico2["title"] as! NSString as String)"
                    tituloLibro = titulo
                    // Existe portada?
                    
                    if let dico4 = dico2["cover"] as? NSDictionary {
                        
                        let url = NSURL(string: dico4["medium"] as! NSString as String)
                         cargar_imagen(url!)
                        
                    }
                    
                    if let dicAutores = dico3 {
                        
                        for autor in dicAutores {
                            
                            autores += "\(autor["name"] as! NSString as String) "
                            self.autoresLibro.append("\(autor["name"] as! NSString as String)")
                            
                        }
                        
                    }
                    
                } else {
                    
                    titulo = "ISBN no válido"
                    
                }
                
            } catch _ {
                
                print("Error")
                
            }
            
            
            
            self.textView!.text = String("Titulo: \(titulo) \n\n\n" +
                "Autor: \(autores)"   )
        }else{
            print("Error")
        }
        
    }
    
    
    
    func cargar_imagen(urlString:NSURL){
        let imgURL = urlString
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.imagenLibro = UIImage(data: data!)
                    self.image.image = UIImage(data: data!)
                    self.image.hidden = false
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    
}