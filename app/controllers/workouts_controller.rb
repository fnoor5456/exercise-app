class WorkoutsController < AuthenticationController
  
  public
  
  def new
  end
  
  def homepage
    puts("Go back to the homepage")
  end
  
  def my_workouts
    puts("Displaying my workouts page")
    puts("User has id: #{current_effective_user.id}")
    @workouts = current_effective_user.workout
    @workouts = [] if (@workouts.nil?)
  end
  
  def create_workout
    puts("Displaying create workout page")
  end
  
  def process_create_workout
    puts("Inserting new workout to database...")
    workout_name = params[:workout_name]
    task_card_data = params[:task_card_data]
    user = current_effective_user
    
    Workout.insert_new_workout(user, workout_name, task_card_data, State.saved, State.saved, State.saved)

    puts("New workout inserted")
    puts("!"*100)
    render json: { redirect_path: my_workouts_path }
  end
  
  def process_complete_workout
    workout_id = params[:workout_id]

    puts("Marking workout #{workout_id} as complete...")
    Workout.update_state(workout_id, State.complete)
    puts("done.")
    render json: { status: 200 }
  end
  
  def process_delete_workout
    workout_id = params[:workout_id]
    
    puts("Deleting workout #{workout_id}...")
    Workout.delete_workout(workout_id)
    puts("done.")
    render json: {status: 200}
  end
  
  def process_clone_workout
    workout_id = params[:workout_id]
    
    puts("Cloning a workout")
    clone_id, clone_task_id_hash, clone_set_id_hash = Workout.clone(current_effective_user, workout_id)
    puts("done.")
    
    render json: {clone_id: clone_id, clone_task_id_hash: clone_task_id_hash, clone_set_id_hash: clone_set_id_hash}
  end
  
  def process_update_workout_state
    workout_id = params[:workout_id]
    new_state = params[:state]
    
    puts("Updating workout state...")
    
    if State.valid_state?(new_state) then
      Workout.update_state(workout_id, new_state)
      puts("done.")
      render json: { status: 200 }
    else
      puts("Invalid workout state #{new_state}")
      render json: { status: 500 }
    end
    
  end
  
  def process_update_exercise_set
    exercise_set_id = params[:exercise_set_id]
    rep_count = params[:rep_count]
    rep_value = params[:rep_value]
    
    puts("Updating exercise set with id: #{exercise_set_id}")
    puts("\t new rep count: #{rep_count}")
    puts("\t new rep value: #{rep_value}")
    ExerciseSet.update_exercise_set(exercise_set_id, rep_count, rep_value)
    puts("done.")
    
    render json: { status: 200 }
  end
  
  def search_exercises_json
    @exercises = Exercise.search(params[:term])
    respond_to :json
  end
  
  def units_json
    puts("dumping units from database")
    @units = Unit.all()
    respond_to :json
  end
  
end
