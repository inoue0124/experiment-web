import { axios } from '../index.js';

export default {

  getInstruction(id:number) {
    return axios.$get(`instructions/${id}`)
  },
}