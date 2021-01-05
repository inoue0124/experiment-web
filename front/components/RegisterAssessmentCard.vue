<template>
  <v-card>
    <v-card-text>
      <v-select
        v-model="num_steps"
        :items="step_selection"
        label="ステップ数"
        class="ma-2"
      ></v-select>

      <div style="text-align:center;"><v-icon>mdi-chevron-triple-down</v-icon></div>

      <div v-for="n in num_steps" :key="n">
        {{`ステップ${n}`}}
        <v-row>
          <v-col cols="12" sm="4" md="4">
            <v-checkbox
              v-model="is_practice_list[n-1]"
              label="練習モードにする"
            ></v-checkbox>
          </v-col>

          <v-col cols="12" sm="4" md="4">
            <v-select
              v-model="point_list[n-1]"
              :items="point_selection"
              label="ポイント数"
              class="ma-2"
              @change="insertListToCriteria(n-1, point_list[n-1])"
            ></v-select>
          </v-col>

          <v-col cols="12" sm="4" md="4">
            <v-select
              v-model="sample_list[n-1]"
              :items="sample_selection"
              :label="`サンプル数`"
              class="ma-2"
            ></v-select>
          </v-col>
        </v-row>

         <v-row>
          <v-col
            v-for="key in point_list[n-1]" 
            :key="key"
          >
            <v-text-field
              :label="`評価値${key}のラベル`"
              v-model="criteria_list[n-1][key-1]"
              outlined
            ></v-text-field>
          </v-col>
        </v-row>

      </div>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      num_steps: 1,
      sample_list: [30],
      point_list: [6],
      is_practice_list: [false],
      criteria_list: [["L1","L2","L3","L4","L5","L6"]],
      step_selection: [...Array(6).keys()],
      sample_selection: [...Array(101).keys()],
      point_selection: [...Array(10).keys()],
    }
  },
  methods : {
    insertListToCriteria(n, num_criteria) {
      this.criteria_list[n] = [...Array(num_criteria)]
    }
  }
}
</script>