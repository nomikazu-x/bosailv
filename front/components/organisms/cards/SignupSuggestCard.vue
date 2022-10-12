<template>
  <v-sheet outlined color="#117768">
    <v-card class="pa-3" tile outlined>
      <div class="font-weight-bold mt-3">
        新規登録してもっと便利にBosaiLvを使ってみよう！
      </div>
      <v-card-text>
        <ul>
          <li>防災ポイントを獲得できます</li>
          <li>記事にいいね・コメントができます</li>
          <li>タスクの達成確認ができます</li>
        </ul>
      </v-card-text>
      <v-row>
        <v-col cols="6">
          <OrangeBtn to="/signup" nuxt block>新規登録</OrangeBtn>
        </v-col>
        <v-col cols="6">
          <GreenBtn to="/signin" nuxt block>ログイン</GreenBtn>
        </v-col>
      </v-row>
    </v-card>
  </v-sheet>
</template>

<script>
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'SignupSuggestCard',

  components: {
    GreenBtn,
    OrangeBtn
  }
}
</script>
