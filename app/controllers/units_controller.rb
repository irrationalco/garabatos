class UnitsController < ApplicationController
  before_action :set_unit, except: [:index, :new, :create, :ammount_chart, :sales_chart]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all.order(:name)
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @top_products = top_ids.map {|id| Product.find(id) }
    @bottom_products = bottom_ids.map { |id| Product.find(id) }
    @best_products = best_ids.map {|id| Product.find(id) }
    @worst_products = worst_ids.map { |id| Product.find(id) }

    last_month = Ticket.group_by_month(:time).count.keys.sort[-1]
    @trending_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('"tickets"."unit_id" = ?', @unit.id)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',top_ids)
                                      .top_by_ammount(:product_id, 10).map do |id, count|
      Product.find(id)
    end
    @declining_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('"tickets"."unit_id" = ?', @unit.id)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',bottom_ids)
                                      .bottom_by_ammount(:product_id, 10).map do |id, count|
      Product.find(id)
    end
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

  def sales_chart
    render json: Hash[ProductTicket.joins(:ticket).group(:unit_id)
                                    .group_by_month(:time)
                                    .order('sum_price DESC, unit_id')
                                    .sum(:price)
                                    .map do |key, cnt|
                                      [[Unit.where(id: key[0]).pluck(:name),key[1]],
                                      cnt]
                                    end
                                    ].chart_json
  end

  def top_products_chart
    chart = Hash[ProductTicket.where(product_id: top_ids)
                                            .where('"tickets"."unit_id" = ?', @unit.id)
                                            .chartify(:ammount)]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.where(product_id: bottom_ids)
                                                .where('"tickets"."unit_id" = ?', @unit.id)
                                                .chartify(:ammount)]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.where(product_id: best_ids)
                                                .where('"tickets"."unit_id" = ?', @unit.id)
                                                .chartify(:price)]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.where(product_id: worst_ids)
                                                .where('"tickets"."unit_id" = ?', @unit.id)
                                                .chartify(:price)]
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
                                                .top_by_ammount(:product_id, 10).map {|id, cnt| id}
    end
    def bottom_ids
      @bottom_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_ammount(:product_id, 10).map {|id, cnt| id}
    end

    def best_ids
      @best_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                .top_by_price(:product_id, 10).map {|id, cnt| id}
    end
    def worst_ids
      @worst_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_price(:product_id, 10).map {|id, cnt| id}
    end

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
