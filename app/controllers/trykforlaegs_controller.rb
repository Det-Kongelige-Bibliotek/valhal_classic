class TrykforlaegsController < OrderedInstancesController

  before_action :set_ordered_instance, only: [:show, :edit, :update]

  def index
    @trykforlaegs = Trykforlaeg.all
  end

  def new
    @trykforlaeg = Trykforlaeg.new
  end

  def create
    @trykforlaeg = Trykforlaeg.new(whitelist_params)
    if @trykforlaeg.save
      redirect_to @trykforlaeg, notice: 'Trykforlaeg created successfully'
    else
      render action: 'new'
    end
  end

  private
  def set_ordered_instance
    @ordered_instance = Trykforlaeg.find(params[:id])
  end

  def whitelist_params
    params.require(:trykforlaeg)
  end
end


