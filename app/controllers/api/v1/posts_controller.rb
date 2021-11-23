class Api::V1::PostsController < ApplicationController
before_action :set_post, only: [:show, :edit, :update, :destroy]

def index 
    @posts = Post.all
end

def show
end

def new
    @post = Post.new
end

def create
    @post = Post.create(post_params)
    @post.save
    render json: @post, status: :created
end

def destroy
    if @post.destroy
        head(:ok)
    else
        head(:unprocessible_entity)
    end
end

def edit
end

def update
end

def set_post
    @post = Post.find(params[:id])
end

private
def post_params
    params.require(:post).permit(:title,:description)
end

end
