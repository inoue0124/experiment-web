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
      name: 'login'
    },
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
      m_work_id: 4,
      next_workflow_id: 5
    },
    {
      t_experiment_id: 1,
      m_work_id: 4,
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
      next_workflow_id: 9
    },
    {
      t_experiment_id: 1,
      m_work_id: 7,
      next_workflow_id: 10
    }
  ]
)

TUser.create!(
  uuid: 'testtesttest',
  email: 'test@mail.com',
  password: 'test@123',
  t_experiment_id: 1,
  done_workflow_id: 1
)