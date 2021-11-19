class Api::V1::PostsController < ApplicationController
before_action :set_post

def index
end 

def show
end

def set_post
    @post = Post.find(params[:id])
end

end
