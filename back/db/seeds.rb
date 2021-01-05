# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
MWork.create!(
  [
    {
      name: 'agreement'
    },
    {
      name: 'facesheet'
    },
    {
      name: 'assessment'
    },
    {
      name: 'questionnaire'
    },
    {
      name: 'transfer'
    },
    {
      name: 'thanks'
    }
  ]
)

TExperiment.create!(
  name: 'テスト実験'
)

TWorkflow.create!(
  [
    {
      t_experiment_id: 1,
      m_work_id: 1,
      next_workflow_id: 2
    },
    {
      t_experiment_id: 1,
      m_work_id: 2,
      next_workflow_id: 3
    },
    {
      t_experiment_id: 1,
      m_work_id: 3,
      next_workflow_id: 4
    },
    {
      t_experiment_id: 1,
      m_work_id: 3,
      next_workflow_id: 5
    },
    {
      t_experiment_id: 1,
      m_work_id: 3,
      next_workflow_id: 6
    },
    {
      t_experiment_id: 1,
      m_work_id: 4,
      next_workflow_id: 7
    },
    {
      t_experiment_id: 1,
      m_work_id: 5,
      next_workflow_id: 8
    },
    {
      t_experiment_id: 1,
      m_work_id: 6,
      next_workflow_id: nil
    }
  ]
)

TUser.create!(
  [
    {
      uuid: 'test',
      email: 'test@mail.com',
      password: 'test@123',
      t_experiment_id: 1,
      done_workflow_id: nil,
      user_type: 1
    },
    {
      uuid: 'admin',
      email: 'admin@mail.com',
      password: 'admin@123',
      t_experiment_id: nil,
      done_workflow_id: nil,
      user_type: 0
    }
  ]
)

TAgreement.create!(
  t_workflow_id: 1,
  text: '<h2>評価実験の説明</h2>

<p class="text-justify">
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
</p>

<p class="text-justify">
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
  ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
</p>

<h2>協力同意書</h2>

<p class="text-justify">
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
</p>

<p class="text-justify">
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
  ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
</p>'
)

TFacesheet.create!(
  t_workflow_id: 2,
  name: true,
  phone: false
)

TAssessment.create!(
  [
    {
      t_workflow_id: 3,
      is_practice: true,
      point: 6,
      num_files: 10,
      criteria: 'L1,L2,L3,L4,L5,L6'
    },
    {
      t_workflow_id: 4,
      is_practice: false,
      point: 6,
      num_files: 30,
      criteria: 'L1,L2,L3,L4,L5,L6'
    },
    {
      t_workflow_id: 5,
      is_practice: false,
      point: 6,
      num_files: 30,
      criteria: 'L1,L2,L3,L4,L5,L6'
    }
  ]
)

TQuestionnaire.create!(
  t_workflow_id: 6,
  url: 'https://docs.google.com/forms/d/e/1FAIpQLSfcbMBs6cSXpzfqvtLo0kCSlxotB_5SYZnRtjz49GziPOus5w/viewform?embedded=true'
)