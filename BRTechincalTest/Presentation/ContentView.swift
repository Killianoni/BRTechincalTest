//
//  ContentView.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 07/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //MARK: Private properties
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ContentViewModel?
    @State private var selectedStory: Story?

    //MARK: Body
    var body: some View {
        Group {
            if let viewModel = viewModel {
                VStack {
                    if viewModel.isLoading && viewModel.stories.isEmpty {
                        ProgressView("Loading stories...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !viewModel.sortedStories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(viewModel.sortedStories) { story in
                                    StoryView(story: story) {
                                        selectedStory = story
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 90)
                        }
                        .padding()

                        Spacer()
                    }
                }
                .fullScreenCover(item: $selectedStory) { story in
                    StoryDetailView(
                        story: story,
                        allStories: viewModel.sortedStories,
                        onMarkSeen: viewModel.markStoryAsSeen,
                        onToggleLike: viewModel.toggleStoryLike
                    )
                }
            } else {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            if viewModel == nil {
                let repository = StoryRepository(modelContext: modelContext)
                let useCase = StoryUseCase(repository: repository)
                viewModel = ContentViewModel(useCase: useCase)
                viewModel?.loadStories()
            }
        }
    }
}

//MARK: Preview
#Preview {
    {
        let container = try! ModelContainer(
            for: Story.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = container.mainContext
        Story.allMockStories.forEach { context.insert($0) }

        return ContentView()
            .modelContainer(container)
    }()
}
