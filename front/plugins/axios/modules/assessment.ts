import { axios } from '../index.js';

export default {

  getAssessmentWork(id:number) {
    return axios.$get(`assessments/${id}`)
  }
}