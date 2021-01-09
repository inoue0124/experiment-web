<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="6" md="6">
      <StepProgress class="mb-10"></StepProgress>

      <v-card class="pa-md-10 mt-16">
        <v-card-title class="headline">
          実験にご参加いただき誠にありがとうございました。
        </v-card-title>

        <v-card-text>
          <p>
            本実験の内容に関するお問い合わせは、下記の連絡先へお願いします。<br>
          </p>

          <p>
            ボイクマン総子(Ph.D.)<br>
            東京大学 大学院総合文化研究科<br>
            グローバルコミュニケーション研究センター、教授<br>
            153-8902　東京都目黒区駒場3-8-1 東京大学<br>
            beuckmann@g.ecc.u-tokyo.ac.jp
          </p>
        </v-card-text>

      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',

  data() {
    return {}
  },

  methods: {
  }
}
</script>