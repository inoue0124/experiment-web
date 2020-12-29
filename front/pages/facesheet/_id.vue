<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <h1 align="center">フェイスシート</h1>

        <v-form @submit.prevent="submit">

          <v-text-field
            v-model="name"
            label="氏名"
            required
          ></v-text-field>

          <v-text-field
            v-model="phone_number"
            label="電話番号"
            required
          ></v-text-field>

          <v-btn color="primary" @click="next">次へ進む</v-btn>

        </v-form>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'

export default {
  middleware: 'redirector',

  data() {
    return {
      name: '',
      phone_number: ''
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