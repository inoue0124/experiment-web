import { axios } from '../index.js';

export default {

  getAssessmentWork() {
    return axios.$get(`assessments`)
  }
}