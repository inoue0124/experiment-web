<template>
  <div v-cloak @drop.prevent="addDropFile" @dragover.prevent>
    <v-alert v-if="message" border="left" color="error" dark dense>
      {{ message }}
    </v-alert>

    <v-file-input
      multiple
      show-size
      @change="selectFile"
      prepend-icon=""
      filled
      v-model="currentFiles"
      label="ファイルを選択する"
      :accept="file_type"
    >
      <template v-slot:prepend-inner>
      </template>
      <template v-slot:selection="{ index, text }">
        <v-chip dark>
          {{text}}
          <v-progress-circular
            :rotate="-90"
            :size="20"
            :width="10"
            :value="progresses[index]"
            color="teal"
            :indeterminate="progresses[index]===0"
            class="ml-2"
          >
          </v-progress-circular>
        </v-chip>
      </template>
      <template v-slot:append>
        <v-btn color="success" dark small @click="upload">
          アップロード<v-icon right dark>mdi-cloud-upload</v-icon>
        </v-btn>
      </template>
    </v-file-input>
  </div>
</template>

<script>
import AwsApi from '@/plugins/axios/modules/aws'

export default {
  props: {
    directory: String,
    file_type: String
  },
  data() {
    return {
      currentFiles: undefined,
      progresses: [],
      message: "",
    };
  },
  methods: {
    selectFile(files) {
      this.currentFiles = files
      this.progresses = new Array(files.length)
      this.message = ""
    },
    addDropFile(e) {
      this.selectFile(Array.from(e.dataTransfer.files))
    },
    upload() {
      if (!this.currentFiles) {
        this.message = "ファイルを選択してください！"
        return
      }
      this.message = ""
      
      this.currentFiles.forEach((file, index)=>{
        AwsApi.uploadByPresigned(this.directory+file.name, file, (event) => {
          this.progresses.splice(index, 1, Math.round((100 * event.loaded) / event.total))
        })
        .catch((e) => {
          this.progresses.splice(index, 1, 0)
          this.message = `${file.name}のアップロードに失敗しました。`
        })
      })
    }
  }
};
</script>

<style scoped>
</style>