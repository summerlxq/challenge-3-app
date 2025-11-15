//IMPORTS
import SwiftUI
import PhotosUI
import Vision
import VisionKit

struct ScanView: View{
    @State private var selectedItem: PhotosPickerItem? // holds the selected photo
    @State private var selectedImage: UIImage? //holds the loaded image
    @State private var showingCamera = false //control camera sheet visibility
    @State private var viewModel = VisionModel()
    @State private var navigate = false
    var body: some View{
        
            
        VStack{
            // display selected image
            if let selectedImage = selectedImage{
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(25)
            }else{
                Text("No Image selected")
                    .foregroundStyle(.gray)
                    .padding()
            }
            //photo taking button
            Button(action: {
                showingCamera = true //show camera to user
            }){
                Text("Take Photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showingCamera){
                CameraView(image: $selectedImage)
            }
            .sheet(isPresented: $navigate){
                IngredientView()
                    .environment(viewModel)
            }
            //photo picker button
            PhotosPicker(selection:
                            $selectedItem,
                         matching: .images,
                         photoLibrary: .shared()
            ){
                Text("Select Photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .onChange(of: selectedItem) { _, newItem in
                if let newItem = newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                            selectedImage = image // update the selected image
                        }
                    }
                }
            }
        }
        .onChange(of: selectedImage) {
            if let selectedImage, let data = selectedImage.pngData() {
                Task {
                    await viewModel.recognizeTable(in: data)
                    navigate = true
                    print("done")
                    print(viewModel.foods)
                                    }
            }
        }
    }
}




//IDK WHAT I'M DOING HERE BUT IT'S NECESSARY SOMEHOW

@Observable
class VisionModel{
    //ERROR CASES
    enum AppError: Error{
        case noDocument
        case noTable
        case invalidPoint
        case recognitionFailed
    }
    
    var foods = [Food]()
    
    func recognizeTable(in imageData: Data) async {
        resetState()
        do{
            let extractedTable = try await extractTable(from: imageData)
            
            print(extractedTable)
            print("Hello")
            
            self.foods = parseTable(extractedTable)
        }catch{
            print("Error recognizing table: \(error)")
        }
    }
    func resetState(){
        self.foods = []
        
    }
    //EXTRACTING TABLE FROM IMAGE

    func extractTable(from imageData: Data) async throws -> DocumentObservation.Container.Table {
        // The Vision request.
            let request = RecognizeDocumentsRequest()
            
            // Perform the request on the image data and return the results.
            let observations = try await request.perform(on: imageData)

            // Get the first observation from the array.
            guard let document = observations.first?.document else {
                throw AppError.noDocument
            }
            
            // Extract the first table detected.
            guard let table = document.tables.first else {
                throw AppError.noTable
            }
            
            return table
    }

    //PROCESSING TABLE FROM IMAGE
    private func parseTable(_ table: DocumentObservation.Container.Table) -> [Food] {
        var foods = [Food]()
        
        for row in table.rows {
            guard let firstCell = row.first else {
                continue
            }
            
            // Create Food object with just the name
            foods.append(Food(name: firstCell.content.text.transcript))
        }
        
        return foods
    }


}




//VALUES OF TABLE TO BE STORED
struct Food{
    let name: String
}
#Preview {
    ScanView()
}

// Ingredients display view
struct IngredientView: View{
    @Environment(VisionModel.self) var viewModel
    var body: some View{
        Text(viewModel.foods.description)
    }
}
