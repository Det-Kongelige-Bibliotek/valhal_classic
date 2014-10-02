class TrykforlaegsController < OrderedInstancesController

  before_action :set_ordered_instance, only: [:show, :edit, :update]

  def index
    @trykforlaegs = Trykforlaeg.all
  end

  def new
    @trykforlaeg = Trykforlaeg.new
  end

  def create

  end

  private
  def set_ordered_instance
    @ordered_instance = Trykforlaeg.find(params[:id])
  end

  def whitelist_params
    params.require(:trykforlaeg)
  end
end


