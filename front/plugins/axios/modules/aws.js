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

  downloadFile(isDisclosed, key, filename, type) {
    return axios.$post(
      `file`,
      {
        isDisclosed: isDisclosed,
        key: key,
        filename: filename,
        type: type
      },
      { 
        responseType : 'blob' 
      }
    )
  },

  deleteFile(key) {
    return axios.$delete(`file?key=${key}`)
  },

  downloadZipFile(prefix) {
    return axios.$post(
      `files/zip`,
      {
        prefix: prefix
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

    return axios.$post(`/files`, formData,
      {
        headers: { "Content-Type": "multipart/form-data" },
        onUploadProgress: onUploadProgress
      }
    )
  },

  listUndisclosedFiles(prefix) {
    return axios.$post("/undisclosedFiles", {prefix: prefix});
  },

  listDisclosedFiles(prefix) {
    return axios.$post("/disclosedFiles", {prefix: prefix});
  }
}