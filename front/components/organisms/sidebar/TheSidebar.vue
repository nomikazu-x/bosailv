<template>
  <v-navigation-drawer v-model="drawer" clipped app width="300">
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
      </v-list-item-group>

      <v-list-item-group>
        <v-subheader>防災タスク</v-subheader>
        <v-divider />
        <v-list-item to="/hazard_maps" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-book-multiple</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>ハザードマップ検索</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/shelters" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-exit-run</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>避難所検索</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/sns_tasks" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-twitter</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>防災SNS</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/house_tasks" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-home</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>おうち防災</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/family_rule" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-human-male-female-child</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>家族会議</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/emergency_contacts" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-phone-in-talk</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>緊急時連絡先</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/stocks" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-archive</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>備蓄品</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>

      <v-list-group
        v-model="active"
        prepend-icon="mdi-pencil-box-multiple"
        no-action
      >
        <template #activator>
          <v-list-item-content>
            <v-list-item-title>災害時役立つ記事</v-list-item-title>
          </v-list-item-content>
        </template>

        <v-list-item to="/articles" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-pencil-box-multiple</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>一覧</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/genres" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-pencil-box-multiple</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>ジャンル別</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item to="/articles/search" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-magnify</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>検索</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item v-if="$auth.loggedIn" to="/articles/new" exact nuxt>
          <v-list-item-icon>
            <v-icon>mdi-pencil</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>作成</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-group>

      <v-list-item-group>
        <v-subheader>その他</v-subheader>
        <v-divider />
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
        <v-list-item v-if="$auth.loggedIn" to="/settings/profile" exact nuxt>
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
      </v-list-item-group>
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
      menu: false,
      active: true
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
