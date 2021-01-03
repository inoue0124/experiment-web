<template>
  <v-card>
    <v-card-text>
      <v-checkbox
        v-for="(item, key) in facesheet"
        :key="key"
        v-model="facesheet[key]"
        :label="facesheet_ja[key]"
      ></v-checkbox>
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
        phone: false
      },
      facesheet_ja: {
        name: "氏名",
        phone: "電話番号"
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