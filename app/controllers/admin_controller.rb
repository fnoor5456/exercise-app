class AdminController < ApplicationController
  def admin
      puts("displaying admin page")
      
      @trainers = []
      @users = User.all
      
      @users.each do |u|
        if u.is_trainer?
          @trainers.push(u)
        end
      end
      
      @trainers = [] if (@trainers.nil?)
  end
  
  def process_delete_client
    trainer_id = params[:trainer_id]
    client_id = params[:client_id]
    ClientTrainerRelation.delete_client(client_id)
  end

end
