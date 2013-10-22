
class XmlsController < ApplicationController
	require 'builder'
	require "net/http"
	require 'nokogiri'
	# require 'open-uri'
  #require_gem 'builder'
	# DISHES = [
	# 	{:rating =>2, :category => "singaporean",
	# 		:dish_name => "Fish Head Curry", :where_to_buy => "Little India"},
	# 		{:rating => 8, :category => "western",:dish_name => "Cowbo Burger",
	# 			:where_to_buy=>"Brewerkz"},
	# 			{:rating =>8, :category => "mexican", :dish_name => "Pork Enchilada",
	# 				:where_to_buy => "I guss Cafe"}
	# 			]
	# private
	# build xml by rexml
	# def generate_rexml
	# 	doc = REXML::Document.new
	# 	root = doc.add_element("Food")
	# 	DISHES.each{ |element_date|
	# 		dish_element = root.add_element("Dish")
	# 		dish_element.add_attribute("rating",element_date[:rating])
	# 		dish_element.add_attribute("category",element_date[:category])
	# 		dish_name_element = dish_element.add_element("DishName")
	# 		dish_name_element.add_text(element_date[:dish_name])
	# 		where_to_buy_element = dish_element.add_element("WhereToBuy")
	# 		where_to_buy_element.add_text(element_date[:where_to_buy])
	# 	}
	# 	doc.write( out_string = "",2)
	# 	return out_string
	# end
	def generate
	end
	def generate_builder
		doc = Builder::XmlMarkup.new(:target => out_string = "", :indent =>2)
		doc.credentials{
			doc.credential("email" => "lemon_victor@hotmail.com", "password" => "wgx890922")
			doc.add_attribute("first-name")
		}

		# request_body = doc.codes("sku"=>"L-999-70103", "license-type"=>"perpetual", "online-license-type"=>"perpetual", "num-codes"=>"1", "code-type"=>"comp")
		request_body = doc.user{
			doc.reference("xiehongquan002")
			doc.first"-"name("hongquan")
			doc.last_name("xie")
			doc.question_id("1")
			doc.question_response("12345")
		}
		@request = out_string
		# uri = URI.parse("https://api.vitalsource.com")
		# http = Net::HTTP.new(uri.host, uri.port)
		# http.use_ssl = true
		# http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		# # request = Net::HTTP::Post.new("/v3/users.xml")
		# request = Net::HTTP::Post.new("/v3/credentials.xml")
		# request.add_field('X-VitalSource-API-Key', 'YNBWZXTN743PWCZG')
		# response = http.request(request)
		# @response = Hash.from_xml(response.body)

	end
	def hijack_response(out_data)
		send_data(out_data, :type => "text/xml", :filename => "sample.xml")
	end
end
