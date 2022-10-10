<template>
  <BaseTitleCard title="ユーザーメニュー">
    <v-list>
      <v-list-item :to="`/users/${$route.params.username}`">
        <v-list-item-icon>
          <v-icon>mdi-book-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>防災タスク一覧</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item :to="`/users/${$route.params.username}/genres`">
        <v-list-item-icon>
          <v-icon>mdi-pencil-box-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>マイ記事一覧</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item :to="`/users/${$route.params.username}/shelters`">
        <v-list-item-icon>
          <v-icon>mdi-exit-run</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>マイ避難所一覧</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/settings/profile">
        <v-list-item-icon>
          <v-icon>mdi-cog</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>設定</v-list-item-title>
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
  name: 'UserMenusCard',

  components: {
    BaseTitleCard
  }
}
</script>
