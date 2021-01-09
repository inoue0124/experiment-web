<template>
  <v-data-table
    :headers="headers"
    :items="facesheets"
    class="elevation-1 my-16"
  >

    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>フェイスシート一覧</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          class="mb-2 mr-2"
          @click="downloadCSV()"
        >
          CSVダウンロード
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:[`item.gender`]="{ item }">
      <span>{{ gender_selection[item.gender-1] }}</span>
    </template>

    <template v-slot:[`item.age`]="{ item }">
      <span>{{ age_selection[item.age-1] }}</span>
    </template>

    <template v-slot:[`item.is_student`]="{ item }">
      <span>{{ is_student_selection[item.is_student-1] }}</span>
    </template>

    <template v-slot:[`item.department_type`]="{ item }">
      <span>{{ department_type_selection[item.department_type-1] }}</span>
    </template>

    <template v-slot:[`item.is_opi`]="{ item }">
      <span>{{ is_opi_selection[item.is_opi-1] }}</span>
    </template>

    <template v-slot:[`item.is_teacher`]="{ item }">
      <span>{{ is_teacher_selection[item.is_teacher-1] }}</span>
    </template>

    <template v-slot:[`item.teach_speaking_experience`]="{ item }">
      <span>{{ teach_speaking_experience_selection[item.teach_speaking_experience-1] }}</span>
    </template>

    <template v-slot:[`item.is_japan`]="{ item }">
      <span>{{ is_japan_selection[item.is_japan-1] }}</span>
    </template>

    <template v-slot:[`item.institute`]="{ item }">
      <span>{{ institute_selection[item.institute-1] }}</span>
    </template>

    <template v-slot:[`item.created_at`]="{ item }">
      <span>{{ new Date(item.created_at).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="toEdit(item)">mdi-pencil</v-icon>
    </template>

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import FacesheetApi from '@/plugins/axios/modules/facesheet'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: '実験ID', value: 't_experiment_id'},
      { text: '実験名', value: 't_experiment_name' },
      { text: 'ユーザID', value: 't_user_id' },
      { text: '名前', value: 'name' },
      { text: 'メールアドレス', value: 'email' },
      { text: '性別', value: 'gender' },
      { text: '年齢', value: 'age' },
      { text: '学生かどうか', value: 'is_student' },
      { text: '文理', value: 'department_type' },
      { text: '学部名', value: 'department_name' },
      { text: 'OPIかどうか', value: 'is_opi' },
      { text: '教師かどうか', value: 'is_teacher' },
      { text: '経験年数', value: 'teaching_years' },
      { text: 'スピーキング指導経験', value: 'teach_speaking_experience' },
      { text: 'スピーキング指導経験年数', value: 'teach_speaking_years' },
      { text: '日本かどうか', value: 'is_japan' },
      { text: '国・地域名', value: 'country_name' },
      { text: '機関', value: 'institute' },
      { text: 'その他の機関名', value: 'other_institute'},
      { text: '作成日時', value: 'created_at'}
    ],
    facesheets: [],
    gender_selection: ["男性", "女性", "その他", "回答しない"],
    age_selection: ["18-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-60", "60-"],
    is_student_selection: ["大学生である", "大学院生である", "大学生でも大学院生でもない"],
    department_type_selection: ["理系", "文系"],
    is_opi_selection: ["日本語OPIテスターである", "日本語OPI元テスター", "日本語OPIテスターではない"],
    is_teacher_selection: ["日本語教師である", "日本語教師ではない"],
    teaching_years_selection: [...Array(40).keys()].map(i => ++i),
    teach_speaking_experience_selection: ["担当したことがある", "担当したことがない"],
    is_japan_selection: ["日本", "日本以外"],
    institute_selection: ["日本語学校", "高等教育機関", "中等教育機関", "プライベート", "その他"]
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      FacesheetApi.listDFacesheets().then((res) => {
        this.facesheets = res
        console.log(res)
      })
    },

    downloadCSV () {
      var csv = '\ufeff' + '実験ID,実験名,ユーザID,名前,メールアドレス,性別,年齢,学生かどうか,文理,学部名,OPIかどうか,教師かどうか,経験年数,スピーキング指導経験,スピーキング指導経験年数,日本かどうか,国・地域名,機関,その他の機関名,作成日時\n'
      this.facesheets.forEach(el => {
        var line = 
        el['t_experiment_id'] + ',' 
        + el['t_experiment_name'] + ',' 
        + el['t_user_id'] + ',' 
        + el['name'] + ',' 
        + el['email'] + ',' 
        + this.gender_selection[el['gender']-1] + ',' 
        + this.age_selection[el['age']-1] + ','
        + this.is_student_selection[el['is_student']-1] + ','
        + this.department_type_selection[el['department_type']-1] + ','
        + el['department_name'] + ','
        + this.is_opi_selection[el['is_opi']-1] + ','
        + this.is_teacher_selection[el['is_teacher']-1] + ','
        + el['teaching_years'] + ','
        + this.teach_speaking_experience_selection[el['teach_speaking_experience']-1] + ','
        + el['teach_speaking_years'] + ','
        + this.is_japan_selection[el['is_japan']-1] + ','
        + el['country_name'] + ','
        + this.institute_selection[el['institute']-1] + ','
        + el['other_institute'] + ','
        + el['created_at'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'facesheet_list.csv'
      link.click()
    }
  },
}
</script>