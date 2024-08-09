class DatabaseController < ApplicationController
  def info
    @tables = ActiveRecord::Base.connection.tables
    @table_data = {}

    @tables.each do |table|
      columns = ActiveRecord::Base.connection.columns(table).map(&:name)
      records = ActiveRecord::Base.connection.execute("SELECT * FROM #{table}")
      @table_data[table] = { columns: columns, records: records.to_a }
    end
  end

  def clear_tables
      ActiveRecord::Base.connection.tables.each do |table_name|
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name} CASCADE")
      end
      render json: { message: 'Tutte le tabelle sono state svuotate!' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
end
