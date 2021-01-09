<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">
      <StepProgress class="mb-10"></StepProgress>

      <h1 align="center" class="mb-16">背景情報</h1>

        <p class="mb-10">あなた自身のことについてお尋ねいたします。</p>

        <v-form @submit.prevent="submit">

          <div fluid v-if="t_facesheet.name" class="mb-10">
            <p>氏名</p>
            <v-text-field
              v-model="d_facesheet.name"
              label="氏名"
              required
              class="mb-10"
            ></v-text-field>
          </div>

          <div fluid v-if="t_facesheet.email" class="mb-10">
            <p>メールアドレス</p>
            <v-text-field
              v-if="t_facesheet.email"
              v-model="d_facesheet.email"
              label="メールアドレス"
              required
              class="mb-10"
            ></v-text-field>
          </div>

          <div fluid v-if="t_facesheet.gender" class="mb-10">
            <p>性別</p>
            <v-radio-group v-model="d_facesheet.gender" row>
              <v-radio
                v-for="n in 4"
                :key="n"
                :label="`${gender_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
          </div>

          <div fluid v-if="t_facesheet.age" class="mb-10">
            <p>年齢</p>
            <v-radio-group v-model="d_facesheet.age" row>
              <v-radio
                v-for="n in 10"
                :key="n"
                :label="`${age_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
          </div>

          <div fluid v-if="t_facesheet.is_student" class="mb-10">
            <p>あなたは、大学生・大学院生ですか。</p>
            <v-radio-group v-model="d_facesheet.is_student" row>
              <v-radio
                v-for="n in 3"
                :key="n"
                :label="`${is_student_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
          </div>

          <div fluid v-if="t_facesheet.department && (d_facesheet.is_student===1 || d_facesheet.is_student===2)" class="mb-10">
            <p>学部名または研究分野について書いてください。</p>
            <v-radio-group v-model="d_facesheet.department_type" row>
              <v-radio
                v-for="n in 2"
                :key="n"
                :label="`${department_type_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
            <v-text-field
              v-model="d_facesheet.department_name"
              label="学部名または研究分野"
              required
              class="mb-10"
            ></v-text-field>
          </div>

          <div fluid v-if="t_facesheet.is_opi" class="mb-10">
            <p>あなたは、日本語OPI(Oral Proficiency Interview)テスターですか。</p>
            <v-radio-group v-model="d_facesheet.is_opi" row>
              <v-radio
                v-for="n in 3"
                :key="n"
                :label="`${is_opi_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
          </div>

          <div fluid v-if="t_facesheet.is_teacher" class="mb-10">
            <p>あなたは、日本語教師ですか。（この場合の日本語教師は有償で日本語を教えている方とします。よってボランティアは含めません。）</p>
            <v-radio-group v-model="d_facesheet.is_teacher" row>
              <v-radio
                v-for="n in 2"
                :key="n"
                :label="`${is_teacher_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
            <v-select
              v-if="d_facesheet.is_teacher===1"
              v-model="d_facesheet.teaching_years"
              :items="teaching_years_selection"
              label="経験年数"
              class="ma-2"
            ></v-select>
          </div>

          <div fluid v-if="t_facesheet.teach_speaking_experience && d_facesheet.is_teacher===1" class="mb-10">
            <p>スピーキングや会話の授業を担当したことがありますか。</p>
            <v-radio-group v-model="d_facesheet.teach_speaking_experience" row>
              <v-radio
                v-for="n in 2"
                :key="n"
                :label="`${teach_speaking_experience_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
            <v-select
              v-if="d_facesheet.teach_speaking_experience===1"
              v-model="d_facesheet.teach_speaking_years"
              :items="teaching_years_selection"
              label="経験年数"
              class="ma-2"
            ></v-select>
          </div>

          <div fluid v-if="t_facesheet.country && d_facesheet.is_teacher===1" class="mb-10">
            <p>現在教えている地域・国はどこですか。</p>
            <v-radio-group v-model="d_facesheet.is_japan" row>
              <v-radio
                v-for="n in 2"
                :key="n"
                :label="`${is_japan_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
            <v-text-field
              v-if="d_facesheet.is_japan===2"
              v-model="d_facesheet.country_name"
              label="国・地域名"
              required
              class="mb-10"
            ></v-text-field>
          </div>

          <div fluid v-if="t_facesheet.country && d_facesheet.is_teacher===1" class="mb-10">
            <p>現在教えている機関はどちらですか。</p>
            <v-radio-group v-model="d_facesheet.institute" row>
              <v-radio
                v-for="n in 5"
                :key="n"
                :label="`${institute_selection[n-1]}`"
                :value="n"
              ></v-radio>
            </v-radio-group>
            <v-text-field
              v-if="d_facesheet.institute===5"
              v-model="d_facesheet.other_institute"
              label="具体的にご記入下さい"
              required
              class="mb-10"
            ></v-text-field>
          </div>
          

          <div align="center">
            <v-btn color="primary" @click="next">次へ進む</v-btn>
          </div>

        </v-form>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import FacesheetApi from '@/plugins/axios/modules/facesheet'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',

  data() {
    return {
      t_facesheet: {},
      d_facesheet: {
        name: null,
        email: null,
        gender: null,
        age: null,
        is_student: null,
        department_type: null,
        department_name: null,
        is_opi: null,
        is_teacher: null,
        teaching_years: null,
        teach_speaking_experience: null,
        teach_speaking_years: null,
        is_japan: null,
        country_name: null,
        institute: null,
        other_institute: null
      },
      gender_selection: ["男性", "女性", "その他", "回答しない"],
      age_selection: ["18-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-60", "60-"],
      is_student_selection: ["大学生である", "大学院生である", "大学生でも大学院生でもない"],
      department_type_selection: ["理系", "文系"],
      is_opi_selection: ["日本語OPIテスターである", "日本語OPI元テスター", "日本語OPIテスターではない"],
      is_teacher_selection: ["日本語教師である", "日本語教師ではない（１年未満の場合はこちら。）"],
      teaching_years_selection: [...Array(40).keys()].map(i => ++i),
      teach_speaking_experience_selection: ["担当したことがある", "担当したことがない（１年未満の場合はこちら。）"],
      is_japan_selection: ["日本", "日本以外"],
      institute_selection: ["日本語学校", "高等教育機関（大学など）", "中等教育機関（中学や高校など）", "プライベート", "その他"]
    }
  },

  mounted() {
    FacesheetApi.getTFacesheet(this.$route.params.id).then((res) => {
      this.t_facesheet = res
      FacesheetApi.getDFacesheet(this.t_facesheet.id).then((res) => {
        console.log(res)
        this.d_facesheet = res
      })
    })
  },

  methods: {
    next() {
      if (this.d_facesheet.id) {
        FacesheetApi.updateDFacesheet(this.$route.params.id, this.d_facesheet).then((res)=>{
          WorkflowApi.complete(this.$route.params.id).then((res) => {
            this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
          })
        })
      } else {
        FacesheetApi.createDFacesheet(this.$route.params.id, this.d_facesheet).then((res)=>{
          WorkflowApi.complete(this.$route.params.id).then((res) => {
            this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
          })
        })
      }
    }
  }
}
</script>