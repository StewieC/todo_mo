import List "mo:base/List";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Nat "mo:base/Nat";

actor {
  // Define a Task type
  type Task = {
    id: Nat;
    description: Text;
    completed: Bool;
  };

  // Stable storage for tasks
  stable var tasks: List.List<Task> = List.nil<Task>();
  stable var nextId: Nat = 0;

  // Add a new task
  public func addTask(description: Text) : async Nat {
    let task = {
      id = nextId;
      description = description;
      completed = false;
    };
    tasks := List.push(task, tasks);
    nextId := nextId + 1;
    return task.id;
  };

  // Get all tasks
  public query func getTasks() : async [Task] {
    List.toArray(tasks)
  };

  // Mark a task as completed
  public func completeTask(id: Nat) : async Bool {
    var found = false;
    tasks := List.map<Task, Task>(
      tasks,
      func(task: Task) : Task {
        if (task.id == id) {
          found := true;
          { id = task.id; description = task.description; completed = true }
        } else {
          task
        }
      }
    );
    return found;
  };

  // Delete a task
  public func deleteTask(id: Nat) : async Bool {
    let originalLength = List.size(tasks);
    tasks := List.filter<Task>(
      tasks,
      func(task: Task) : Bool {
        task.id != id
      }
    );
    return List.size(tasks) < originalLength;
  };
};