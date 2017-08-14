class SearchController < ApplicationController
  before_action :load_query
  before_action :load_resource

  skip_after_action :verify_authorized

  def show
    @result = Search.find(@query, @resource) if @query.present?
  end

  private

  def load_query
    @query = params[:query]
  end

  def load_resource
    @resource = params[:resource]
  end
end
