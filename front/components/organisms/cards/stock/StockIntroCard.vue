<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">被災したときの備えをしよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          電気やガス、水道などのライフラインが止まった場合や、避難生活が必要になったときのために防災用品を備えましょう。
        </v-card-text>
      </v-col>
      <v-col cols="12" class="mt-5">
        <div class="main-heading font-weight-bold" style=" color: #117768;">
          <v-icon class="mr-2" color="#117768">mdi-checkbox-marked-circle</v-icon>
          あなたの家族に必要な備蓄品・持ち出し品をチェックしよう！
        </div>
        <v-list>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-1-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">下の「家族情報を入力する」をクリックして、家族情報登録ページに移動します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-2-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">家族情報を登録して、「備蓄品リストを確認する」をクリックして確認しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item v-if="!$auth.loggedIn">
            <v-icon class="mr-2" color="#FFD54F">mdi-alert</v-icon>
            <v-list-item-content>
              <v-list-item-subtitle class="wrap-text">
                <NuxtLink to="/signup">ログイン</NuxtLink>しなければ表示されません。
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <div v-else class="text-center">
            <GreenBtn to="stocks/edit" class="my-2" large>
              家族情報を入力する
              <v-icon>mdi-chevron-right</v-icon>
            </GreenBtn>
          </div>
        </v-list>
      </v-col>
      <v-col cols="12">
        <v-sheet outlined color="#FFD54F" class="pa-1">
          <v-card flat>
            <v-card-title>
              ポイント獲得方法
            </v-card-title>
            <v-list>
              <v-list-item>
                <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                <v-list-item-content>
                  <v-list-item-title class="wrap-text">各項目について備蓄できたら、「完了！」をクリックして各1ポイント獲得！</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </v-sheet>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'FamilyRuleIntroCard',

  components: {
    GreenBtn
  }
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
