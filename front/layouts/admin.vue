<template>
  <v-app dark>
    <v-navigation-drawer
      :mini-variant="miniVariant"
      :clipped="true"
      fixed
      app
    >
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

    <v-app-bar :clipped-left="true" fixed flat app>
      <v-btn icon @click.stop="miniVariant = !miniVariant">
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <v-toolbar-title v-text="title" />
      <v-spacer />
    </v-app-bar>

    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
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
        },
        {
          icon: 'mdi-logout',
          title: 'ログアウト',
          to: '/admin/logout',
        }
      ],
      miniVariant: false,
      title: '実験作成・管理システム',
    }
  },
}
</script>

<style>
.v-list {
  padding: 0px;
}
</style>
