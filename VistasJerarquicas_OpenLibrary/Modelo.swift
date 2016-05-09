//
//  Modelo.swift
//  VistasJerarquicas_OpenLibrary
//
//  Created by Luis Alejandro Villa Vargas on 08/05/16.
//  Copyright © 2016 Luis Alejandro Villa Vargas. All rights reserved.
//

import UIKit

struct ISBNModelo {
    var isbn:String
    var nombre:String
    var autores:[String]
    var imagen:UIImage?
    
    init(isbn:String,nombre:String, autores:[String],imagen:UIImage?) {
        self.isbn = isbn
        self.nombre = nombre
        self.autores = autores
        if let hayImagen = imagen {
            self.imagen = hayImagen
        } else {
            self.imagen = nil
        }
    }
}
