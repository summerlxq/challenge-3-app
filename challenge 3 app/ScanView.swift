//IMPORTS
import SwiftUI
import PhotosUI
import Vision
import DataDetection

//VIEW + UI
struct ScanView: View{
    @State private var selectedItem: PhotosPickerItem? // holds the selected photo
    @State private var selectedImage: UIImage? //holds the loaded image
    @State private var showingCamera = false //control camera sheet visibility
    @State private var viewModel = VisionModel()
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
            }
            .sheet(isPresented: $showingCamera){
                CameraView(image: $selectedImage)
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
            }
            .onChange(of:selectedItem){ newItem in
                if let newItem = newItem{
                    Task{
                        if let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data){
                            selectedImage = image // update the selected image
                        }
                    }
                }
                
            }
        }
        .task{
            if selectedImage != nil{
                await viewModel.recognizeTable(in: (selectedImage?.pngData())!)
                
            }
        }
    }
}




//IDK WHAT I'M DOING HERE BUT IT'S NECESSARY SOMEHOW

class VisionModel{
    //ERROR CASES
    enum AppError: Error{
        case noDocument
        case noTable
        case invalidPoint
    }
    var table: DocumentObservation.Container.Table? = nil
    var foods = [Food]()
    
    func recognizeTable(in image: Data) async {
        resetState()
        do{
            let table = try await extractTable(from: image)
            self.table = table
            self.foods = parseTable(table)
        }catch{
            print(error)
        }
    }
    func resetState(){
        self.table = nil
        self.foods = []
        
    }
    //EXTRACTING TABLE FROM IMAGE

    func extractTable(from image: Data) async throws -> DocumentObservation.Container.Table {
        
        // The Vision request.
        let request = RecognizeDocumentsRequest()
        
        // Perform the request on the image data and return the results.
        let observations = try await request.perform(on: image)

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
                guard let firstCell = row.first else { continue }
                
                let name = firstCell.content.text.transcript
                
                // Create Food object with just the name
                foods.append(Food(name: name))
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
