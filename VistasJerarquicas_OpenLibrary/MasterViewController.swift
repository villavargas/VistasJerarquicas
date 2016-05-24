//
//  MasterViewController.swift
//  VistasJerarquicas_OpenLibrary
//
//  Created by Luis Alejandro Villa Vargas on 08/05/16.
//  Copyright © 2016 Luis Alejandro Villa Vargas. All rights reserved.
//

import UIKit
import CoreData


class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, communicationWithTableView {
    
    var titulos:[String] = []
    var isbnAcumulados:[ISBNModelo] = []
    
    var contexto:NSManagedObjectContext? = nil
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        print("comprobar que tengo algo en el modelo");
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let seccionEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        do {
            isbnAcumulados = []
            let seccionEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
            if (seccionEntidad2?.count > 0) {
                print("existen elementos dentro");
                for seccionEntidadInd in seccionEntidad2! {
                    print(seccionEntidadInd.valueForKey("titulo"))
                    var imagenLibro:UIImage?
                    if seccionEntidadInd.valueForKey("imagen") != nil {
                        imagenLibro = UIImage(data: seccionEntidadInd.valueForKey("imagen") as! NSData)
                    } else {
                        imagenLibro = nil
                    }
                    let isbnM = ISBNModelo(isbn: seccionEntidadInd.valueForKey("isbn") as! String, nombre: seccionEntidadInd.valueForKey("titulo") as! String, autores: [seccionEntidadInd.valueForKey("autores") as! String], imagen: imagenLibro)
                    isbnAcumulados.append(isbnM)
                }
                tableView.reloadData()
            } else {
                print("no hay elementos")
            }
            
        } catch {
            
        }


    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    
    @IBAction func btnAddISBN(sender: AnyObject) {
        
        performSegueWithIdentifier("showISBN", sender: self)
        
    }
    
    func passName(name: String, isbn: String, autores: [String], imagen: UIImage?) {
        print("1º VC")
        if (name != "" && name != "ISBN no válido") {
            print("nombre passName: \(name)")
            let isbn = ISBNModelo(isbn: isbn, nombre: name, autores: autores, imagen: imagen)
            isbnAcumulados.append(isbn)
             tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
             print("showDetail")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("indexPath: \(indexPath)")
                (segue.destinationViewController as! DetailViewController).title = isbnAcumulados[indexPath.row].isbn
                print("n: \(isbnAcumulados[indexPath.row].nombre)")
                (segue.destinationViewController as! DetailViewController).nombre = isbnAcumulados[indexPath.row].nombre
                (segue.destinationViewController as! DetailViewController).autores = isbnAcumulados[indexPath.row].autores.joinWithSeparator(",")
                (segue.destinationViewController as! DetailViewController).imagen = isbnAcumulados[indexPath.row].imagen
                
            }
        } else {
            if segue.identifier == "showISBN" {
                (segue.destinationViewController as! ISBNController).mDelegate = self
                (segue.destinationViewController as! ISBNController).contexto = self.contexto
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isbnAcumulados.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        print("i: \(indexPath.row) n: \(isbnAcumulados[indexPath.row].nombre)")
        cell.textLabel?.text = isbnAcumulados[indexPath.row].nombre
        
        return cell
    }
    
}

