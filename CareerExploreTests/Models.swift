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
    var yearsInSchool: Int
    var skills: [String]
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
                    yearsInSchool: 2,
                    skills: ["Biology", "Communication"],
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
                    yearsInSchool: 1,
                    skills: ["Organization", "Clinical basics"],
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
                    yearsInSchool: 2,
                    skills: ["Swift", "SwiftUI"],
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
                    yearsInSchool: 2,
                    skills: ["Spreadsheets", "SQL"],
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
            id: UUID(uuidString: "DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD")!,
            name: "Business",
            summary: "Building and managing organizations and products.",
            careers: [
                Career(
                    id: UUID(uuidString: "DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDD001")!,
                    title: "Marketing Coordinator",
                    overview: "Plan campaigns, analyze results, and support brand growth.",
                    yearsInSchool: 4,
                    skills: ["Communication", "Analytics"],
                    steps: [
                        "Learn basics of marketing and branding",
                        "Practice with social media and analytics",
                        "Work on a small campaign project",
                        "Build a simple portfolio"
                    ],
                    parentTips: [
                        "Discuss how ads influence decisions",
                        "Encourage clear writing and presentations"
                    ]
                ),
                Career(
                    id: UUID(uuidString: "DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDD002")!,
                    title: "Project Manager",
                    overview: "Organize teams, timelines, and budgets to deliver results.",
                    yearsInSchool: 4,
                    skills: ["Organization", "Leadership"],
                    steps: [
                        "Practice planning and time management",
                        "Learn basic project tools (Kanban, Gantt)",
                        "Lead a small team project",
                        "Document outcomes and lessons learned"
                    ],
                    parentTips: [
                        "Support planning habits at home",
                        "Celebrate team-based achievements"
                    ]
                )
            ]
        ),
        Industry(
            id: UUID(uuidString: "EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE")!,
            name: "Education",
            summary: "Teaching, mentoring, and supporting student growth.",
            careers: [
                Career(
                    id: UUID(uuidString: "EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEE001")!,
                    title: "Elementary School Teacher",
                    overview: "Teach core subjects and support young learners.",
                    yearsInSchool: 4,
                    skills: ["Communication", "Patience"],
                    steps: [
                        "Study education and child development",
                        "Complete student teaching",
                        "Earn a teaching credential",
                        "Start in a classroom or tutoring role"
                    ],
                    parentTips: [
                        "Encourage reading and mentoring",
                        "Support classroom volunteering"
                    ]
                ),
                Career(
                    id: UUID(uuidString: "EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEE002")!,
                    title: "School Counselor",
                    overview: "Guide students with academics, careers, and well-being.",
                    yearsInSchool: 6,
                    skills: ["Listening", "Problem Solving"],
                    steps: [
                        "Earn a bachelor’s degree",
                        "Complete a counseling master’s program",
                        "Gain internship experience",
                        "Obtain state certification"
                    ],
                    parentTips: [
                        "Discuss emotional well-being",
                        "Normalize asking for help"
                    ]
                )
            ]
        )
    ]
}
