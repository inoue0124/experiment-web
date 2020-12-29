<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <iframe 
        :src="`${form_url}`"
        width="700" height="800" frameborder="0" marginheight="0" marginwidth="0"
      >
        読み込んでいます…
      </iframe>

      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'

export default {
  middleware: 'redirector',

  data() {
    return {
      form_url: "https://docs.google.com/forms/d/e/1FAIpQLSfcbMBs6cSXpzfqvtLo0kCSlxotB_5SYZnRtjz49GziPOus5w/viewform?embedded=true"
    }
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