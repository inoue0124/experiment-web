import SessionApi from '@/plugins/axios/modules/session'

export default function ({ redirect }) {
  return new Promise((resolve) => {
    SessionApi.isAuthenticated()
    .then(()=> {
      return resolve()
    })
    // 未認証の場合
    .catch(()=>{
      return redirect('/')
    })
  })
}