class DplasController < ApplicationController
	# require "net/http"
	require 'open-uri'
	require "rubygems"
	require "json"
	def search
		@dpla = "digital"
	end
	def results
		@dpla = "digital"
		# render :text => params
		page_index = 0
		
		unless params[:next_page].nil?
			page_index = params[:page_index].to_i + 1
		end
		unless params[:previous_page].nil?
			page_index = params[:page_index].to_i - 1
		end	
		@page_index = page_index	
		keyword = params[:digital][:key]
		@keyword = keyword
		format = params[:format_key]
		@format = format
		keywords = keyword+'+'+format
		# render :text => page_index
		if(!keywords.match(/\s/).blank?)
			keywords = keywords.gsub! ' ','+'
		end
		request =  "http://api.dp.la"
		query = "/v2/items?q="+keywords+"&page_size=25&page="+page_index.to_s+"&api_key=82c24febbd39edbb43b53685463b48c7"
		# By default, we’ll give you 10 items. If that’s not enough, you can get the next ten items incrementing the page parameter (it’s one-indexed). If that’s still not enough, you can pull more items per page by using the page_size parameter
		# http://api.dp.la/v2/items?q=atlanta&page_size=25&page=3&api_key=
		# @response = Net::HTTP.get_response(request, query)
		response = open(request+query).read
		contents = JSON.parse(response)
		@return = contents
		@contents = contents["docs"]
		# render :text => content
	end
end