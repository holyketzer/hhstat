class VacanciesController < ApplicationController
  before_action :set_vacancy, only: [:show, :edit, :update, :destroy]

  # GET /vacancies
  # GET /vacancies.json
  def index
    @vacancies = Vacancy.all
  end

  # GET /vacancies/1
  # GET /vacancies/1.json
  def show
  end

  # GET /vacancies/new
  def new
    @vacancy = Vacancy.new
  end

  # GET /vacancies/1/edit
  def edit
  end

  # POST /vacancies
  # POST /vacancies.json
  def create
    @vacancy = Vacancy.new(vacancy_params)

    respond_to do |format|
      if @vacancy.save
        format.html { redirect_to @vacancy, notice: 'Vacancy was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vacancy }
      else
        format.html { render action: 'new' }
        format.json { render json: @vacancy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacancies/1
  # PATCH/PUT /vacancies/1.json
  def update
    respond_to do |format|
      if @vacancy.update(vacancy_params)
        format.html { redirect_to @vacancy, notice: 'Vacancy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vacancy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacancies/1
  # DELETE /vacancies/1.json
  def destroy
    @vacancy.destroy
    respond_to do |format|
      format.html { redirect_to vacancies_url }
      format.json { head :no_content }
    end
  end

  def parse
    id = params[:id]

    require 'rest_client'
    response = RestClient.get "https://api.hh.ru/vacancies/#{id}"
    if response.code == 200
      data = JSON.parse(response.to_s)
      new_vacancy = Vacancy.parse(data)
      if new_vacancy.save                
        redirect_to new_vacancy, notice: 'Vacancy was successfully created.'
      else
        render text: "Error parsing"
      end
    else
      render text: "Error getting"
    end
  end

  def parse_all    
    per_page = 10
    page = 0
    query = "https://api.hh.ru/vacancies?specialization=1.221&per_page=#{per_page}&page=%s"
    require 'rest_client'
    while true
      logger.info ">> try to get #{query % page}"
      response = RestClient.get query % page
      if response.code == 200
        arr = JSON.parse(response.to_s)
        arr["items"].each do |data|
          new_vacancy = Vacancy.parse(data)
          if new_vacancy.save                
            #redirect_to new_vacancy, notice: 'Vacancy was successfully created.'
          else
            logger.error "error on parse request"
          end
        end
        page += 1
        logger.info ">> total pages count = #{arr["pages"].to_i}"
        break if page >= arr["pages"].to_i
      else
        logger.error "error on get request"
      end
      sleep 5 
    end
    redirect_to vacancies_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacancy
      @vacancy = Vacancy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacancy_params
      params.require(:vacancy).permit(:salary_from, :salary_to, :name, :area_id, :created, :employer_id)
    end
end
