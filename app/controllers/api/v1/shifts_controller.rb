class Api::V1::ShiftsController < ApplicationController
  before_action :authenticate_admin_or_kasir

  # GET /api/v1/shifts — list all shifts (optional ?date=2026-08-03)
  def index
    @shifts = params[:date].present? ? Shift.for_date(Date.parse(params[:date])) : Shift.all
    render json: @shifts.as_json(include: { user: { only: [:id, :username, :role] } })
  end

  # POST /api/v1/shifts/clock_in
  def clock_in
    @shift = Shift.new(user_id: current_user.id, clock_in: Time.current)
    if @shift.save
      render json: @shift, status: :created
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/shifts/clock_out
  def clock_out
    @shift = Shift.active.find_by(user_id: current_user.id)
    if @shift.nil?
      return render json: { error: 'Tidak ada shift aktif' }, status: :unprocessable_entity
    end

    if @shift.update(clock_out: Time.current)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  private

  def shift_params
    params.permit(:notes)
  end
end
