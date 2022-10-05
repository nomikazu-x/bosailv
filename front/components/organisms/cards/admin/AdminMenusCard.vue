<template>
  <BaseTitleCard title="管理者メニュー">
    <v-list>
      <v-list-item to="/admin/infomations">
        <v-list-item-icon>
          <v-icon>mdi-bell</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>お知らせ一覧</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/infomations/new">
        <v-list-item-icon>
          <v-icon>mdi-bell-plus</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>お知らせ作成</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/genres">
        <v-list-item-icon>
          <v-icon>mdi-book-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>ジャンル一覧・編集</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/genres/new">
        <v-list-item-icon>
          <v-icon>mdi-book-plus-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>ジャンル作成</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/tasks">
        <v-list-item-icon>
          <v-icon>mdi-book-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>防災タスク一覧・編集</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/tasks/new">
        <v-list-item-icon>
          <v-icon>mdi-book-plus-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>防災タスク作成</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/articles/search">
        <v-list-item-icon>
          <v-icon>mdi-pencil-box-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>記事検索</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/admin/users/search">
        <v-list-item-icon>
          <v-icon>mdi-account-filter</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>ユーザー検索</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-divider class="mb-6" />

      <v-list-item to="/home">
        <v-list-item-icon>
          <v-icon>mdi-home</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>トップへ戻る</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'

export default {
  name: 'AdminMenusCard',

  components: {
    BaseTitleCard
  }
}
</script>
