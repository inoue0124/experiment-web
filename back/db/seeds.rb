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
  text: '<h1 class="ql-align-center">プレースメントのための
  スピーキングテスト(STAR)研究に関する実験協力サイト
  </h1><p><br></p><p><br></p><p>本実験は、プレースメントのための日本語スピーキングテストSTAR(Speaking Test of Active Reaction)の開発に関連し、実験協力者に、日本語学習者の発話を判定していただくことで、STARの有用性を検証することを目的としています。</p><p><br></p><p>実験協力者に行っていただくことは、基本的に、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答える、の３つです。</p><p><br></p><p>実験への参加は任意であり、名前などの個人を特定する情報は公開されません。また、データ収集から２週間以内であれば、理由なしに協力を取りやめることができます。</p><p><br></p><p>実験協力の謝礼として、3000円の謝礼をお支払いします。所要時間は、1時間半〜２時間を見込んでいます。</p><p><br></p><p>本研究によって得られたデータは、部外秘として扱われ、録音や文字化、その他の個人情報は漏洩のないように致します。また、本研究の結果は、学会誌や研究発表、研究書出版などの学術研究発表にのみ、公開および利用されます。ただし、名前、所属など個人を特定するための情報は一切公開いたしません。なお、提供いただいたデータは、研究メンバーとして認められた者にのみ、利用されます。</p><p><br></p><p>また、本実験の内容に関して、ご不明な点がございましたら、下記の連絡先までお問い合わせいただきますよう、お願いいたします。</p><p><br></p><p>ボイクマン総子(Ph.D.)</p><p>東京大学 大学院総合文化研究科</p><p>グローバルコミュニケーション研究センター、教授</p><p>153-8902　東京都目黒区駒場3-8-1 東京大学</p><p>beuckmann@g.ecc.u-tokyo.ac.jp</p><p><br></p><p>
  </p><h2 class="ql-align-center">ご承諾内容</h2><p>
  下記の項目をお読みいただき、同意してくださる場合、□をクリックしてください。</p><p><br></p><ul><li>わたしは、この研究が、プレースメントのためのスピーキングテスト(STAR)研究の目的で行われること、その際、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答えることが求められることを理解しました。
  </li></ul><p><br></p><ul><li>データ収集から２週間以内であれば、理由なしに協力を取りやめることができるということを理解しました。</li></ul><p><br></p><ul><li>わたしは、自分が提供したデータは部外秘として扱われ、漏洩がないよう注意が払われることを理解しました。</li></ul><p><br></p><ul><li>研究成果が公開されるときには、名前は伏せられ、個人が特定されるようなことがないことを理解しました。</li></ul><p><br></p><ul><li>録音、文字化などの本研究で得られた情報はボイクマン総子が保管すること、認められた研究メンバーだけがデータの利用が可能となることを理解しました。
  </li></ul></div>'
)

TFacesheet.create!(
  t_workflow_id: 2,
  name: true,
  email: true,
  gender: true,
  age: true,
  is_student: true,
  department: true,
  is_opi: true,
  is_teacher: true,
  teach_speaking_experience: true,
  country: true,
  institute: true
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