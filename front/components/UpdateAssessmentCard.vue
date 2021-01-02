<template>
  <v-card>
    <v-card-text>
      <v-row>
        <v-col cols="12" sm="4" md="4">
          <v-checkbox
            v-model="assessment.is_practice"
            label="練習モードにする"
          ></v-checkbox>
        </v-col>

        <v-col cols="12" sm="4" md="4">
          <v-select
            v-model="assessment.point"
            :items="point_selection"
            label="ポイント数"
            class="ma-2"
          ></v-select>
        </v-col>

        <v-col cols="12" sm="4" md="4">
          <v-select
            v-model="assessment.num_files"
            :items="sample_selection"
            :label="`サンプル数`"
            class="ma-2"
          ></v-select>
        </v-col>
      </v-row>

      <v-text-field
        label="PDFのURL"
        v-model="assessment.pdf_url"
      ></v-text-field>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    assessment_prop: Object
  },
  data() {
    return {
      assessment: {
        is_practice: false,
        point: 0,
        pdf_url: "",
        num_files: 0
      },
      point_selection: [...Array(10).keys()],
      sample_selection: [...Array(101).keys()]
    }
  },
  mounted() {
    if (this.assessment_prop!==undefined) {
      this.assessment = this.assessment_prop
    }
  }
}
</script>