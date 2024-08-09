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
    ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
    end

    respond_to do |format|
      format.html { redirect_to database_info_path, notice: 'Tutti i dati sono stati cancellati.' }
      format.json { head :no_content }
    end
  end
end
