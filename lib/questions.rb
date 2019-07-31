class Question

  attr_accessor :question, :id, :possible_answers, :user_answer, :correct_answer, :quiz_id


  def initialize(attributes)
    @question = attributes.fetch(:question)
    @quiz_id = attributes.fetch(:quiz_id).to_i
    @correct_answer = attributes.fetch(:correct_answer).to_i
    @possible_answers = attributes.fetch(:possible_answers)
    @id = nil
  end

  def save()
    result = DB.exec("INSERT INTO questions (quiz_id, question, correct_answer, possible_answers) VALUES (#{@quiz_id},'#{@question}', '#{@correct_answer}', '{#{@possible_answers.join(",")}}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.clear
    DB.exec("DELETE FROM questions *;")
  end

  def self.find_by_quiz(id)
    questions = []
    results = DB.exec("SELECT * FROM questions WHERE quiz_id = #{id};")

    results.each do |result|
      poss_string = result.fetch("possible_answers").split(',')
      poss_string = poss_string.map do |str|
        str.tr('{}', '')
      end
      questions.push(Question.new({:id => result.fetch("id"), :quiz_id => result.fetch("quiz_id"), :question => result.fetch("question"), :correct_answer => result.fetch("correct_answer"), :possible_answers => poss_string}))
    end
    questions
  end

end
