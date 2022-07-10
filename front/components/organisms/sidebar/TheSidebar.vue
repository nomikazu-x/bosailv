<template>
  <v-navigation-drawer v-model="drawer" clipped fixed app>
    <v-list>
      <v-list-item-group>
        <v-list-item v-if="!$auth.loggedIn" to="/signin" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-login</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>ログイン</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item v-if="!$auth.loggedIn" to="/signup" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-account-plus</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>アカウント登録</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/infomations" exact nuxt>
          <v-list-item-icon>
            <v-badge v-if="$auth.loggedIn" :content="$auth.user.infomation_unread_count" :value="$auth.user.infomation_unread_count" color="red" overlap>
              <v-icon>mdi-bell</v-icon>
            </v-badge>
            <v-badge v-else>
              <v-icon>mdi-bell</v-icon>
            </v-badge>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>お知らせ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/articles" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-pencil</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>記事一覧</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/articles/search" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-magnify</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>記事検索</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item v-if="$auth.loggedIn" to="/articles/new" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-pencil</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>記事作成</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-divider />
        <v-list-item v-if="$auth.loggedIn" to="/settings/profile" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-cog</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>設定</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>

      <div v-if="$auth.loggedIn" class="card-position">
        <v-menu top offset-x transition="scroll-x-transition">
          <template #activator="{ on, attrs }">
            <v-card outlined v-bind="attrs" v-on="on">
              <v-list-item three-line @click="menu = !menu">
                <v-list-item-avatar size="50">
                  <v-img :src="$auth.user.image_url.medium" size="50" />
                </v-list-item-avatar>

                <v-list-item-content>
                  <div class="mb-2 overline">MYPAGE</div>
                  <v-list-item-title class="mb-1">{{ $auth.user.name }}</v-list-item-title>
                </v-list-item-content>

                <v-list-item-action>
                  <v-icon color="grey lighten-1">{{ menu ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
                </v-list-item-action>
              </v-list-item>
            </v-card>
          </template>

          <v-list dense>
            <v-list-item dense :to="`/users/${$auth.user.username}`">
              マイページ
            </v-list-item>
            <v-list-item dense @click="onSignOut()">
              ログアウト
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Sidebar',
  mixins: [Application],

  data () {
    return {
      menu: false
    }
  },
  computed: {
    drawer: {
      get () {
        return this.getDrawer
      },
      set (newVal) {
        if (this.getDrawer !== newVal) {
          this.$store.commit('sidebar/onDrawer', newVal)
        }
      }
    },
    getDrawer () {
      return this.$store.getters['sidebar/drawer']
    }
  },

  methods: {
    onSignOut () {
      this.processing = true
      this.signOut('auth.signed_out')
    }
  }
}
</script>

<style lang="scss" scoped>
.card-position {
  position: absolute;
  bottom: 0;
  left: 0;
}
</style>
