class Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_t,  as: :title, type: String
  field :_c,  as: :cms_id, type: String
  field :_cd, as: :code, type: String
  field :_s,  as: :subjects, type: Array, default: []
  field :_p,  as: :problems, type: Array, default: []
  field :_d,  as: :duration, type: String  
  field :_m,  as: :marks, type: Integer 

 has_many :student_test_records, class_name: 'StudentTestRecord', inverse_of: :test
end
