<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="12">
        <h1 class="main-heading mb-8 text-center">設定</h1>

        <v-row justify="center">
          <v-col cols="12" sm="10" md="8">
            <v-card class="pa-4">
              <h2 class="mb-3 text-center">username</h2>

              <v-list>
                <v-list-item to="/settings/profile">
                  <v-list-item-icon>
                    <v-icon>mdi-account-edit</v-icon>
                  </v-list-item-icon>
                  <v-list-item-content>
                    <v-list-item-title>プロフィール編集</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>

                <v-list-item to="/delete">
                  <v-list-item-icon>
                    <v-icon>mdi-account-remove</v-icon>
                  </v-list-item-icon>
                  <v-list-item-content>
                    <v-list-item-title>アカウント削除</v-list-item-title>
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

            </v-card>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>