class ErrandRequestsController < ApplicationController
  def index
    requests = ErrandRequest.joins(:errand).where("(errands.finished is null or not errands.finished) AND errands.errand_request_id is not null AND errand_requests.user_id = ?", current_user.id).all
    render json: requests
  end
  def pending
    requests = ErrandRequest.joins(:errand).where("errand_request_id = ? AND errands.user_id = ?", nil, current_user.id).all
    render json: requests
  end

  def update
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      errand = request.errand
      errand.errand_request_id = request.id
      errand.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end

  # will refactor this later :(
  def decline
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      request.declined = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def undodecline
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      request.declined = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def reject
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      request.finished = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def finish
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.user_id == current_user.id # only user who owns request can mark as finished
      request.finished = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
end
