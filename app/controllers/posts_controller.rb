class PostsController < ApplicationController
  def index
    key = Rails.configuration.redis['post_set_key']
    tags_key = Rails.configuration.redis['tag_set_key']
    @posts = @r.zrange(key, 0, 100, rev: false)
    Rails.logger.info(@posts)
    @tags = @r.smembers(tags_key)
  end

  def show
    full_file_name = params[:file_name] + ".md"
    file_name = params[:file_name].strip
    file_path = File.join(Rails.root, "posts", full_file_name)
    key_prefix = Rails.configuration.redis['post_prefix']
    key = key_prefix + file_name
    @tags = []
    if @r.exists?(key)
      data = JSON.load @r.get(key)
      @md_content = data['content']
      @tags = data['tags']
      Rails.logger.info("Load from redis")
    else
      if File.exists?(file_path)
        Rails.logger.info("Load from file #{file_path}")
        File.open(file_path) do |f|
          @md_content = f.read
        end
      else
        raise ActionController::RoutingError.new('NOT FOUND')
      end #if 
    end #if
  end

  def tag
    tag = params[:tag_name].strip
    tag_prefix = Rails.configuration.redis['tag_prefix']
    tags_key = Rails.configuration.redis['tag_set_key']

    key = tag_prefix + tag
    @posts = @r.smembers(key)
    @tags = @r.smembers(tags_key)
    render :index
  end

end
