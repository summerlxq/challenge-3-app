//
//  HomeView.swift
//  challenge 3 app
//
//  Created by Xiuqi Lin on 19/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var foodItems: [FoodItem]
    
    @State private var selectedItem: FoodItem?
    //select each item from FoodItem
    
    @State private var selectedType: Foodtype = .all
    // selects from Foodtype (location)
    
    @State var searchText: String
    
    //    @State private var allFoodItems: [FoodItem] = [
    //        FoodItem(nameOfFood: "lettuce", dateScanned: Date(), dateExpiring: Date(), storageLocation: .fridge),
    //        FoodItem(nameOfFood: "biscuits", dateScanned: Date(), dateExpiring: Date(), storageLocation: .pantry),
    //        FoodItem(nameOfFood: "cactus", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 3))!, storageLocation: .pantry),
    //        FoodItem(nameOfFood: "ice cream", dateScanned: Date(), dateExpiring: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 27))!, storageLocation: .freezer)
    //    ] // subjects all food items to custom data type FoodItem
    
    @State private var isInfoShown = false
    // modal sheet boolean
    
    
    var numOfExpiring: Int {
        var expiringCount = 0
        for item in foodItems {
            if item.daysUntilExpiration >= 0 && item.daysUntilExpiration <= 5 {
                expiringCount += 1
            }
        }
        return expiringCount
    }
    
    var numOfExpired: Int {
        var expiredCount = 0
        for item in foodItems {
            if item.daysUntilExpiration < 0 {
                expiredCount += 1
            }
        }
        return expiredCount
    }
    
    
    @State private var selectedPhotoItem: PhotosPickerItem? // holds the selected photo
    @State private var selectedImage: UIImage? //holds the loaded image
    @State private var showingCamera = false //control camera sheet visibility
    @State private var showingSystemPhotoPicker = false
    @State private var viewModel = VisionModel()
    //    @StateObject var cropVM = CropModel()
    @State private var navigate = false
    @State private var showIngredientView = false
    @State private var foods: [FoodItem] = []
    
    
    init(
        selectedItem: FoodItem? = nil,
        selectedType: Foodtype = .all,
        searchText: String,
        isInfoShown: Bool = false,
        selectedPhotoItem: PhotosPickerItem? = nil,
        selectedImage: UIImage? = nil,
        showingCamera: Bool = false,
        showingSystemPhotoPicker: Bool = false,
        viewModel: VisionModel = VisionModel(),
        navigate: Bool = false,
        showIngredientView: Bool = false,
        foods: [FoodItem] = []
    ) {
        self.selectedItem = selectedItem
        self.selectedType = selectedType
        self.searchText = searchText
        self.isInfoShown = isInfoShown
        self.selectedPhotoItem = selectedPhotoItem
        self.selectedImage = selectedImage
        self.showingCamera = showingCamera
        self.showingSystemPhotoPicker = showingSystemPhotoPicker
        self.viewModel = viewModel
        self.navigate = navigate
        self.showIngredientView = showIngredientView
        self.foods = foods
        
        let predicate = #Predicate<FoodItem> { foodItem in
            if searchText.isEmpty {
                return true
            } else {
                return foodItem.nameOfFood.localizedStandardContains(searchText)
            }
        }
        
        _foodItems = Query(
            filter: predicate,
            sort: [SortDescriptor(\.nameOfFood)]
        )
    }
    
    var foodItemsExpired: [FoodItem] { foodItems.filter { item in
        item.daysUntilExpiration < 0 && (item.storageLocation == selectedType || selectedType == .all)
    }
    }
    
    var foodItemsThisWeek: [FoodItem] { foodItems.filter { item in
        item.daysUntilExpiration < 7 && item.daysUntilExpiration >= 0 && (item.storageLocation == selectedType || selectedType == .all)
    }
    }
    
    var foodItemsNextWeek: [FoodItem] { foodItems.filter { item in
        item.daysUntilExpiration > 7 && item.daysUntilExpiration <= 14 && (item.storageLocation == selectedType || selectedType == .all)
    }
    }
    
    var foodItemsLater: [FoodItem] { foodItems.filter { item in
        item.daysUntilExpiration > 14 && (item.storageLocation == selectedType || selectedType == .all)
    }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    ExpiringView()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.yellow)
                        VStack {
                            Text("\(numOfExpiring)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                            Text("Expiring")
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                    }
                    .frame(maxWidth: .infinity) // takes up as much space as it can
                    .aspectRatio(1.5, contentMode: .fit) // ratio of width to height
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                Spacer()
                NavigationLink {
                    ExpiredView()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.red)
                        VStack {
                            Text("\(numOfExpired)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                            Text("Expired")
                                .foregroundStyle(.black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        }
                    }
                    .frame(maxWidth: .infinity) // takes up as much space as it can
                    .aspectRatio(1.5, contentMode: .fit) // ratio of width to height
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
            
            List { // creates a continuous list of items
                Picker("Foodtype", selection: $selectedType) {
                    // selection of picker from Foodtype
                    Text("All").tag(Foodtype.all)
                    Text("Pantry").tag(Foodtype.pantry)
                    Text("Fridge").tag(Foodtype.fridge)
                    Text("Freezer").tag(Foodtype.freezer)
                }
                .pickerStyle(.segmented)
                
                if foodItemsExpired.isEmpty && foodItemsThisWeek.isEmpty && foodItemsNextWeek.isEmpty && foodItemsLater.isEmpty {
                    ContentUnavailableView("No Food Items", systemImage: "fork.knife")
                }
                
                if foodItemsExpired.count > 0 {
                    
                    Section("Expired") {
                        // separates picker from items below
                        ForEach(foodItemsExpired) { item in
                            //                            Button("\(item.nameOfFood)") {
                            //                                selectedItem = item
                            //                            }
                            NavigationLink(destination: BindableEditDetailsView(item: item)){
                                Text(item.nameOfFood)
                            }
                            .swipeActions {
                                Button("Delete") {
                                    modelContext.delete(item)
                                }
                                .tint(.red)
                            }
                        }
                        
                    }
                }
                
                if foodItemsThisWeek.count > 0 {
                    
                    Section("This week") {
                        ForEach(foodItemsThisWeek) { item in
                            //                            Button("\(item.nameOfFood)") {
                            //                                selectedItem = item
                            //                            }
                            NavigationLink(destination: BindableEditDetailsView(item: item)){
                                Text(item.nameOfFood)
                            }
                            .swipeActions {
                                Button("Delete") {
                                    modelContext.delete(item)
                                }
                                .tint(.red)
                            }
                            
                            
                        }
                    }
                }
                
                if foodItemsNextWeek.count > 0 {
                    Section("Next week") {
                        ForEach(foodItemsNextWeek) { item in
                            //                            Button("\(item.nameOfFood)") {
                            //                                selectedItem = item
                            //                            }
                            NavigationLink(destination: BindableEditDetailsView(item: item)){
                                Text(item.nameOfFood)
                            }
                            .swipeActions {
                                Button("Delete") {
                                    modelContext.delete(item)
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                
                if foodItemsLater.count > 0 {
                    Section("Later") {
                        ForEach(foodItemsLater) { item in
                            //                            Button("\(item.nameOfFood)") {
                            //                                selectedItem = item
                            //                            }
                            NavigationLink(destination: BindableEditDetailsView(item: item)){
                                Text(item.nameOfFood)
                            }
                            .swipeActions {
                                Button("Delete") {
                                    modelContext.delete(item)
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            //            .sheet(item: $selectedItem) { item in
            //                VStack {
            //                    Text("\(item.nameOfFood)")
            //                        .font(.largeTitle)
            //                    Text("Date scanned: \(item.dateScanned.formatted(date: .abbreviated, time: .omitted))")
            //                    Text("Date expiring: \(item.dateExpiring.formatted(date: .abbreviated, time: .omitted))")
            //                    Text("Days to expiry: \(item.daysUntilExpiration)")
            //                }
            //            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showingCamera = true
                        } label: {
                            Label("Scan receipt", systemImage: "document.viewfinder")
                        }
                        
                        Button {
                            showingSystemPhotoPicker = true
                        } label: {
                            Label("Pick photo", systemImage: "photo")
                        }
                        
                        Button {
                            foods = []
                            print(foods)
                            showIngredientView = true
                        } label: {
                            Label("Manually enter", systemImage:"keyboard")
                        }
                        
                    } label: {
                        Label("Menu", systemImage: "plus")
                    }
                }
            }
            .photosPicker(isPresented: $showingSystemPhotoPicker, selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared())
            
            .sheet(isPresented: $navigate){
                IngredientView(navigate: $navigate, foods: $foods)
                    .environment(viewModel)
            }
            
            .sheet(isPresented: $showIngredientView) {
                IngredientView(navigate: $showIngredientView, foods: $foods)
                    .environment(viewModel)
            }
            
            .sheet(isPresented: $showingCamera) {
                CameraView { result in
                    switch result {
                    case .success(let image):
                        selectedImage = image
                    case .failure(let error):
                        print("Scan failed: \(error.localizedDescription)")
                    }
                    showingCamera = false
                } didCancel: {
                    showingCamera = false
                }
                .ignoresSafeArea()
            }
            .onChange(of: selectedPhotoItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            .onChange(of: selectedImage) {
                if let selectedImage, let data = selectedImage.pngData() {
                    Task {
                        await viewModel.recognizeTable(in: data)
                        navigate = true
                        foods = []
                        //                    showIngredientView = true
                        print("done")
                        print(viewModel.foods)
                    }
                }
            }
            .navigationTitle("Shelf")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

