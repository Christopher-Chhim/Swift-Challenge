import Foundation
import SwiftUI

struct AppData: Codable {
    var industries: [Industry]
}

struct Industry: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var summary: String
    var careers: [Career]
}

struct Career: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var overview: String
    var steps: [String]
    var parentTips: [String]
}

@Observable
final class AppDataStore {
    var data: AppData
    
    init() {
        if let loaded: AppData = JSONLoader.load("careers.json") {
            self.data = loaded
        } else {
            self.data = AppData(industries: SampleData.industries)
        }
    }
}

enum JSONLoader {
    static func load<T: Decodable>(_ fileName: String, decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let url = Bundle.main.url(forResource: fileName.replacingOccurrences(of: ".json", with: ""), withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}

enum SampleData {
    static let industries: [Industry] = [
        Industry(
            id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
            name: "Healthcare",
            summary: "Caring for people through science and compassion.",
            careers: [
                Career(
                    id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAA001")!,
                    title: "Registered Nurse",
                    overview: "RNs support patients, coordinate care, and educate families.",
                    steps: [
                        "Take biology and chemistry in high school",
                        "Earn a nursing degree (ADN or BSN)",
                        "Pass the NCLEX-RN exam",
                        "Gain clinical experience"
                    ],
                    parentTips: [
                        "Encourage volunteering at clinics",
                        "Support study habits for science courses"
                    ]
                ),
                Career(
                    id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAA002")!,
                    title: "Medical Assistant",
                    overview: "Assist with exams, take vitals, and manage clinic tasks.",
                    steps: [
                        "Focus on communication and organization",
                        "Complete a medical assisting program",
                        "Practice basic clinical skills",
                        "Apply to outpatient clinics"
                    ],
                    parentTips: [
                        "Help practice professional communication",
                        "Explore community health resources"
                    ]
                )
            ]
        ),
        Industry(
            id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!,
            name: "Technology",
            summary: "Building software and systems that power the world.",
            careers: [
                Career(
                    id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBB001")!,
                    title: "iOS Developer",
                    overview: "Design and build apps for iPhone and iPad.",
                    steps: [
                        "Learn Swift basics",
                        "Build small SwiftUI projects",
                        "Study app architecture",
                        "Publish a simple app or share a Playground"
                    ],
                    parentTips: [
                        "Provide time and space for coding",
                        "Celebrate small project milestones"
                    ]
                ),
                Career(
                    id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBB002")!,
                    title: "Data Analyst",
                    overview: "Turn raw data into insights and stories.",
                    steps: [
                        "Strengthen math and spreadsheets",
                        "Learn a data tool (Python, SQL)",
                        "Practice with public datasets",
                        "Create a simple portfolio"
                    ],
                    parentTips: [
                        "Discuss real-world uses of data",
                        "Encourage clear communication of findings"
                    ]
                )
            ]
        ),
        Industry(
            id: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")!,
            name: "Creative Arts",
            summary: "Expressing ideas through design and media.",
            careers: [
                Career(
                    id: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCC01")!,
                    title: "Graphic Designer",
                    overview: "Create visuals for brands, apps, and products.",
                    steps: [
                        "Learn design basics and color theory",
                        "Practice with free design tools",
                        "Build a small portfolio",
                        "Offer to design for school clubs"
                    ],
                    parentTips: [
                        "Provide constructive feedback",
                        "Encourage sharing work with others"
                    ]
                ),
                Career(
                    id: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCC02")!,
                    title: "Video Editor",
                    overview: "Tell stories by editing footage and audio.",
                    steps: [
                        "Capture clips with a phone",
                        "Learn a simple editing app",
                        "Practice pacing and audio",
                        "Edit a short story or recap"
                    ],
                    parentTips: [
                        "Watch short films together",
                        "Discuss storytelling choices"
                    ]
                )
            ]
        )
    ]
}
