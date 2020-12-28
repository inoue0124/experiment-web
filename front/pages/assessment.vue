<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="10" md="10">

      <v-simple-table>
        <template v-slot:default>
          <tbody>
            <tr
              v-for="item in samples"
              :key="item.key"
            >
              <td>
                <audio controls>
                  <source :src="item.url" type="audio/mpeg">
                </audio>
              </td>

              <td>
                <v-radio-group v-model="item.score" row>
                  <div v-for="val in 7" :key="val">
                    <v-radio :value=val></v-radio>
                  </div>
                </v-radio-group>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>

      <v-btn color="primary" @click="prev">前へ戻る</v-btn>
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
      samples: {
        1 : {
          url: "a",
          score: 0
        },
        2 : {
          url: "",
          score: 0
        },
        3 : {
          url: "",
          score: 0
        },
        4 : {
          url: "",
          score: 0
        }
      }
    }
  },
  methods: {
    next() {
      WorkflowApi.complete().then((res) => {
        this.$router.push(res.name.toLowerCase())
      })
    },
    prev() {
      WorkflowApi.undo().then((res) => {
        this.$router.push(res.name.toLowerCase())
      })
    }
  }
}
</script>

<style lang="scss">
  td {
    background: #f0f8ff;
    border-bottom: none !important;
  }
  tr:nth-child(odd) td {
      background: #fff;
  }
</style>