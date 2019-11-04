class TestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def next_problem

    #right_ans_count => R
    #problem_number => L
    #Difficulty used  => H
    #Difficulty of current problem => D
   
    student_answer = params['answer']
    test_id = params['test_id']
    problem_id = params['problem_id']
    problem_number = params['problem_number']
    difficulty_used = params['difficulty_used'].to_i
    right_ans_count = params['right_ans_count'].to_i

    test = Test.where(id: test_id).first

    current_problem = test.problems.detect{|prob| prob if prob['id'] == problem_id}


    if current_problem['answer'].first == student_answer
      right_ans_count += 1
      approx_difficulty =  current_problem['difficulty_rating'].to_i + 2/problem_number.to_i
    else
      approx_difficulty =  current_problem['difficulty_rating'].to_i - 2/problem_number.to_i
    end

    if approx_difficulty >= 2 
      prob_difficulty = 3
    elsif approx_difficulty >= 0 && approx_difficulty < 2
      prob_difficulty = 2
    elsif approx_difficulty < 0
      prob_difficulty = 1
    else
      #do nothing
    end


    @str = StudentTestRecord.where(student_id: params[:student_id], test_id: test.id).last
    problems = @str.problems
    problems.push({problem_id: problem_id, answer: student_answer,
                      cms_answer: current_problem['answer'], 
                      problem_difficulty: current_problem['difficulty_rating'],
                      Ability_estimate: 0
                      })
    @str.problems = problems
    @str.save!

    next_problem = get_next_problem(test.problems, student_answer, prob_difficulty)
    if next_problem
      next_problem['number'] = problem_number.to_i+1
      next_problem['difficulty_used'] = difficulty_used.to_i + prob_difficulty.to_i
      next_problem['right_ans_count'] = right_ans_count
      render json: next_problem, status: :ok
    else
      redirect_to(test_summary_path(test_id: test.id, student_id: params[:student_id]))
    end
  end

  def get_next_problem(problems, student_answer, prob_difficulty)
    problem_ids = @str.problems.pluck(:problem_id)
    selected_problems = problems.select{|prob| prob if (prob[:difficulty_rating] == prob_difficulty.to_s)}.select{|pblm| pblm  unless problem_ids.include? pblm[:id] }

    selected_problems.sample
  end

  def start

    #test = Test.find_by(params[:id])
    StudentTestRecord.create(student_id: params[:student_id], test_id: params[:id])
    @student_id =  params[:student_id] || 'student_id' 
    @test = Test.first
    @num = 1
    @difficulty_used = 0
    @right_ans_count = 0
    # render json: @test, status: :ok

    # problem = test.problem.first
    # problem_str
  end

  def summary

    @student_record = StudentTestRecord.where(student_id: params[:student_id], test_id: params[:test_id]).last
    data ={
            student_id: params[:student_id],
            test_code: 'code',
            final_ability_estimate: 0,
            responses: @student_record.problems
          }
    # file_name = params[:student_id] + '-' + params[:test_id] 
    # file_obj = aws_s3_client.bucket(Settings.s3_response_bucket).object(file_name)
    # file_obj.put(acl: 'public-read', body: data.to_json, content_type: 'application/json')
  end
end

