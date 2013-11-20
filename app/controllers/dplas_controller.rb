class DplasController < ApplicationController
	# require "net/http"
	require 'open-uri'
	require "rubygems"
	require "json"
	def search
		@dpla = "digital"
	end
	def results
		keywords = params[:digital][:key]
		if(!keywords.match(/\s/).blank?)
			keywords = keywords.gsub! ' ','+'
		end
		request =  "http://api.dp.la"
		query = "/v2/items?q="+keywords+"&api_key=82c24febbd39edbb43b53685463b48c7"
		# @response = Net::HTTP.get_response(request, query)
		response = open(request+query).read
		contents = JSON.parse(response)
		@return = contents
		@contents = contents["docs"]
		# render :text => content
	end
end