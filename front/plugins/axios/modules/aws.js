import { axios } from '../index.js';

export default {

  async uploadByPresigned(key, file, onUploadProgress) {
    const presignedObject = await axios.$post(
      `presigned`,
      {
        key: key
      }
    )
    .then((response) => {return response})
    .catch((e) => console.log(e.message))

    let formData = new FormData()
    
    for (const key in presignedObject.fields) {
      formData.append(key, presignedObject.fields[key])
    }
    formData.append("file", file)

    axios.$post(presignedObject.url, formData, 
      {
        headers: { "Content-Type": "multipart/form-data" },
        onUploadProgress: onUploadProgress
      }
    )
  },

  downloadFile(key, filename, type) {
    return axios.$post(
      `download`,
      {
        key: key,
        filename: filename,
        type: type
      },
      { 
        responseType : 'blob' 
      }
    )
  },

  upload(key, file, onUploadProgress) {
    let formData = new FormData()
    formData.append("file", file)
    formData.append("key", key)

    return axios.$post(`/upload`, formData,
      {
        headers: { "Content-Type": "multipart/form-data" },
        onUploadProgress: onUploadProgress
      }
    )
  },

  getFiles() {
    return axios.$get("/files");
  }
}