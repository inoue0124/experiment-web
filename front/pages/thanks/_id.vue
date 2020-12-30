<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card class="pa-md-10 mt-16">
        <v-card-title class="headline">
          実験にご参加いただき誠にありがとうございました。
        </v-card-title>

        <v-card-text>
          お問い合わせは
          <a href="mailto:example@mail.com" target="_blank">example@mail.com</a>
          までお願いします。
        </v-card-text>

      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'

export default {
  middleware: 'redirector',

  data() {
    return {}
  },

  methods: {
  }
}
</script>