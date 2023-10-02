import Foundation

enum FileDataType: String {
    case image = "image/png"
    case video = "video/mp4"
    case audio = "audio/mp3"
}

struct BaseFile {
    
    var data: Data?
    
    var name: String?
    
    var type: FileDataType = .image
    
    var fileName: String {
        switch type {
        case .image:
            return "\(self.name ?? "image").png"
        case .video:
            return "\(self.name ?? "video").mp4"
        case .audio:
            return "\(self.name ?? "audio").mp3"
        }
    }
}
