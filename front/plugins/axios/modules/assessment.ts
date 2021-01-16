import { axios } from '../index.js';

export default {

  getAssessment(id:number) {
    return axios.$get(`assessments/${id}`)
  },

  getAssessmentData(id:number) {
    return axios.$get(`assessments/data/${id}`)
  },

  updateAssessmentData(id:number, body:Object) {
    return axios.$post(`assessments/data/${id}`, body)
  },

  searchAssessments(params:Object) {
    return axios.$get(`assessments/search`, { params: params })
  },
}