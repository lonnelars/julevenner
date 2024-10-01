class GroupsController < ApplicationController
  include Secured

  def show
    @group = Group.find(params[:id])
  end
end
