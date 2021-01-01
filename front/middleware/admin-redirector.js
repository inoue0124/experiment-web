import SessionApi from '@/plugins/axios/modules/session'

export default function ({ redirect }) {
  return new Promise((resolve) => {
    SessionApi.isAuthenticated()
    .then((session)=> {
      if (session.data.user_type===1) {
        return redirect('/')
      }
      return resolve()
    })
    // 未認証の場合
    .catch(()=>{
      return redirect('/')
    })
  })
}