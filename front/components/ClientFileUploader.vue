<template>
  <div v-cloak @drop.prevent="addDropFile" @dragover.prevent>
    <v-alert v-if="message" border="left" color="error" dark dense>
      {{ message }}
    </v-alert>

    <div style="position:relative;">
      <v-file-input
        show-size
        prepend-icon=""
        outlined
        @change="selectFile"
        v-model="currentFile"
        label="クリックしてファイルを選択 or ドラッグ＆ドロップ"
        :accept="file_type"
        height="500px"
      >
        <template v-slot:selection="{ index, text }">
          <v-chip dark>
            {{text}}
            <v-progress-circular
              :rotate="-90"
              :size="20"
              :width="10"
              :value="progress"
              color="teal"
              :indeterminate="progress===0"
              class="ml-2"
              v-if="progress!==100"
            >
            </v-progress-circular>
            <v-icon 
              color="teal" 
              v-if="progress===100">
              mdi-check-circle
            </v-icon>
          </v-chip>
        </template>
      </v-file-input>

      <v-img 
        v-if="!this.currentFile"
        :src="require('@/assets/upload.png')" 
        width="30%" 
        style="position:absolute;top:30%;left:35%;pointer-events: none;"
      ></v-img>
    </div>
  </div>
</template>

<script>
import AwsApi from '@/plugins/axios/modules/aws'

export default {
  props: {
    file_key: String,
    file_type: String,
    file_name: String
  },
  data() {
    return {
      currentFile: undefined,
      progress: 0,
      message: "",
    };
  },
  methods: {
    selectFile(files) {
      this.currentFile = files
      if (this.currentFile===null) {
        return
      }
      this.progress = 0
      this.message = ""
      this.upload()
    },
    addDropFile(e) {
      this.selectFile(...Array.from(e.dataTransfer.files))
    },
    upload() {
      if (!this.currentFile) {
        this.message = "ファイルを選択してください！"
        return
      }
      if (this.currentFile.name !== this.file_name) {
        this.message = this.file_name + "を選択して下さい！"
        this.currentFile = null
        return
      }
      this.message = ""
      
      AwsApi.upload(this.file_key, this.currentFile, (event) => {
        this.progress = Math.round((100 * event.loaded) / event.total)
      })
      .catch((e) => {
        this.progress = 0
        this.message = `${this.currentFile.name}のアップロードに失敗しました。`
      })
    }
  }
};
</script>

<style scoped>
</style>