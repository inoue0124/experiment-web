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

# TExperiment.create!(
#   name: 'テスト実験'
# )

# TWorkflow.create!(
#   [
#     {
#       t_experiment_id: 1,
#       m_work_id: 1,
#       next_workflow_id: 2
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 2,
#       next_workflow_id: 3
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 3,
#       next_workflow_id: 4
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 3,
#       next_workflow_id: 5
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 3,
#       next_workflow_id: 6
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 4,
#       next_workflow_id: 7
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 5,
#       next_workflow_id: 8
#     },
#     {
#       t_experiment_id: 1,
#       m_work_id: 6,
#       next_workflow_id: nil
#     }
#   ]
# )

TUser.create!(
  [
    # {
    #   uuid: 'test',
    #   email: 'test@mail.com',
    #   password: 'test@123',
    #   t_experiment_id: 1,
    #   done_workflow_id: nil,
    #   user_type: 1
    # },
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

# TAgreement.create!(
#   t_workflow_id: 1,
#   text: '<h1 class="ql-align-center">プレースメントのための
# スピーキングテスト(STAR)研究に関する実験協力サイト
# </h1><p><br></p><p><br></p><p>本実験は、プレースメントのための日本語スピーキングテストSTAR(Speaking Test of Active Reaction)の開発に関連し、実験協力者に、日本語学習者の発話を判定していただくことで、STARの有用性を検証することを目的としています。</p><p><br></p><p>実験協力者に行っていただくことは、基本的に、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答える、の３つです。所要時間は、1時間半〜２時間を見込んでいます。</p><p><br></p><p>実験への参加は任意です。参加に同意した後も2週間以内であれば、同意を取り消すことができ、それによる不利益は生じません。収集したデータおよび個人情報は破棄し、以降の研究には一切使用いたしません。</p><p><br></p><p>実験協力の謝礼として、3000円の謝礼をお支払いします。</p><p><br></p><p>本実験により取得したデータおよび個人情報は、研究目的以外に使用することはありません。学術誌、研究発表、研究書出版など結果が公開される際も、個人情報は守秘されます。データは番号を付け、匿名化し、漏洩のないよう保管いたします。データは部外秘とし、研究利用または閲覧には、研究代表者の許可を必要とします。保管データは、研究終了後5年間は保管された後、責任をもって破棄いたします。</p><p><br></p><p>また、本実験の内容に関して、ご不明な点がございましたら、ページ下部の連絡先までお問い合わせいただきますよう、お願いいたします。</p><p>
# </p><p><br></p><h2 class="ql-align-center">ご承諾内容</h2><p>
# 下記の項目をお読みいただき、同意してくださる場合、□をクリックしてください。</p><p><br></p><ul><li>わたしは、この研究が、プレースメントのためのスピーキングテスト(STAR)研究の目的で行われること、その際、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答えることが求められることを理解しました。
# </li></ul><p><br></p><ul><li>データ収集から２週間以内であれば、理由なしに協力を取りやめることができるということを理解しました。</li></ul><p><br></p><ul><li>わたしは、実験協力の所要時間と謝礼について理解しました。</li></ul><p><br></p><ul><li>わたしは、自分が提供したデータは部外秘として扱われ、漏洩がないよう注意が払われることを理解しました。</li></ul><p><br></p><ul><li>研究成果が公開されるときには、名前は伏せられ、個人が特定されるようなことがないことを理解しました。</li></ul><p><br></p><ul><li>録音、文字化などの本研究で得られた情報はボイクマン総子が保管すること、認められた研究メンバーだけがデータの利用が可能となることを理解しました。</li></ul><p><br></p><ul><li>わたしは問い合わせの連絡先について理解しました。
# </li></ul>'
# )

# TFacesheet.create!(
#   t_workflow_id: 2,
#   name: true,
#   email: true,
#   gender: true,
#   age: true,
#   is_student: true,
#   department: true,
#   is_opi: true,
#   is_teacher: true,
#   teach_speaking_experience: true,
#   country: true,
#   institute: true
# )

# TAssessment.create!(
#   [
#     {
#       t_workflow_id: 3,
#       is_practice: true,
#       point: 6,
#       num_files: 10,
#       criteria: 'L1,L2,L3,L4,L5,L6'
#     },
#     {
#       t_workflow_id: 4,
#       is_practice: false,
#       point: 6,
#       num_files: 30,
#       criteria: 'L1,L2,L3,L4,L5,L6'
#     },
#     {
#       t_workflow_id: 5,
#       is_practice: false,
#       point: 6,
#       num_files: 30,
#       criteria: 'L1,L2,L3,L4,L5,L6'
#     }
#   ]
# )

# TQuestionnaire.create!(
#   t_workflow_id: 6,
#   url: 'https://docs.google.com/forms/d/e/1FAIpQLSdQgyYxQfNthONRdS81XSUxXD1bjJNSEZcC47QWmQ1adCPxyw/viewform?usp=sf_link'
# )