<template>
  <v-card>
    <v-card-text>
      <no-ssr placeholder="エディターを読み込んでいます。">
        <vue-editor
          id="editor"
          v-model="claim_text"
        />
      </no-ssr>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    claim_text_prop: String
  },
  data() {
    return {
      claim_text: `<h1 class="ql-align-center">プレースメントのための
スピーキングテスト(STAR)研究に関する実験協力サイト
</h1><p><br></p><p><br></p><p>本実験は、プレースメントのための日本語スピーキングテストSTAR(Speaking Test of Active Reaction)の開発に関連し、実験協力者に、日本語学習者の発話を判定していただくことで、STARの有用性を検証することを目的としています。</p><p><br></p><p>実験協力者に行っていただくことは、基本的に、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答える、の３つです。所要時間は、1時間半〜２時間を見込んでいます。</p><p><br></p><p>実験への参加は任意です。参加に同意した後も2週間以内であれば、同意を取り消すことができ、それによる不利益は生じません。収集したデータおよび個人情報は破棄し、以降の研究には一切使用いたしません。</p><p><br></p><p>実験協力の謝礼として、3000円の謝礼をお支払いします。</p><p><br></p><p>本実験により取得したデータおよび個人情報は、研究目的以外に使用することはありません。学術誌、研究発表、研究書出版など結果が公開される際も、個人情報は守秘されます。データは番号を付け、匿名化し、漏洩のないよう保管いたします。データは部外秘とし、研究利用または閲覧には、研究代表者の許可を必要とします。保管データは、研究終了後5年間は保管された後、責任をもって破棄いたします。</p><p><br></p><p>また、本実験の内容に関して、ご不明な点がございましたら、ページ下部の連絡先までお問い合わせいただきますよう、お願いいたします。</p><p>
</p><p><br></p><h2 class="ql-align-center">ご承諾内容</h2><p>
下記の項目をお読みいただき、同意してくださる場合、□をクリックしてください。</p><p><br></p><ul><li>わたしは、この研究が、プレースメントのためのスピーキングテスト(STAR)研究の目的で行われること、その際、１）日本語学習者の発話を判定する、２）判定の理由をコメントする、３）実験の事後アンケートに答えることが求められることを理解しました。
</li></ul><p><br></p><ul><li>データ収集から２週間以内であれば、理由なしに協力を取りやめることができるということを理解しました。</li></ul><p><br></p><ul><li>わたしは、実験協力の所要時間と謝礼について理解しました。</li></ul><p><br></p><ul><li>わたしは、自分が提供したデータは部外秘として扱われ、漏洩がないよう注意が払われることを理解しました。</li></ul><p><br></p><ul><li>研究成果が公開されるときには、名前は伏せられ、個人が特定されるようなことがないことを理解しました。</li></ul><p><br></p><ul><li>録音、文字化などの本研究で得られた情報はボイクマン総子が保管すること、認められた研究メンバーだけがデータの利用が可能となることを理解しました。</li></ul><p><br></p><ul><li>わたしは問い合わせの連絡先について理解しました。
</li></ul>`
    }
  },
  mounted() {
    if (this.claim_text_prop!==undefined) {
      this.claim_text = this.claim_text_prop
    }
  }
}
</script>