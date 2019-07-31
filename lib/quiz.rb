class Quiz
  attr_accessor :name, :subject, :id, :number_of_questions
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @number_of_questions = attributes.fetch(:number_of_questions).to_i
    @subject = attributes.fetch(:subject)
    @id = attributes.fetch(:id)
  end

  def self.all
     returned_quizzes = DB.exec("SELECT * FROM quizzes ORDER BY name DESC;")
     quizzes = []
     returned_quizzes.each() do |quiz|
       name = quiz.fetch("name")
       id = quiz.fetch("id").to_i
       subject = quiz.fetch("subject")
       number_of_questions = quiz.fetch("number_of_questions").to_i
       quizzes.push(Quiz.new({:name => name, :id => id, :subject => subject, :number_of_questions => number_of_questions}))
     end
     quizzes
   end

   def save
     result = DB.exec("INSERT INTO quizzes (name, subject, number_of_questions) VALUES ('#{@name}', '#{@subject}', #{@number_of_questions}) RETURNING id;")
     @id = result.first().fetch("id").to_i
   end

   def self.clear
     DB.exec("DELETE FROM quizzes *;")
   end

   def self.find(id)
     quiz = DB.exec("SELECT * FROM quizzes WHERE id = #{id};").first
     if quiz
       name = quiz.fetch("name")
       # quiz_id = quiz.fetch("quiz_id").to_i
       id = quiz.fetch("id").to_i
       subject = quiz.fetch("subject")
       number_of_questions = quiz.fetch("number_of_questions").to_i
       Quiz.new({:name => name, :id => id, :subject => subject, :number_of_questions => number_of_questions})
     else
       nil
     end
   end
#
#    # def self.find(id)
#    #   quiz = DB.exec("SELECT * FROM quizs WHERE id = #{id};").first
#    #   name = quiz.fetch("name")
#    #   id = quiz.fetch("id").to_i
#    #   quiz.new({:name => name, :id => id})
#    # end
#
#    def update(name)
#      @name = name
#      DB.exec("UPDATE quizs SET name = '#{@name}' WHERE id = #{@id};")
#    end
#
#    def delete
#      DB.exec("DELETE FROM quizs WHERE id = #{@id};")
#      DB.exec("DELETE FROM questions WHERE quiz_id = #{@id};") # new code
#    end
#
#    def questions
#      question.find_by_quiz(self.id)
#    end
end
