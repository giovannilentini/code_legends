class DatabaseController < ApplicationController
  before_action :authenticate_user!

  def info
    @tables = %w[users challenges matches matchmaking_queues friendship friend_requests chat_messages challenge_requests]
    @table_data = @tables.each_with_object({}) do |table, hash|
      model = table.classify.constantize rescue nil
      if model
        hash[table] = { columns: model.column_names, records: model.all }
      end
    end
  end

  protect_from_forgery with: :exception

  def clear_tables
    authorize! :manage, :all 
    begin
      ActiveRecord::Base.descendants.each do |model|
        next if model.abstract_class?

        model.delete_all
      end

      render json: { message: 'Le tabelle sono state svuotate con successo.' }, status: :ok
    rescue => e
      render json: { message: "Errore durante l'eliminazione delle tabelle: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def authenticate_user!
    unless user_signed_in? && (current_user.admin? || !current_user.guest?)
      flash[:alert] = "You must be logged in as a user or admin to access this page."
      redirect_to root_path
    end
  end
end