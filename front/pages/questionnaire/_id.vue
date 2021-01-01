<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="6" md="8">

      <h1 align="center" class="mb-16">アンケート</h1>

      <iframe 
        :src="`${form_url}`"
        width="100%" height="800" frameborder="0" marginheight="0" marginwidth="0"
      >
        読み込んでいます…
      </iframe>

      <div align="center">
        <v-btn color="primary" @click="next">次へ進む</v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import QuestionnaireApi from '@/plugins/axios/modules/questionnaire'

export default {
  middleware: 'redirector',

  data() {
    return {
      form_url: ""
    }
  },

  mounted() {
    QuestionnaireApi.getQuestionnaire(this.$route.params.id).then((res) => {
      this.form_url = res.url
    })
  },

  methods: {
    next() {
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    }
  }
}
</script>