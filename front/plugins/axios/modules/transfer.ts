import { axios } from '../index.js';

export default {

  getTransfer(id:number) {
    return axios.$get(`transfers/${id}`)
  }
}