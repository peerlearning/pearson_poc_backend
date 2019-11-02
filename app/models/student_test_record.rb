class StudentTestRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_c,  as: :student_id, type: String
  field :_p,  as: :problems, type: Array, default: []
  field :_d,  as: :duration, type: String  
  field :_m,  as: :marks, type: Integer

  belongs_to :test, class_name: 'Test', index: true,
             inverse_of: :student_test_records
end
