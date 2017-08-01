class UnitsController < ApplicationController
  before_action :set_unit, except: [:index, :new, :create, :ammount_chart, :sales_chart]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all.order(:name)
    ids = ProductTicket.joins(:ticket => :unit)
                              .group(:unit_id)
                              .order('sum_ammount DESC')
                              .limit(10)
                              .sum(:ammount)
                              .map {|k,v| k}
    @top_units = Unit.where(id: ids).order("array_position(array#{ids}, (id :: int) )")
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @top_products = Product.get_ordered(top_ids)
    @bottom_products = Product.get_ordered(bottom_ids)
    @best_products = Product.get_ordered(best_ids)
    @worst_products = Product.get_ordered(worst_ids)
  end

  def ammount_chart
    render json: Hash[ProductTicket.joins(:ticket).group(:unit_id)
                                    .group_by_month(:time)
                                    .order('sum_ammount DESC, unit_id')
                                    .sum(:ammount)
                                    .map do |key, cnt|
                                      [[Unit.where(id: key[0]).pluck(:name),key[1]],
                                      cnt]
                                    end
                                    ].chart_json
  end

  def top_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: top_ids)
                                            .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: bottom_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: best_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: worst_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
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

    def top_ids
      @top_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                .top_by_ammount(:product_id, 10)
    end
    def bottom_ids
      @bottom_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_ammount(:product_id, 10)
    end

    def best_ids
      @best_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                .top_by_price(10)
    end
    def worst_ids
      @worst_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_price(10)
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
