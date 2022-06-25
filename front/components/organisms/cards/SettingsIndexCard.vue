<template>
  <BaseTitleCard :title="$auth.user.name">
    <v-list>
      <v-list-item to="/settings/profile">
        <v-list-item-icon>
          <v-icon>mdi-account-edit</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>プロフィール編集</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/settings/password">
        <v-list-item-icon>
          <v-icon>mdi-lock</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>パスワード変更</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/settings/email">
        <v-list-item-icon>
          <v-icon>mdi-email</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>メールアドレス変更</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item to="/settings/deactivate">
        <v-list-item-icon>
          <v-icon>mdi-account-remove</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>退会する</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-divider class="mb-6" />

      <v-list-item to="/">
        <v-list-item-icon>
          <v-icon>mdi-home</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>マイページへ戻る</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </BaseTitleCard>
</template>
