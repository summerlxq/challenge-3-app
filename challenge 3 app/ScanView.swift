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
        .onChange(of: selectedImage) { _, newImage in
            if let newImage = newImage, let imageData = newImage.pngData() {
                Task {
                    await viewModel.recognizeTable(in: imageData)
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
    var table: [[String]] = []
    var foods = [Food]()
    
    func recognizeTable(in imageData: Data) async {
        resetState()
        do{
            let extractedTable = try await extractTable(from: imageData)
            self.table = extractedTable
            self.foods = parseTable(extractedTable)
        }catch{
            print("Error recognizing table: \(error)")
        }
    }
    func resetState(){
        self.table = []
        self.foods = []
        
    }
    //EXTRACTING TABLE FROM IMAGE

    func extractTable(from imageData: Data) async throws -> [[String]] {
        guard let cgImage = UIImage(data: imageData)?.cgImage else {
            throw AppError.noDocument
        }
        
        // The Vision request for text recognition
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        // Perform the request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        
        // Get the recognized text observations
        guard let observations = request.results, !observations.isEmpty else {
            throw AppError.noTable
        }
        
        // Group text by approximate rows (by Y coordinate)
        var rows: [[String]] = []
        var currentRow: [(text: String, y: CGFloat)] = []
        var lastY: CGFloat = -1
        let rowThreshold: CGFloat = 0.05 // Adjust this value based on your needs
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            let text = topCandidate.string
            let boundingBox = observation.boundingBox
            let y = boundingBox.origin.y
            
            // Check if this is a new row
            if lastY >= 0 && abs(y - lastY) > rowThreshold {
                // Save the current row and start a new one
                if !currentRow.isEmpty {
                    rows.append(currentRow.sorted { $0.y > $1.y }.map { $0.text })
                    currentRow = []
                }
            }
            
            currentRow.append((text, y))
            lastY = y
        }
        
        // Add the last row
        if !currentRow.isEmpty {
            rows.append(currentRow.sorted { $0.y > $1.y }.map { $0.text })
        }
        
        // Sort rows by Y coordinate (top to bottom)
        rows.sort { row1, row2 in
            guard let first1 = row1.first, let first2 = row2.first else { return false }
            return first1 > first2
        }
        
        return rows
    }

    //PROCESSING TABLE FROM IMAGE
    private func parseTable(_ table: [[String]]) -> [Food] {
        var foods = [Food]()
        
        for row in table {
            guard let firstCell = row.first, !firstCell.isEmpty else { continue }
            
            // Create Food object with just the name
            foods.append(Food(name: firstCell))
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
