class VocabulariesController < ApplicationController
  before_action :set_vocabulary, only: [:show, :edit, :update, :destroy]

  # GET /vocabularies
  def index
    @vocabularies = Vocabulary.all
  end

  # GET /vocabularies/1
  def show
  end

  # GET /vocabularies/new
  def new
    @vocabulary = Vocabulary.new
  end

  # GET /vocabularies/1/edit
  def edit
  end

  # POST /vocabularies
  def create
    @vocabulary = Vocabulary.new(vocabulary_params)

    if @vocabulary.save
      redirect_to @vocabulary, notice: 'Vocabulary was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /vocabularies/1
  def update
    if @vocabulary.update(vocabulary_params)
      redirect_to @vocabulary, notice: 'Vocabulary was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /vocabularies/1
  def destroy
    @vocabulary.delete
    redirect_to vocabularies_url, notice: 'Vocabulary was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocabulary
      @vocabulary = Vocabulary[params[:id]]
    end

    # Only allow a trusted parameter "white list" through.
    def vocabulary_params
      params.require(:vocabulary).permit(:name, entries: [[:id, :name, :description]])
    end
end
