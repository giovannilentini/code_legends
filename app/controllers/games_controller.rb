class GamesController < ApplicationController
  def index
    @selected_language = "javascript"
  end

  def execute_code
    response = JdoodleService.execute_code(params[:code], params[:language])
    p response
    if response.code == 200
      @result = JSON.parse(response.body)["output"]
    else
      p JSON.parse(response.body)
      @result = JSON.parse(response.body)["output"]
    end
    respond_to do |format|
      format.turbo_stream
    end
  end
end
