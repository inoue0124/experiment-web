<template>
  <v-app dark>
    <v-navigation-drawer
      :mini-variant="miniVariant"
      :clipped="false"
      fixed
      app
      dark
    >
      <v-list-item>
        <v-list-item-title class="title">
          {{title}}
        </v-list-item-title>
      </v-list-item>

      <v-divider />

      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar :clipped-left="false" fixed dense app color="#ffffff">
      <v-btn icon @click.stop="miniVariant = !miniVariant">
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <v-spacer />
      <v-btn icon @click="openConfirmDialog">
        <v-icon>mdi-logout</v-icon>
      </v-btn>
      <ConfirmDialog
        ref="logout"
        title="ログアウト確認"
        message="ログアウトします。よろしいですか？"
        buttonMessage="ログアウト"
        @confirm="confirmLogout"
        color="primary"
      >
      </ConfirmDialog>
    </v-app-bar>

    <v-main>
      <v-container id="fontSetting">
        <nuxt />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'
import SessionApi from '@/plugins/axios/modules/session'

export default {
  components: {
    ConfirmDialog
  },

  data() {
    return {
      items: [
        {
          icon: 'mdi-account-supervisor',
          title: 'ユーザ管理',
          to: '/admin/users',
        },
        {
          icon: 'mdi-flask-empty',
          title: '実験管理',
          to: '/admin/experiments',
        }
      ],
      miniVariant: false,
      title: '実験作成・管理システム',
    }
  },

  methods: {
    openConfirmDialog () {
      this.$refs.logout.open()
    },
    confirmLogout() {
      SessionApi.logout().then(()=>{
        this.$router.push('/')
      })
    }
  }
}
</script>

<style>
#fontSetting {
  font-family: "ヒラギノ丸ゴ Pro W4", "ヒラギノ丸ゴ Pro",
    "Hiragino Maru Gothic Pro", "ヒラギノ角ゴ Pro W3",
    "Hiragino Kaku Gothic Pro", "HG丸ｺﾞｼｯｸM-PRO", "HGMaruGothicMPRO";
}
</style>
