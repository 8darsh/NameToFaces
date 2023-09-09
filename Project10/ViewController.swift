//
//  ViewController.swift
//  Project10
//
//  Created by Adarsh Singh on 31/08/23.
//

import UIKit
import CoreData
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var people1=[People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        people1 = DatabaseHelper.shareInstance.getData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people1.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PersonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError("Hehe")
        }
        let person = people1[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentDirectory().appending(path: person.image ?? "hehe")
        
//        let path = getDocumentDirectory().appendingPathComponent(person.image!)
        cell.imgView.image = UIImage(contentsOfFile: path.path)
        cell.imgView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imgView.layer.borderWidth = 2
        cell.imgView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appending(path: imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)


        }

        DispatchQueue.main.async {
            self.dismiss(animated: true)

            let ac = UIAlertController(title: "Caption?", message: "Enter a caption for this image", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] _ in
                guard let caption = ac?.textFields?[0].text else { return }
                DatabaseHelper.shareInstance.save(object: ["name": caption, "image":imageName])
                self.people1 = DatabaseHelper.shareInstance.getData()
                self.collectionView.reloadData()
                
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))


            self.present(ac, animated: true)
        }

        

        

        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var person = people1[indexPath.item]
        
        let ac1 = UIAlertController(title: "Sure", message: "", preferredStyle: .alert)
        ac1.addAction(UIAlertAction(title: "Rename", style: .default){ _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                guard let newName = ac.textFields?[0].text else { return }
                person.name = newName
                
                self.collectionView.reloadData()
            })
            
            self.present(ac, animated: true)
        })
        ac1.addAction(UIAlertAction(title: "Delete", style: .default){
            _ in
            
            self.people1 = DatabaseHelper.shareInstance.deleteData(index: indexPath.item)
            self.people1 = DatabaseHelper.shareInstance.getData()
            self.collectionView.reloadData()
        })
        
        present(ac1,animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        let ac = UIAlertController(title: "Select Pics", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Gallery", style: .default){_ in
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Camera", style: .default){ _ in
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        })

        
        present(ac,animated: true)
        
        
    }
    
    


}

