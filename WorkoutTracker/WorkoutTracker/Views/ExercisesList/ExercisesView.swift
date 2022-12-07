//
//  ExercisesView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI
import AlertToast

struct ExercisesView: View {
    @Binding var exercises: [Exercise]
    @State var isPresentingNewExerciseView = false;
    @State var isPresentingConfirmDeletionView = false
    @State var isPresentingFilterView = false

    @State var newExercise = Exercise.FormData()
    @State var errorInExerciseEditView = false

    @State var selectedExercise: Exercise? = nil
    @State var isFilterActive: Bool = false
    @State var newFilter: Category? = nil
    @State var filteredExercises: [Exercise] = []
    @State var categoryFilter: Category? = nil
    @State var noFilterSelectedErrorShowing: Bool = false

    var body: some View {
        List {
            ForEach(categoryFilter == nil ? $exercises : $filteredExercises) { $exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: $exercise)) {
                    ExerciseListItemView(exercise: exercise)
                }
                        .contextMenu {
                            Button(role: .destructive) {
                                selectedExercise = exercise
                                isPresentingConfirmDeletionView = true
                            } label: {
                                Label("delete-exercise", systemImage: "trash")
                            }
                        }
                        .alert(String(format: NSLocalizedString("deletion-confirmation", comment: "The deletion confirmation dialog for exercises"), selectedExercise?.name ?? ""), isPresented: $isPresentingConfirmDeletionView) {
                            Button(NSLocalizedString("delete-exercise", comment: "Second deletion confirmation button"), role: .destructive) {
                                ExercisesService.delete(id: selectedExercise!.id) { didAlsoDeleteCategory in
                                    let index: Int? = exercises.firstIndex(where: { selectedExercise!.id == $0.id })

                                    DispatchQueue.main.async {
                                        exercises.remove(at: index!)
                                        if (didAlsoDeleteCategory) {
                                            let categoryIndex: Int? = Exercise.categories.firstIndex {
                                                selectedExercise?.category.id == $0.id
                                            }
                                            Exercise.categories.remove(at: categoryIndex!)
                                            isPresentingConfirmDeletionView = false
                                            selectedExercise = nil
                                        }

                                    }
                                }

                            }
                        }
            }
        }
                .navigationTitle("exercises")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresentingFilterView = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(categoryFilter != nil ? .green : .accentColor)
                        }
                        Button(action: {
                            isPresentingNewExerciseView = true
                        }) {
                            Image(systemName: "plus")

                        }


                    }
                }
                .sheet(isPresented: $isPresentingNewExerciseView) {
                    NavigationView {
                        ExerciseEditView(data: $newExercise, hasConnectionError: $errorInExerciseEditView)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button(NSLocalizedString("dismiss", comment: "Dismiss Button")) {
                                            isPresentingNewExerciseView = false
                                            newExercise = Exercise.FormData()
                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button(NSLocalizedString("add", comment: "Add Button")) {
                                            let exercise = Exercise(data: newExercise)
                                            ExercisesService.save(exercise: exercise) { isSuccess in
                                                if (isSuccess) {
                                                    isPresentingNewExerciseView = false
                                                    DispatchQueue.main.async {
                                                        exercises.append(exercise)
                                                    }
                                                    newExercise = Exercise.FormData()
                                                } else {
                                                    errorInExerciseEditView = true
                                                }

                                            }
                                        }
                                    }
                                }
                    }
                }
                .sheet(isPresented: $isPresentingFilterView) {
                    NavigationView {
                        FilterView(filter: $newFilter)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button(NSLocalizedString("dismiss", comment: "Dismiss Button")) {
                                            newFilter = categoryFilter
                                            isPresentingFilterView = false
                                        }
                                    }
                                    ToolbarItemGroup(placement: .confirmationAction) {
                                        Button {
                                            categoryFilter = newFilter

                                            if (categoryFilter == nil) {
                                                filteredExercises = []
                                                isPresentingFilterView = false
                                                return
                                            }

                                            filteredExercises = exercises.filter { exercise in
                                                exercise.category == categoryFilter
                                            }
                                            isPresentingFilterView = false

                                        } label: {
                                            Label("apply-filter", systemImage: "line.3.horizontal.decrease")
                                        }
                                        Button {
                                            categoryFilter = newFilter

                                            if (categoryFilter == nil) {
                                                noFilterSelectedErrorShowing = true
                                                return
                                            }
                                            filteredExercises = [exercises.filter { exercise in
                                                        exercise.category == categoryFilter
                                                    }
                                                    .randomElement()!]
                                            isPresentingFilterView = false
                                        } label: {
                                            Label("show-random-exercise", systemImage: "shuffle")
                                        }
                                    }
                                    ToolbarItem(placement: .bottomBar) {
                                        Button("clear-filter") {
                                            newFilter = nil
                                            categoryFilter = nil
                                            filteredExercises = []
                                            isPresentingFilterView = false
                                        }
                                    }
                                }
                    }
                            .toast(isPresenting: $noFilterSelectedErrorShowing, duration: 3) {
                                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: NSLocalizedString("no-filter-active", comment: "Title of the filter error alert toast"), subTitle: NSLocalizedString("no-filter-active-subtext", comment: "Message that filter should be selected"))
                            }
                }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExercisesView(exercises: .constant(ExercisesService.sampleData.exercises))
        }
    }
}
