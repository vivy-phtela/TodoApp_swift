import SwiftUI

struct ContentView: View {
    @State var activeTasks: [TaskData] = [] // タスク
    @State var completedTasks: [TaskData] = [] // 完了タスク
    @State var newTaskTitle = "" // 新しいタスク
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("新たなタスクを追加")) { // タスク追加のセクション
                    HStack {
                        TextField("タスクを追加", text: $newTaskTitle)
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primary) // システムカラーに応じて自動で変更
                        }
                    }
                }
                
                Section(header: Text("タスク")) { // タスク表示のセクション
                    ForEach(activeTasks) { task in
                        Button {
                            completeTask(task)
                        } label: {
                            HStack {
                                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                Text(task.title)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete(perform: deleteTask) // スワイプしたら削除
                }
                
                Section(header: Text("完了タスク")) { // 完了タスク表示のセクション
                    ForEach(completedTasks) { task in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(task.title)
                        }
                    }
                    .onDelete(perform: deleteTask) // スワイプしたら削除
                }
            }
            .navigationTitle("ToDo") // タイトル
            Text("© 2024 tsubasa_phtela") // コピーライト
            .foregroundColor(.primary)
            .font(.footnote)
        }
    }

    func addTask() { // タスクを追加する関数
        let taskTitle = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines) // 入力文の空白や改行を削除
        guard !taskTitle.isEmpty else { return newTaskTitle = ""} // タイトルが空でないことを確認し，空の場合はテキストフィールドをクリア
        
        let newTask = TaskData(title: taskTitle, completed: false)
        activeTasks.append(newTask)
        newTaskTitle = "" // テキストフィールドをクリア
    }

    func completeTask(_ task: TaskData) { // タスクを完了とマークする関数
        if let index = activeTasks.firstIndex(where: { $0.id == task.id }) { // 関数に渡されたtaskと同じIDを持つタスクを検索
            activeTasks[index].completed = true // 完了にする
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2秒後に完了タスクに移動
                let completedTask = activeTasks.remove(at: index) // タスクから削除
                completedTasks.append(completedTask) // 完了タスクに移動
            }
        }
    }
    
    func deleteTask(at offsets: IndexSet) { // タスクを削除する関数
        activeTasks.remove(atOffsets: offsets) // offsetsには削除する項目のインデックスが含まれる
    }
}

struct TaskData: Identifiable { // Iden~はIDプロパティを必須とするプロトコルで要素を一意に識別可能にするため
    var id = UUID() // UUIDは識別子の規格で自動で一意のIDをつけてくれる
    var title: String
    var completed: Bool // タスクが完了しているかのフラグ
}

//#Preview { // プレビュー
//    ContentView()
//}
