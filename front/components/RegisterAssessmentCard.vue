<template>
  <v-card>
    <v-card-text>
      <v-select
        v-model="num_steps"
        :items="steps"
        label="ステップ数"
        class="ma-2"
      ></v-select>

      <div style="text-align:center;"><v-icon>mdi-chevron-triple-down</v-icon></div>
      
      <v-select
        v-for="n in num_steps"
        :key="n"
        v-model="num_samples[n-1]"
        :items="samples"
        :label="`ステップ${n}のサンプル数`"
        class="ma-2"
      ></v-select>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      num_steps: 1,
      steps: [...Array(6).keys()],
      num_samples: [30],
      samples: [...Array(101).keys()]
    }
  },
}
</script>