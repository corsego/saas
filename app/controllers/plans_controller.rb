class PlansController < ApplicationController
  before_action :set_plan, only: %i[edit update destroy]

  def index
    @q = Plan.ransack(params[:q])
    @plans = @q.result(distinct: true)
  end

  def new
    @plan = Plan.new
  end

  def edit
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to plans_url, notice: "Plan was successfully created."
    else
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to plans_url, notice: "Plan was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @plan.destroy
      redirect_to plans_url, notice: "Plan was successfully destroyed."
    else
      redirect_to plans_url, alert: "Plan has subscriptions. Can not be destroyed."
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :amount, :currency, :interval, :max_members)
  end
end
