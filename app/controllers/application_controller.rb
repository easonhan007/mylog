class ApplicationController < ActionController::Base
	before_action :init_redis

	def init_redis
		@r = Redis.new(host: Rails.configuration.redis['host'], port: Rails.configuration.redis['port'])
	end
end
