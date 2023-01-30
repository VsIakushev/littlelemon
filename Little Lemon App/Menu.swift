//
//  Menu.swift
//  Little Lemon App
//
//  Created by Vitaliy Iakushev on 30.01.2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText = ""
    
    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Some description")
            
            TextField("Search menu", text: $searchText)
            
            NavigationView {
                
                FetchedObjects(predicate: buildPredicates(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id: \.self) { dish in
                            NavigationLink( destination: {
                                Details(title: dish.title ?? "",
                                        price: dish.price ?? "",
                                        image: dish.image ?? "",
                                        description: dish.dishDescription ?? "")
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
            }
            
            
        } .task {
            await getMenuData() // .onAppear
        }
    }
    func getMenuData() async {
        PersistenceController.shared.clear()
        
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let menuList = try decoder.decode(MenuList.self, from: data)
            for menuItem in menuList.menu {
                let dish = Dish(context: viewContext)
                dish.title = menuItem.title
                dish.price = menuItem.price
                dish.image = menuItem.image
                dish.dishDescription = menuItem.description
            }
            try? viewContext.save()
        }
        
        catch { }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    
    func buildPredicates() -> NSPredicate {
        searchText.isEmpty
        ? NSPredicate(value: true)
        : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


