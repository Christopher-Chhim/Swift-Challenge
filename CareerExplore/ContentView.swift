//  ContentView.swift
//  CareerExplore
//
//  Created by Christopher Chhim on 2/20/26.

import SwiftUI
struct ContentView: View {
    @State private var showingIndustryPicker = false
    @State private var selectedIndustry: String = ""
    @State private var navigateToCareers = false
    @AppStorage("isParentMode") private var isParentMode: Bool = false
    
    @State private var animateHero = false
    @State private var quickIndustries = ["Technology","Healthcare","Finance","Education","Manufacturing","Arts & Media"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.25), Color.purple.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image(systemName: "briefcase.fill")
                                .font(.system(size: 64))
                                .foregroundStyle(.blue)
                                .shadow(radius: 2)
                            Text("CareerExplore")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                        .scaleEffect(animateHero ? 1 : 0.95)
                        .opacity(animateHero ? 1 : 0.0)
                        .animation(.easeOut(duration: 0.6), value: animateHero)

                        Text("Not every student grows up with access to career guidance. This app helps you explore industries, skills, and steps to get started.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            showingIndustryPicker = true
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Explore Careers")
                                    .font(.title3).bold()
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            .scaleEffect(showingIndustryPicker ? 0.98 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingIndustryPicker)
                            .contentShape(Rectangle())
#if os(iOS) || os(watchOS) || os(tvOS)
                            .hoverEffect(.highlight)
#endif
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: 600)
                    .frame(maxWidth: .infinity)

                    // Navigation destination for CareersListView
                    .navigationDestination(isPresented: $navigateToCareers) {
                        CareersListView(industry: selectedIndustry, isParentMode: isParentMode)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
                .onAppear { animateHero = true }
            }
            .toolbar {
#if os(macOS)
    ToolbarItem(placement: .navigation) {
        Button {
            isParentMode.toggle()
        } label: {
            Label(isParentMode ? "Parent Mode On" : "Parent Mode", systemImage: isParentMode ? "person.2.fill" : "person.2")
        }
        .accessibilityIdentifier("parentModeToggle")
    }
#else
    ToolbarItem(placement: .topBarLeading) {
        Button {
            isParentMode.toggle()
        } label: {
            Label(isParentMode ? "Parent Mode On" : "Parent Mode", systemImage: isParentMode ? "person.2.fill" : "person.2")
        }
        .accessibilityIdentifier("parentModeToggle")
    }
#endif
            }
        }
        .sheet(isPresented: $showingIndustryPicker) {
            IndustryPickerSheet(selectedIndustry: $selectedIndustry) {
                navigateToCareers = true
            }
        }
    }
}

private struct IndustryPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIndustry: String
    var onDone: () -> Void = {}
    @State private var showingFavorites = false

    private let industries: [String] = [
        "Technology",
        "Healthcare",
        "Finance",
        "Education"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                let platformBackgroundColor: Color = {
#if os(macOS)
                    return Color(nsColor: .windowBackgroundColor)
#else
                    return Color(.systemBackground)
#endif
                }()
                LinearGradient(colors: [
                    platformBackgroundColor,
                    Color.gray.opacity(0.06)
                ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Which industry would you like to look at?")
                        .font(.headline)

                    Picker("Industry", selection: $selectedIndustry) {
                        ForEach(industries, id: \.self) { industry in
                            Text(industry).tag(industry)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(industries, id: \.self) { industry in
                            Button(action: {
                                selectedIndustry = industry
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: iconName(for: industry))
                                        .foregroundStyle(.blue)
                                    Text(industry)
                                    Spacer()
                                    if selectedIndustry == industry { Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue) }
                                }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Choose Industry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Continue") {
                        if selectedIndustry.isEmpty {
                            selectedIndustry = industries.first ?? ""
                        }
                        onDone()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
#if os(iOS) || os(tvOS) || os(watchOS)
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showingFavorites = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "heart.fill").foregroundStyle(.red)
                            Text("Favorites")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
#elseif os(macOS)
                // `.bottomBar` is unavailable on macOS. Use a regular toolbar item.
                ToolbarItem(placement: .status) {
                    Button {
                        showingFavorites = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "heart.fill").foregroundStyle(.red)
                            Text("Favorites")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
#endif
            }
            .sheet(isPresented: $showingFavorites) {
                FavoritesListView(onSelect: { name in
                    // If a favorite career is selected, keep the sheet open; user can dismiss
                })
            }
        }
    }
}

private func iconName(for industry: String) -> String {
    switch industry {
    case "Technology": return "cpu"
    case "Healthcare": return "cross.case"
    case "Finance": return "banknote"
    case "Education": return "book"
    default: return "briefcase"
    }
}

private func resolveIndustry(for career: CareersListView.Career) -> String {
    for (industry, careers) in CareersListView.careersByIndustry {
        if careers.contains(career) { return industry }
    }
    return ""
}

private struct FavoritesListView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("favoriteCareerNames") private var favoriteCareerNamesStorage: String = ""
    @AppStorage("isParentMode") private var isParentMode: Bool = false

    // Flatten all careers across industries to resolve details by name
    private var allCareers: [CareersListView.Career] {
        CareersListView.careersByIndustry.values.flatMap { $0 }
    }
    private var favorites: [CareersListView.Career] {
        let names = Set(favoriteCareerNamesStorage.split(separator: "|" ).map(String.init))
        return allCareers.filter { names.contains($0.name) }
    }

    var onSelect: (String) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            List {
                if favorites.isEmpty {
                    ContentUnavailableView("No Favorites Yet", systemImage: "heart", description: Text("Tap the heart on a career to add it here."))
                } else {
                    ForEach(favorites) { career in
                        NavigationLink(destination: CareerDetailView(career: career, isParentMode: isParentMode)) {
                            HStack(spacing: 12) {
                                Image(systemName: "heart.fill").foregroundStyle(.red)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(career.name).font(.headline)
                                    Text(career.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                            }
                            .padding(6)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } } }
        }
    }
}

private struct CareersListView: View {
    let industry: String
    let isParentMode: Bool
    @State private var query: String = ""
    @AppStorage("favoriteCareerNames") private var favoriteCareerNamesStorage: String = ""
    
    private var favoriteNames: Set<String> {
        get { Set(favoriteCareerNamesStorage.split(separator: "|" ).map(String.init)) }
        set { favoriteCareerNamesStorage = newValue.joined(separator: "|") }
    }
    private func isFavorite(_ career: Career) -> Bool { favoriteNames.contains(career.name) }
    private func toggleFavorite(_ career: Career) {
        var set = Set(favoriteCareerNamesStorage.split(separator: "|").map(String.init))
        if set.contains(career.name) { set.remove(career.name) } else { set.insert(career.name) }
        favoriteCareerNamesStorage = set.joined(separator: "|")
    }

    struct Career: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let description: String
        let yearsInSchool: Int
        let skills: [String]

        let projectedGrowth: String
        let salaryRange: String
        let workEnvironment: String
    }

    static let careersByIndustry: [String: [Career]] = [
        "Technology": [
            Career(name: "Software Engineer", description: "Designs, builds, and maintains software applications and systems.", yearsInSchool: 4, skills: ["Programming", "Algorithms", "Problem Solving", "Version Control"], projectedGrowth: "Faster than average", salaryRange: "$70k–$140k", workEnvironment: "Office/Hybrid"),
            Career(name: "Data Scientist", description: "Analyzes data to generate insights and build predictive models.", yearsInSchool: 4, skills: ["Statistics", "Machine Learning", "Python", "Data Visualization"], projectedGrowth: "Rapid growth", salaryRange: "$80k–$150k", workEnvironment: "Office/Remote"),
            Career(name: "Product Manager", description: "Guides product strategy, roadmap, and cross-functional execution.", yearsInSchool: 4, skills: ["Roadmapping", "Communication", "User Research", "Prioritization"], projectedGrowth: "Steady growth", salaryRange: "$85k–$160k", workEnvironment: "Office/Hybrid"),
            Career(name: "UX Designer", description: "Designs user experiences through research, wireframes, and prototypes.", yearsInSchool: 4, skills: ["User Research", "Interaction Design", "Prototyping", "Accessibility"], projectedGrowth: "Moderate growth", salaryRange: "$65k–$120k", workEnvironment: "Office/Remote")
        ],
        "Healthcare": [
            Career(name: "Registered Nurse", description: "Provides patient care, education, and support across healthcare settings.", yearsInSchool: 4, skills: ["Patient Care", "Clinical Knowledge", "Communication", "Teamwork"], projectedGrowth: "Much faster than average", salaryRange: "$60k–$100k", workEnvironment: "Hospital/Clinical"),
            Career(name: "Physician Assistant", description: "Diagnoses illnesses, develops treatment plans, and prescribes medications under physician supervision.", yearsInSchool: 6, skills: ["Clinical Assessment", "Anatomy", "Decision Making", "Empathy"], projectedGrowth: "Rapid growth", salaryRange: "$90k–$130k", workEnvironment: "Clinical/Hospital"),
            Career(name: "Pharmacist", description: "Dispenses medications and advises on safe usage and interactions.", yearsInSchool: 6, skills: ["Pharmacology", "Attention to Detail", "Counseling", "Regulations"], projectedGrowth: "Stable", salaryRange: "$100k–$140k", workEnvironment: "Pharmacy/Clinical"),
            Career(name: "Medical Technologist", description: "Performs laboratory tests to help diagnose and treat diseases.", yearsInSchool: 4, skills: ["Lab Techniques", "Quality Control", "Instrumentation", "Data Analysis"], projectedGrowth: "Average growth", salaryRange: "$50k–$80k", workEnvironment: "Laboratory")
        ],
        "Finance": [
            Career(name: "Financial Analyst", description: "Evaluates financial data to support investment and business decisions.", yearsInSchool: 4, skills: ["Excel", "Financial Modeling", "Accounting", "Communication"], projectedGrowth: "Average growth", salaryRange: "$60k–$110k", workEnvironment: "Office"),
            Career(name: "Accountant", description: "Manages financial records and ensures compliance with standards.", yearsInSchool: 4, skills: ["GAAP", "Tax", "Auditing", "Detail Orientation"], projectedGrowth: "Stable", salaryRange: "$55k–$95k", workEnvironment: "Office"),
            Career(name: "Investment Banker", description: "Advises on mergers, acquisitions, and capital raising.", yearsInSchool: 4, skills: ["Valuation", "Pitching", "Negotiation", "Resilience"], projectedGrowth: "Moderate growth", salaryRange: "$80k–$180k", workEnvironment: "Office/High Pressure"),
            Career(name: "Risk Manager", description: "Identifies and mitigates financial and operational risks.", yearsInSchool: 4, skills: ["Risk Assessment", "Regulations", "Analytical Thinking", "Reporting"], projectedGrowth: "Steady growth", salaryRange: "$70k–$130k", workEnvironment: "Office")
        ],
        "Education": [
            Career(name: "Teacher", description: "Plans and delivers instruction to help students learn.", yearsInSchool: 4, skills: ["Classroom Management", "Lesson Planning", "Assessment", "Communication"], projectedGrowth: "Average growth", salaryRange: "$40k–$70k", workEnvironment: "School"),
            Career(name: "School Counselor", description: "Supports students' academic, social, and emotional development.", yearsInSchool: 6, skills: ["Counseling", "Crisis Intervention", "Confidentiality", "Collaboration"], projectedGrowth: "Stable", salaryRange: "$50k–$80k", workEnvironment: "School"),
            Career(name: "Curriculum Designer", description: "Develops educational materials and standards-aligned curricula.", yearsInSchool: 4, skills: ["Instructional Design", "Standards Alignment", "Writing", "Research"], projectedGrowth: "Growing", salaryRange: "$55k–$90k", workEnvironment: "Office/Remote"),
            Career(name: "Education Administrator", description: "Oversees school operations, policy, and staff.", yearsInSchool: 6, skills: ["Leadership", "Budgeting", "Policy", "Conflict Resolution"], projectedGrowth: "Average growth", salaryRange: "$70k–$110k", workEnvironment: "Office/School")
        ]
    ]

    var careers: [Career] {
        CareersListView.careersByIndustry[industry] ?? []
    }
    
    var filteredCareers: [Career] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return careers }
        return careers.filter { 
            $0.name.lowercased().contains(q) || 
            $0.description.lowercased().contains(q) || 
            $0.skills.joined(separator: " ").lowercased().contains(q) 
        }
    }

    var body: some View {
        List {
            ForEach(filteredCareers) { career in
                NavigationLink(destination: CareerDetailView(career: career, isParentMode: isParentMode)) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: iconName(for: industry))
                            .font(.title2)
                            .foregroundStyle(.blue)
                            .frame(width: 36)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(career.name).font(.headline)
                        }
                        Spacer(minLength: 0)
                        Button(action: { toggleFavorite(career) }) {
                            Image(systemName: isFavorite(career) ? "heart.fill" : "heart")
                                .foregroundStyle(isFavorite(career) ? .red : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(10)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
#if os(macOS)
        .searchable(text: $query, prompt: "Search roles or skills")
#else
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search roles or skills")
#endif
    }
}

private struct CareerDetailView: View {
    let career: CareersListView.Career
    let isParentMode: Bool
    @State private var isFavorite: Bool = false
    @AppStorage("favoriteCareerNames") private var favoriteCareerNamesStorage: String = ""
    
    private var favoriteNames: Set<String> {
        get { Set(favoriteCareerNamesStorage.split(separator: "|" ).map(String.init)) }
        set { favoriteCareerNamesStorage = newValue.joined(separator: "|") }
    }
    private func setFavorite(_ on: Bool) {
        var set = Set(favoriteCareerNamesStorage.split(separator: "|").map(String.init))
        if on { set.insert(career.name) } else { set.remove(career.name) }
        favoriteCareerNamesStorage = set.joined(separator: "|")
    }

    var body: some View {
        ScrollView {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Image(systemName: iconName(for: resolveIndustry(for: career)))
                                .foregroundStyle(.blue)
                            Text(career.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Text(career.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    HStack {
                        Spacer()
                        Button(action: { isFavorite.toggle(); setFavorite(isFavorite) }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(isFavorite ? .red : .secondary)
                                .imageScale(.large)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: "graduationcap.fill")
                                .foregroundStyle(.blue)
                            Text("Years in school: \(career.yearsInSchool)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Text("Skills: \(career.skills.joined(separator: ", "))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    VStack(alignment: .leading, spacing: 8) {
                        WrapHStack(spacing: 8, lineSpacing: 8) {
                            ForEach(career.skills, id: \.self) { skill in
                                Button(action: {}) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                                        Text(skill)
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(.thinMaterial)
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    if isParentMode {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Parent Insights").font(.headline)
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) { Image(systemName: "chart.line.uptrend.xyaxis").foregroundStyle(.green); Text("Projected Growth: \(career.projectedGrowth)") }
                                HStack(spacing: 8) { Image(systemName: "dollarsign.circle").foregroundStyle(.teal); Text("Salary Range: \(career.salaryRange)") }
                                HStack(spacing: 8) { Image(systemName: "building.2").foregroundStyle(.orange); Text("Work Environment: \(career.workEnvironment)") }
                            }
                        }
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .background(.ultraThinMaterial)
                    }

                    Spacer(minLength: 0)
                }
                .padding()
                .onAppear { isFavorite = favoriteNames.contains(career.name) }
            }
        }
    }
}

private struct WrapHStack<Content: View>: View {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    @ViewBuilder var content: () -> Content

    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            var x: CGFloat = 0
            var y: CGFloat = 0

            ZStack(alignment: .topLeading) {
                Color.clear
                content()
                    .alignmentGuide(.leading) { d in
                        if (abs(x - d.width) > width) {
                            x = 0
                            y -= (d.height + lineSpacing)
                        }
                        let result = x
                        if d.width < width { x -= (d.width + spacing) } else { x = 0 }
                        return result
                    }
                    .alignmentGuide(.top) { _ in y }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}

