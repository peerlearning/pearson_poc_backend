class TestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def next_problem
    answer = params['answer']
    test_id = params[:test_id]
    problem_id = params['problem_id']
    problem_number = params['problem_number']

    test = Test.where(id: test_id).first

    problem = test.problems.detect{|prob| prob if prob['id'] == problem_id}

    @str = StudentTestRecord.where(student_id: params[:student_id], test_id: test.id).last
    problems = @str.problems

    problems.push({problem_id: problem_id, answer: answer,
                      cms_answer: problem['answer'], 
                      problem_difficulty: problem['difficulty_rating'],
                      Ability_estimate: 0
                      })
    @str.problems = problems
    @str.save!

    if problem_number.to_i >= test.problems.length
      redirect_to(test_summary_path(test_id: test.id, student_id: params[:student_id]))
    else

      #test = Test.find(test_id)
      problem = get_next_problem(test.problems, problem_id, nil, problem_number)
      render json: problem, status: :ok
    end
  end

  def get_next_problem(problems, current_problem_id, result, number)
    
    ## Problem selection algo goes here
    # problem = problems.sample
    problem_ids = @str.problems.pluck(:problem_id)
    
    selected_problems = problems.select{|prob| prob unless problem_ids.include? prob[:id]}
    problem = selected_problems.sample

    problem['number'] = number.to_i+1
    if problem['number'] == problems.count
      problem['last_problem'] = true
    end
    problem
  end

  def start

    #test = Test.find_by(params[:id])
    StudentTestRecord.create(student_id: params[:student_id], test_id: params[:id])
    @student_id =  params[:student_id] || 'student_id' 
    @test = Test.first
    @num = 1
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
    file_name = params[:student_id] + '-' + params[:test_id] 
    file_obj = aws_s3_client.bucket(Settings.s3_response_bucket).object(file_name)
    file_obj.put(acl: 'public-read', body: data.to_json, content_type: 'application/json')
  end
end

