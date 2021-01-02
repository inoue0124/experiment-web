import { axios } from '../index.js';

export default {
  getPresignedUrl(workflow_id, filename) {
    return axios.$post(
      `presigned`,
      {
        workflow_id: workflow_id,
        filename: filename
      }
    )
  },

  async upload(workflow_id, file, onUploadProgress) {
    
    const presignedObject = await axios.$post(
      `presigned`,
      {
        workflow_id: workflow_id,
        filename: file.name
      }
    )
    .then(response => {return response})
    .catch(e => console.log(e.message))

    let formData = new FormData();
    
    for (const key in presignedObject.fields) {
      formData.append(key, presignedObject.fields[key])
    }
    formData.append("file", file);

    return axios.$post(presignedObject.url, formData, {
      headers: {
        "Content-Type": "multipart/form-data"
      },
      onUploadProgress
    })
  },

  getFiles() {
    return axios.$get("/files");
  }
}