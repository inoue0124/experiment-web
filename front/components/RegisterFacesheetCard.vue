<template>
  <v-card>
    <v-card-text>
      <v-row>
        <div v-for="(item, key) in facesheet" :key="key">
          <v-col>
            <v-checkbox
              v-model="facesheet[key]"
              :label="facesheet_ja[key]"
            ></v-checkbox>
          </v-col>
        </div>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    facesheet_prop: Object
  },
  data() {
    return {
      facesheet: {
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
      },
      facesheet_ja: {
        name: "氏名",
        email: "メールアドレス",
        gender: "性別",
        age: "年齢",
        is_student: "学生かどうか",
        department: "学部名・研究分野",
        is_opi: "OPIテスターかどうか",
        is_teacher: "日本語教師かどうか",
        teach_speaking_experience: "スピーキングを教えた経験",
        country: "国・地域名",
        institute: "機関"
      }
    }
  },
  mounted() {
    if (this.facesheet_prop!==undefined) {
      Object.assign(this.facesheet, this.facesheet_prop)
      delete this.facesheet.id
      delete this.facesheet.t_workflow_id
      delete this.facesheet.created_at
      delete this.facesheet.updated_at
    }
  }
}
</script>