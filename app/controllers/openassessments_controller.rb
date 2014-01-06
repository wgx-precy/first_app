class OpenassessmentsController < ApplicationController
	def create
		@tag = "create"
		unless params[:tag] !="create"
			titles = params[:qtitle]
			assessment =  Assessment.create(:title => titles)
			ass_id = Assessment.sort(:created_at.desc).first._id.to_s
			render :text => ass_id
		end	
		unless params[:tag] !="create_question"
			dbid = params[:aid]
			id = params[:qid]
			body = params[:qbody]
			correct_answer = params[:qcorrect]
			choices = params[:qanswers]
			assessment = Assessment.find(dbid)
			question = Question.new(:questionId => id, :questionBody => body, :answer => correct_answer)
			for i in 1..choices.length
				ques_choice = Array.new
				ques_choice = choices[i-1].split("#")
				choice = Choice.new(:choiceId => ques_choice[0], :choice => ques_choice[1])
				question.choices.append(choice)
			end
			question.save();
			assessment.questions.append(question)
			assessment.save()
			render :text => "true"
		end

	end
	def show
		id = "52b325d3aa609706dc0000aa"
		assessment = Assessment.find(id)
		@ass_title = assessment.title
		questions = assessment.questions
		correct_answer = Array.new
		choices = questions[0].choices
		ass_questions = Array.new
		for i in 1..questions.length
			correct_answer[i-1] = questions[i-1].answer
			ass_questions[i-1] = Array.new
			ass_questions[i-1][0] = questions[i-1].questionId
			ass_questions[i-1][1] = questions[i-1].questionBody
			ass_questions[i-1][2] = Array.new
			for j in 1..questions[i-1].choices.length
				choices = questions[i-1].choices[j-1]
				ass_questions[i-1][2][j-1] =  Array.new
				ass_questions[i-1][2][j-1][0] = choices.choiceId
				ass_questions[i-1][2][j-1][1] = choices.choice
			end
		end
		@questions_array = ass_questions
		@answers_array = correct_answer
	end
end