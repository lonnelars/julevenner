class GroupsController < ApplicationController
  include Secured

  def show
    @group = Group.find(params[:id])
    @julevenn = find_julevenn session[:userinfo]["name"]
  end

  private

  def find_julevenn(email)
    ids = @group.users.all.map { |u| u.id }
    alist = ids.zip(ids.shuffle(random: Random.new(@group.seed)))
    me = User.find_by email: email
    pair = alist.assoc me.id
    User.find pair[1]
  end
end
