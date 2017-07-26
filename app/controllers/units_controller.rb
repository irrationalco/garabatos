class UnitsController < ApplicationController
  before_action :set_unit, except: [:index, :new, :create]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1
  # GET /units/1.json
  def show
    get_data
    @top_products = @top_ids.map {|id| Product.find(id) }
    @bottom_products = @bottom_ids.map { |id| Product.find(id) }
    # no esta jalando
    ids = Ticket.where('time > ?', 2.months.ago).ids
    @trending_products = ProductTicket.where(ticket_id: ids).top(:product_id, 10).map do |id, count|
      Product.find(id)
    end
  end

  def top_products_chart
    get_data
    @top_products_chart = Hash[ProductTicket.where(product_id: @top_ids)
                                            .joins(:ticket)
                                            .group(:product_id)
                                            .group_by_month(:time)
                                            .count
                                            .map do |key, cnt|
                                              [[Product.where(id: key[0]).pluck(:name),key[1]],
                                              cnt]
                                            end
                                            ]
    render json: @top_products_chart.chart_json
  end

  def bottom_products_chart
    get_data
    @bottom_products_chart = Hash[ProductTicket.where(product_id: @bottom_ids)
                                                .joins(:ticket)
                                                .group(:product_id)
                                                .group_by_month(:time)
                                                .count
                                                .map do |key, cnt|
                                                  [[Product.where(id: key[0]).pluck(:name),key[1]],
                                                  cnt]
                                                end
                                                ]
    render json: @bottom_products_chart.chart_json
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def get_data
      @top_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id).top(:product_id, 10).map {|id, cnt| id}
      @bottom_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                              .group(:product_id).order("count_all, product_id")
                                              .limit(10)
                                              .count
                                              .map {|id, cnt| id}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:name)
    end
end
