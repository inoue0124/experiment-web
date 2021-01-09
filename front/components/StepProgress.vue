<template>
  <v-stepper alt-labels flat>
    <v-stepper-header>
      <template v-for="(workflow, index) in workflow_list">
        <v-stepper-step
          :step="index+1"
          :key="index"
          :complete="workflow.id<=done_workflow_id"
          style="font-size:8px"
        >
          {{work_name_list[index]}}
        </v-stepper-step>
        <v-divider v-if="index < workflow_list.length - 1" :key="`div-${index}`" />
      </template>
    </v-stepper-header>
  </v-stepper>
</template>

<script>
import ExperimentApi from '@/plugins/axios/modules/experiment'

export default {
  props: {
    user_id: String
  },
  data() {
    return {
      workflow_list: [],
      work_name_list: null,
      done_workflow_id: null
    }
  },
  mounted() {
    ExperimentApi.getProgress(this.user_id).then((res)=>{
      this.workflow_list = res.wf_list
      this.work_name_list = res.work_name_list
      this.done_workflow_id = res.done_workflow_id
      // thanksを削除
      this.workflow_list.pop()
    })
  }
}
</script>