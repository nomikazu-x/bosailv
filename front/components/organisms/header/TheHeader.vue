<template>
  <v-app-bar app clipped-left color="#FFFCFC" dense fixed>
    <v-app-bar-nav-icon @click="onClick()" />

    <NuxtLink to="/" class="toolbar-title d-flex text-decoration-none">
      <v-toolbar-title
        v-if="$vuetify.breakpoint.width > 226"
        :style="{ 'max-width': ($vuetify.breakpoint.width - 226) + 'px' }"
        class="ml-1 align-self-center d-inline-block text-truncate text--secondary"
      >
        <v-img :src="require('@/assets/images/ヘッダーロゴ.jpg')" />
      </v-toolbar-title>
    </NuxtLink>
    <v-spacer />
    <template v-if="!$auth.loggedIn">
      <v-btn to="/signin" text rounded exact nuxt>
        <v-icon>mdi-login</v-icon>
        <div class="hidden-sm-and-down">ログイン</div>
      </v-btn>
      <v-btn to="/signup" text rounded exact nuxt>
        <v-icon>mdi-account-plus</v-icon>
        <div class="hidden-sm-and-down">アカウント登録</div>
      </v-btn>
    </template>
    <template v-else>
      <v-menu offset-y>
        <template #activator="{ on, attrs }">
          <v-btn class="d-inline-block" max-width="400px" style="text-transform: none" text v-bind="attrs" v-on="on">
            <v-avatar size="32px">
              <v-img id="user_image" :src="$auth.user.image_url.small" />
            </v-avatar>
            <div class="text-truncate hidden-sm-and-down">{{ $auth.user.name }}</div>
          </v-btn>
        </template>
        <v-list>
          <v-list-item :to="`/users/${$auth.user.username}`" exact nuxt>
            <v-list-item-icon>
              <v-icon>mdi-home</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>マイページ</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item to="/settings/profile" exact nuxt>
            <v-list-item-icon>
              <v-icon>mdi-cog</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>設定</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item v-if="$auth.loggedIn && $auth.user.admin === true" to="/admin" exact nuxt>
            <v-list-item-icon>
              <v-icon>mdi-account-cog</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>管理者ページ</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item exact nuxt @click="onSignOut()">
            <v-list-item-icon>
              <v-icon>mdi-logout</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>ログアウト</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn to="/infomations" text rounded exact nuxt>
        <v-badge :content="$auth.user.infomation_unread_count" :value="$auth.user.infomation_unread_count" color="red" overlap>
          <v-icon>mdi-bell</v-icon>
        </v-badge>
      </v-btn>
    </template>
  </v-app-bar>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Header',
  mixins: [Application],

  methods: {
    onClick () {
      this.$store.commit('sidebar/onDrawer')
    },
    onSignOut () {
      this.processing = true
      this.signOut('auth.signed_out')
    }
  }
}
</script>

<style lang="scss" scoped>
.toolbar-title {
  color: inherit !important;
  text-decoration: inherit;
}
</style>
