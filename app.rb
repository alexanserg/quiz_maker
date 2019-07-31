require './lib/questions'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require './lib/quiz'
also_reload 'lib/**/*.rb'

DB = PG.connect({:dbname => "quiz_maker"})

get ('/') do
  Quiz.clear
  Question.clear
  redirect to('/quizzes')
end

get ('/quizzes') do
  @quizzes = Quiz.all
  erb(:quizzes)
end

get ('/quiz/add') do
  erb(:quiz_new)
end

post ('/quiz/add') do
  Quiz.new({:id => nil, :name => params[:name], :subject => params[:subject],:number_of_questions => 0}).save

  redirect to ('/quizzes')
end

get ('/quiz/:id') do
  @quiz = Quiz.find(params[:id])
  @questions = Question.find_by_quiz(params[:id])
  erb(:quiz_display)
end

get ('/quiz/:id/questions/new') do
  @id = params[:id]
  erb(:question_new)
end

post ('/quiz/:id/question/add') do
  answers = [params[:answer1], params[:answer2], params[:answer3]]
  Question.new({:question => params[:question], :correct_answer => params[:correct_answer], :possible_answers => answers, :quiz_id => params[:id]}).save
  redirect to ("/quiz/#{params[:id]}")
end
