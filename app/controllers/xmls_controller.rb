class XmlsController < ApplicationController
	require 'builder'
	require "net/http"
	require 'nokogiri'
#-------------------------page controller for register -------------------------------------
#-------------------------form post to generate_builder-------------------------------------
	def generate
		@vs = "vitalsource"
		@question = ["What is your Student ID number?","What is your favorite color?","In what city were you born?","What is your pet's name?","What is your mother's maiden name?"]
	end
#-------------------------generate request and send ceate user post --------------
	def generate_builder
		@email = params[:vitalsource][:email]
		@first_name = params[:vitalsource][:first_name]
		@last_name = params[:vitalsource][:last_name]
		@affiliate = params[:vitalsource][:affiliate]
		@password = params[:vitalsource][:password]
		@confirm_password = params[:vitalsource][:confirm_password]
		@question_id = params[:vitalsource][:question_id]
		@answer = params[:vitalsource][:answer]

		doc = Builder::XmlMarkup.new(:target => out_string = "", :indent =>2)
		# #----------user login request body------------------------------------------------------------------------
		# doc.credentials{
		# 	doc.credential("email" => "lemon_victor@hotmail.com", "password" => "wgx890922")
		# }
		# #user login request url
		# request_url = "/v3/credentials.xml"
		# # #return: 
		# # #{"credentials"=>{"credential"=>{"access_token"=>"4e2503801317d29a915895b17d560c54", "reference"=>"", "guid"=>"B2EY7AGYKNNMER76H56M", "email"=>"lemon_victor@hotmail.com", "__content__"=>"\n "}}}


		#-------------create user request body---------------------------------------------------------------------
		doc.user{
			# doc.reference("xiehongquan002")
			doc.email(@email)
			doc.password(@password)
			doc.first_name(@first_name)
			doc.last_name(@last_name)
			doc.affiliate(@affiliate)
			doc.question_id(@question_id)
			doc.question_response(@answer)
		}
		#create user request url
		request_url = "/v3/users.xml"

		# #-------------a valid reference field as a credential----------------------------------------------
		# doc.credentials{
		# 	doc.credential("reference" => "xiehongquan002")
		# }
		# #reference field credential request url
		# request_url = "/v3/credentials.xml"
		#return:
		#{"credentials"=>{"credential"=>{"reference"=>"xiehongquan002", "email"=>"b868868026c4da5@placeholder.142.edu", "access_token"=>"b452fd75eae3c05f7c34e258c4084e57", "guid"=>"URP732MQYFXT7ZVMCY5M", "__content__"=>"\n "}}}

		@request = out_string
		uri = URI.parse("https://api.vitalsource.com")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Post.new(request_url)		
		request.add_field('X-VitalSource-API-Key', 'YNBWZXTN743PWCZG')
		request.body = out_string
		response = http.request(request)
		body = Hash.from_xml(response.body)
		if(body.has_key?("error_response"))
			@err = body["error_response"]["error_text"]
		end
		if(body.has_key?("user"))
			@user = body["user"]
		end
	end
#------------------------page controller for vital source login -------------------------------------
#------------------------form post to account -------------------------------------------------------
	def vital_source_login
		@vs = "vitalsource"
	end
#------------------------generate login request and send login request post --------------------------
	def account
		@email = params[:vitalsource][:email]
		@password = params[:vitalsource][:password]
		doc = Builder::XmlMarkup.new(:target => out_string = "", :indent =>2)
		#----------user login request body------------------------------------------------------------------------
		doc.credentials{
			doc.credential("email" => @email, "password" => @password)
		}
		#user login request url
		request_url = "/v3/credentials.xml"
		# #return: 
		# #{"credentials"=>{"credential"=>{"access_token"=>"4e2503801317d29a915895b17d560c54", "reference"=>"", "guid"=>"B2EY7AGYKNNMER76H56M", "email"=>"lemon_victor@hotmail.com", "__content__"=>"\n "}}}
		@request = out_string
		uri = URI.parse("https://api.vitalsource.com")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Post.new(request_url)		
		request.add_field('X-VitalSource-API-Key', 'YNBWZXTN743PWCZG')
		request.body = out_string
		response = http.request(request)
		body = Hash.from_xml(response.body)
		if(!body.has_key?("error"))
			@err = body["credentials"]["error"]
		end
		if(!body.has_key?("credential"))
			@user = body["credentials"]["credential"]
		end
	end
	def hijack_response(out_data)
		send_data(out_data, :type => "text/xml", :filename => "sample.xml")
	end

	def show_qti
		questions = Hash.new
    	contents = Hash.new
		@i = 0
		assessment = File.open("/Users/guoxuwang/Desktop/quiz6.xml", "rb") {|io| io.read}
    	xml = Nokogiri.XML(assessment)
    	@qti = xml
    	qit_title = Array.new
    	xml.css('item').each do |subitem|
    		qit_title << subitem.xpath('@title').to_s
    	end
    	qit_question = Array.new
    	xml.css('presentation/material/mattext').each_with_index do |question_text,i|
      		qit_question << question_text.to_s
    	end
    	question_answer = Array.new
    	question_option = Array.new
    	xml.css('render_choice').each_with_index do |render_choice,i|
    		qit_sub_answer = Array.new()
    		qit_sub_choice = Array.new()
    		render_choice.css('response_label/material/mattext').each do |material|
    			qit_sub_answer << material.content
    		end
    		render_choice.css('response_label').each do |options|
    			qit_sub_choice << options.xpath('@ident').to_s
    		end
    		id = "q"+i.to_s;
    		contents['choice'] = qit_sub_answer
    		contents['option'] = qit_sub_choice
    		questions[id] = contents
    		question_answer[i] = qit_sub_answer
    		question_option[i] = qit_sub_choice
    	end
    	question_correct_answers = Array.new
    	xml.css('resprocessing/respcondition/conditionvar/varequal').each do |varequal|
    		question_correct_answers << varequal.content
    	end
    	# render :text => question_correct_answers[0]
    	@answer = questions
    	@question_content = qit_question
    	@question_answers = question_answer
    	@question_options = question_option
    	unless params[:id].nil?
    		if question_correct_answers[params[:id].to_i] == params[:answer]
    			render :text => 'true'
    		else
    			render :text => 'false'
    		end
		end
	end


  	def parse_identifier(xml)
    	xml.css('item').xpath('@ident').to_s
  	end

	def parse_question_text(xml)
    	text = ""
    	xml.css('presentation/material/mattext').each do |question_text|
      	text = question_text.content
    	end
    	text
 	 end

end
