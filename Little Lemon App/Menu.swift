//
//  Menu.swift
//  Little Lemon App
//
//  Created by Vitaliy Iakushev on 30.01.2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @ObservedObject var dish = Dish()
    
    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Some description")
            
            
                FetchedObjects { (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id: \.self) { dish in
                            NavigationLink( destination: {
                                Details(title: dish.title ?? "", price: dish.price ?? "", image: dish.image ?? "", description: dish.dishDescription ?? "")
                            }) {
                                HStack{
                                    Text(dish.title ?? "")
                                    Text(dish.price ?? "")
                                    AsyncImage(url: URL(string: dish.image ?? ""))
                                        .frame(maxWidth: 150, maxHeight: 150)
                                }
                            }
                            Text("")
                        }
                        
                    }
                }
            
            
        } .onAppear {
            getMenuData()
        }
    }
    func getMenuData() {
        PersistenceController.shared.clear()
        
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do { let menuList = try decoder.decode(MenuList.self, from: data)
                    for menuItem in menuList.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = menuItem.title
                        dish.price = menuItem.price
                        dish.image = menuItem.image
                        dish.dishDescription = menuItem.description
                    }
                    try? viewContext.save()

                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
            
        }
        dataTask.resume()

        
        
    }
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


